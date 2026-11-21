# Rebuild Database Script for AddiScan (PowerShell)
# Source: Open Food Facts Additives Taxonomy
# URL: https://static.openfoodfacts.org/data/taxonomies/additives.json

param (
    [string]$TaxonomyUrl = "https://static.openfoodfacts.org/data/taxonomies/additives.json",
    [string]$OutputPath = "$PSScriptRoot\..\assets\data\additives.json",
    [string]$LocalTaxonomyPath = "$env:TEMP\additives.json"
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "============================================="
Write-Host " AddiScan: Rebuilding Offline Additives Database"
Write-Host " Source: Open Food Facts Taxonomy"
Write-Host "============================================="

$sourceFile = ""
$isTemp = $false

if (Test-Path $LocalTaxonomyPath) {
    Write-Host "Found local taxonomy file at $LocalTaxonomyPath. Using it."
    $sourceFile = $LocalTaxonomyPath
} else {
    $tempFile = [System.IO.Path]::GetTempFileName()
    $isTemp = $true
    Write-Host "Downloading taxonomy from $TaxonomyUrl ..."
    $wc = New-Object System.Net.WebClient
    $wc.Headers.Add("User-Agent", "AddiScan/1.0 (Mobile App; contact: azzedine)")
    $wc.DownloadFile($TaxonomyUrl, $tempFile)
    $sourceFile = $tempFile
}

try {
    Write-Host "Processing taxonomy from $sourceFile ..."
    $rawJson = [System.IO.File]::ReadAllText($sourceFile, [System.Text.Encoding]::UTF8)
    $taxonomy = ConvertFrom-Json $rawJson

    $additives = @()
    $total = 0

    # Human-readable category mapper
    function Format-Category($rawClasses) {
        if (-not $rawClasses) { return $null }
        $parts = $rawClasses -split "[,|]"
        $formatted = @()
        foreach ($p in $parts) {
            $c = $p.Trim() -replace "^en:", "" -replace "-", " "
            if ($c) {
                # Title case
                $formatted += (Get-Culture).TextInfo.ToTitleCase($c)
            }
        }
        if ($formatted.Count -gt 0) {
            return ($formatted -join " / ")
        }
        return $null
    }

    # Safety status mapping based strictly on EFSA & Open Food Facts evaluations
    function Map-SafetyStatus($item, $code) {
        $risk = if ($item.efsa_evaluation_overexposure_risk) { $item.efsa_evaluation_overexposure_risk.en } else { $null }
        $eval = if ($item.efsa_evaluation) { $item.efsa_evaluation.en } else { $null }
        $cUpper = $code.ToUpper()

        # 1. Known health alerts & EFSA/IARC classifications
        if ($cUpper -eq "E951") {
            return @{
                Status = "caution"
                Label = "Use with Caution"
                Description = "Classified as possibly carcinogenic (Group 2B) by WHO/IARC (2023). Contains phenylalanine, restricted for individuals with phenylketonuria (PKU)."
            }
        }
        if ($cUpper -eq "E171") {
            return @{
                Status = "caution"
                Label = "Use with Caution"
                Description = "Titanium dioxide was concluded by EFSA in 2021 to no longer be considered safe as a food additive due to concerns regarding genotoxicity."
            }
        }

        # 2. Direct overexposure risk flag from Open Food Facts / EFSA
        if ($risk -eq "en:high" -or $risk -eq "en:moderate") {
            return @{
                Status = "caution"
                Label = "Use with Caution"
                Description = "High or moderate overexposure risk noted in EFSA safety evaluations."
            }
        }
        if ($risk -eq "en:no") {
            return @{
                Status = "safe"
                Label = "Generally Recognized as Safe"
                Description = "Evaluated with no significant overexposure safety risk under standard usage levels."
            }
        }

        # 3. EFSA evaluation presence
        if ($eval) {
            return @{
                Status = "safe"
                Label = "Generally Recognized as Safe"
                Description = "Evaluated by EFSA and permitted for food applications within standard limit ranges."
            }
        }

        # 4. Fallback: Not evaluated
        return @{
            Status = "not_evaluated"
            Label = "Not Evaluated"
            Description = "No conclusive EFSA safety evaluation data recorded in source taxonomy."
        }
    }

    # Decide icon representation
    function Get-IconType($code, $classes, $name) {
        $c = $code.ToUpper()
        if ($c -eq "E330") { return "lemon" }
        if ($c -eq "E621" -or $c -eq "E951" -or $c -eq "E250") { return "flask" }
        if ($c -like "E150*" -or $c -like "*CARAMEL*") { return "droplet" }
        if ($c -eq "E100" -or $c -like "*CURCUMIN*") { return "curcumin" }
        if ($classes -like "*colour*") { return "droplet" }
        if ($classes -like "*preservative*" -or $classes -like "*sweetener*") { return "flask" }
        if ($classes -like "*antioxidant*") { return "leaf" }
        return "flask"
    }

    # Process all keys starting with en:e or numbers
    foreach ($prop in $taxonomy.PSObject.Properties) {
        $key = $prop.Name
        $val = $prop.Value

        # Filter to actual additive entries (e.g. en:e330, en:e621)
        if (-not ($key -match "^en:e\d+")) {
            continue
        }

        $rawKeySuffix = $key -replace "^en:e\d+", ""
        if ($rawKeySuffix) {
            $eNumber = $key -replace "^en:e", ""
            $code = "E" + $eNumber
        } else {
            $eNumber = if ($val.e_number -and $val.e_number.en) { $val.e_number.en.Trim() } else {
                $key -replace "^en:e", ""
            }
            $code = "E" + $eNumber
        }

        # Names in multiple languages
        $nameEn = if ($val.name -and $val.name.en) { $val.name.en.Trim() } else { $code }
        # Clean prefix if it has "E330 - Citric acid"
        $nameEnClean = $nameEn -replace "^E\d+[a-z]?\s*[-:]\s*", ""

        $nameFr = if ($val.name -and $val.name.fr) { $val.name.fr.Trim() -replace "^E\d+[a-z]?\s*[-:]\s*", "" } else { $null }
        $nameAr = if ($val.name -and $val.name.ar) { $val.name.ar.Trim() -replace "^E\d+[a-z]?\s*[-:]\s*", "" } else { $null }

        # Category
        $rawClasses = if ($val.additives_classes -and $val.additives_classes.en) { $val.additives_classes.en } else { $null }
        $category = Format-Category $rawClasses

        # Safety
        $safety = Map-SafetyStatus $val $code

        # Vegan / Vegetarian
        $veganRaw = if ($val.vegan -and $val.vegan.en) { $val.vegan.en.ToLower() } else { $null }
        $isVegan = if ($veganRaw -eq "yes") { $true } elseif ($veganRaw -eq "no") { $false } else { $null }

        $vegRaw = if ($val.vegetarian -and $val.vegetarian.en) { $val.vegetarian.en.ToLower() } else { $null }
        $isVeg = if ($vegRaw -eq "yes") { $true } elseif ($vegRaw -eq "no") { $false } else { $null }

        # Natural origin / allergens (only assign if verifiable, else null)
        $naturalOrigin = if ($code -eq "E330" -or $code -eq "E100" -or ($val.organic_eu -and $val.organic_eu.en -eq "authorized")) { $true } else { $null }
        $noMajorAllergen = if ($code -eq "E330" -or $code -eq "E100" -or $code -eq "E150d") { $true } else { $null }

        # Descriptions & sections
        $overview = if ($val.description -and $val.description.en) { $val.description.en.Trim() } else { $null }
        # Curated verified descriptions for top common additives from EFSA/OFF records
        if ($code -eq "E330" -and -not $overview) {
            $overview = "Acidulant and pH regulator. Helps to maintain acidity, enhance flavour and act as a preservative."
        } elseif ($code -eq "E621" -and -not $overview) {
            $overview = "Monosodium glutamate (MSG) is a flavour enhancer that balances, blends, and rounds the perception of other tastes with an umami profile."
        } elseif ($code -eq "E150d" -and -not $overview) {
            $overview = "Sulphite ammonia caramel is a dark water-soluble food colouring made by heat treatment of carbohydrates in the presence of sulphite and ammonium compounds."
        } elseif ($code -eq "E100" -and -not $overview) {
            $overview = "Curcumin is a bright yellow chemical produced by plants of the Curcuma longa species. Used as a natural food coloring."
        } elseif ($code -eq "E951" -and -not $overview) {
            $overview = "Aspartame is an artificial non-saccharide sweetener 200 times sweeter than sucrose, commonly used as a sugar substitute in low-calorie foods and beverages."
        }

        $origin = if ($code -eq "E330") {
            "Naturally found in citrus fruits. Can also be produced synthetically via Aspergillus niger fermentation."
        } elseif ($code -eq "E100") {
            "Extracted naturally from the rhizomes of the turmeric plant (Curcuma longa)."
        } elseif ($code -eq "E621") {
            "Produced via bacterial fermentation of sugar beet, sugar cane, or corn molasses."
        } elseif ($code -eq "E150d") {
            "Derived from controlled carbohydrate heating with sulphites and ammonium compounds."
        } else {
            $null
        }

        $commonFoods = if ($code -eq "E330") {
            "Soft drinks, candies, jams, baked goods, canned fruits and vegetables, dairy products."
        } elseif ($code -eq "E621") {
            "Savory snacks, instant noodles, canned soups, processed meats, seasoning mixes, restaurant dishes."
        } elseif ($code -eq "E150d") {
            "Cola beverages, sauces, gravies, beer, baked goods, confectionery."
        } elseif ($code -eq "E100") {
            "Mustard, cheese, curry powders, margarine, baked goods, ice creams."
        } elseif ($code -eq "E951") {
            "Diet sodas, sugar-free chewing gum, gelatin desserts, low-calorie yogurts."
        } else {
            $null
        }

        # Regulatory notes
        $efsaText = if ($val.efsa_evaluation -and $val.efsa_evaluation.en) { $val.efsa_evaluation.en } else { $null }
        $efsaDate = if ($val.efsa_evaluation_date -and $val.efsa_evaluation_date.en) { $val.efsa_evaluation_date.en } else { $null }
        $efsaUrl = if ($val.efsa_evaluation_url -and $val.efsa_evaluation_url.en) { $val.efsa_evaluation_url.en } else { $null }
        $wikidata = if ($val.wikidata -and $val.wikidata.en) { $val.wikidata.en } else { $null }

        $regNotes = if ($efsaText) {
            $datePart = if ($efsaDate) { " (Date: $efsaDate)" } else { "" }
            "EFSA Evaluation: $efsaText$datePart"
        } else {
            $null
        }

        $iconType = Get-IconType $code $rawClasses $nameEnClean

        # Search keywords
        $keywords = @($code.ToLower(), $eNumber.ToLower(), $nameEnClean.ToLower())
        if ($nameFr) { $keywords += $nameFr.ToLower() }
        if ($nameAr) { $keywords += $nameAr.ToLower() }

        $additives += [ordered]@{
            id = $key
            code = $code
            e_number = $eNumber
            name = $nameEnClean
            name_fr = $nameFr
            name_ar = $nameAr
            category = $category
            safety_status = $safety.Status
            safety_label = $safety.Label
            safety_description = $safety.Description
            vegan = $isVegan
            vegetarian = $isVeg
            natural_origin = $naturalOrigin
            no_major_allergen = $noMajorAllergen
            overview = $overview
            origin = $origin
            common_foods = $commonFoods
            regulatory_notes = $regNotes
            efsa_url = $efsaUrl
            wikidata = $wikidata
            icon_type = $iconType
            search_keywords = ($keywords -join " ")
        }
        $total++
    }

    Write-Host "Processed $total additives."
    $outputDir = Split-Path $OutputPath -Parent
    if (-not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    }

    # Write formatted JSON with UTF8 without BOM
    $jsonString = ConvertTo-Json -InputObject $additives -Depth 5
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($OutputPath, $jsonString, $utf8NoBom)
    Write-Host "Successfully generated offline database at: $OutputPath"
    Write-Host "File size: $((Get-Item $OutputPath).Length) bytes."
}
finally {
    if ($isTemp -and (Test-Path $tempFile)) {
        Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
    }
}
