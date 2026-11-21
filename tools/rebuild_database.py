#!/usr/bin/env python3
"""
Rebuild Database Script for AddiScan
Fetches Open Food Facts additives taxonomy and compiles the offline additives database.
"""
import json
import os
import re
import sys
import urllib.request

TAXONOMY_URL = "https://static.openfoodfacts.org/data/taxonomies/additives.json"
OUTPUT_PATH = os.path.join(os.path.dirname(__file__), "..", "assets", "data", "additives.json")

def format_category(raw_classes):
    if not raw_classes:
        return None
    parts = re.split(r"[,|]", raw_classes)
    formatted = []
    for p in parts:
        c = re.sub(r"^en:", "", p.strip()).replace("-", " ")
        if c:
            formatted.append(c.title())
    return " / ".join(formatted) if formatted else None

def map_safety(val, code):
    risk = val.get("efsa_evaluation_overexposure_risk", {}).get("en")
    eval_text = val.get("efsa_evaluation", {}).get("en")
    c_upper = code.upper()

    if c_upper == "E951":
        return {
            "status": "caution",
            "label": "Use with Caution",
            "description": "Classified as possibly carcinogenic (Group 2B) by WHO/IARC (2023). Restricted for individuals with phenylketonuria (PKU)."
        }
    if c_upper == "E171":
        return {
            "status": "caution",
            "label": "Use with Caution",
            "description": "Titanium dioxide was concluded by EFSA in 2021 to no longer be considered safe as a food additive due to genotoxicity concerns."
        }
    if risk in ("en:high", "en:moderate"):
        return {
            "status": "caution",
            "label": "Use with Caution",
            "description": "High or moderate overexposure risk noted in EFSA safety evaluations."
        }
    if risk == "en:no":
        return {
            "status": "safe",
            "label": "Generally Recognized as Safe",
            "description": "Evaluated with no significant overexposure safety risk under standard usage levels."
        }
    if eval_text:
        return {
            "status": "safe",
            "label": "Generally Recognized as Safe",
            "description": "Evaluated by EFSA and permitted for food applications within standard limit ranges."
        }
    return {
        "status": "not_evaluated",
        "label": "Not Evaluated",
        "description": "No conclusive EFSA safety evaluation data recorded in source taxonomy."
    }

def get_icon(code, classes):
    c = code.upper()
    if c == "E330": return "lemon"
    if c in ("E621", "E951", "E250"): return "flask"
    if "150" in c or "CARAMEL" in c: return "droplet"
    if c == "E100" or "CURCUMIN" in c: return "curcumin"
    if classes and "colour" in classes: return "droplet"
    if classes and ("preservative" in classes or "sweetener" in classes): return "flask"
    if classes and "antioxidant" in classes: return "leaf"
    return "flask"

def main():
    print(f"Downloading taxonomy from {TAXONOMY_URL}...")
    req = urllib.request.Request(TAXONOMY_URL, headers={"User-Agent": "AddiScan/1.0 (Mobile App; contact: azzedine)"})
    with urllib.request.urlopen(req) as resp:
        data = json.loads(resp.read().decode("utf-8"))
    
    additives = []
    for key, val in data.items():
        if not re.match(r"^en:e\d+", key):
            continue
        
        raw_key_suffix = re.sub(r"^en:e\d+", "", key)
        if raw_key_suffix:
            e_num = re.sub(r"^en:e", "", key)
            code = "E" + e_num
        else:
            e_num = val.get("e_number", {}).get("en", "").strip() or re.sub(r"^en:e", "", key)
            code = "E" + e_num

        name_en = val.get("name", {}).get("en", code).strip()
        name_en_clean = re.sub(r"^E\d+[a-z]?\s*[-:]\s*", "", name_en)

        name_fr = val.get("name", {}).get("fr")
        if name_fr:
            name_fr = re.sub(r"^E\d+[a-z]?\s*[-:]\s*", "", name_fr.strip())

        name_ar = val.get("name", {}).get("ar")
        if name_ar:
            name_ar = re.sub(r"^E\d+[a-z]?\s*[-:]\s*", "", name_ar.strip())

        raw_classes = val.get("additives_classes", {}).get("en")
        category = format_category(raw_classes)
        safety = map_safety(val, code)

        vegan_raw = val.get("vegan", {}).get("en", "").lower()
        is_vegan = True if vegan_raw == "yes" else (False if vegan_raw == "no" else None)

        veg_raw = val.get("vegetarian", {}).get("en", "").lower()
        is_veg = True if veg_raw == "yes" else (False if veg_raw == "no" else None)

        natural_origin = True if (code in ("E330", "E100") or val.get("organic_eu", {}).get("en") == "authorized") else None
        no_major_allergen = True if code in ("E330", "E100", "E150d") else None

        overview = val.get("description", {}).get("en")
        if code == "E330" and not overview:
            overview = "Acidulant and pH regulator. Helps to maintain acidity, enhance flavour and act as a preservative."
        elif code == "E621" and not overview:
            overview = "Monosodium glutamate (MSG) is a flavour enhancer that balances, blends, and rounds the perception of other tastes with an umami profile."
        elif code == "E150d" and not overview:
            overview = "Sulphite ammonia caramel is a dark water-soluble food colouring made by heat treatment of carbohydrates in the presence of sulphite and ammonium compounds."
        elif code == "E100" and not overview:
            overview = "Curcumin is a bright yellow chemical produced by plants of the Curcuma longa species. Used as a natural food coloring."
        elif code == "E951" and not overview:
            overview = "Aspartame is an artificial non-saccharide sweetener 200 times sweeter than sucrose, commonly used as a sugar substitute."

        origin = None
        if code == "E330":
            origin = "Naturally found in citrus fruits. Can also be produced synthetically via Aspergillus niger fermentation."
        elif code == "E100":
            origin = "Extracted naturally from the rhizomes of the turmeric plant (Curcuma longa)."
        elif code == "E621":
            origin = "Produced via bacterial fermentation of sugar beet, sugar cane, or corn molasses."
        elif code == "E150d":
            origin = "Derived from controlled carbohydrate heating with sulphites and ammonium compounds."

        common_foods = None
        if code == "E330":
            common_foods = "Soft drinks, candies, jams, baked goods, canned fruits and vegetables, dairy products."
        elif code == "E621":
            common_foods = "Savory snacks, instant noodles, canned soups, processed meats, seasoning mixes, restaurant dishes."
        elif code == "E150d":
            common_foods = "Cola beverages, sauces, gravies, beer, baked goods, confectionery."
        elif code == "E100":
            common_foods = "Mustard, cheese, curry powders, margarine, baked goods, ice creams."
        elif code == "E951":
            common_foods = "Diet sodas, sugar-free chewing gum, gelatin desserts, low-calorie yogurts."

        efsa_text = val.get("efsa_evaluation", {}).get("en")
        efsa_date = val.get("efsa_evaluation_date", {}).get("en")
        reg_notes = f"EFSA Evaluation: {efsa_text}" + (f" (Date: {efsa_date})" if efsa_date else "") if efsa_text else None

        keywords = [code.lower(), e_num.lower(), name_en_clean.lower()]
        if name_fr: keywords.append(name_fr.lower())
        if name_ar: keywords.append(name_ar.lower())

        additives.append({
            "id": key,
            "code": code,
            "e_number": e_num,
            "name": name_en_clean,
            "name_fr": name_fr,
            "name_ar": name_ar,
            "category": category,
            "safety_status": safety["status"],
            "safety_label": safety["label"],
            "safety_description": safety["description"],
            "vegan": is_vegan,
            "vegetarian": is_veg,
            "natural_origin": natural_origin,
            "no_major_allergen": no_major_allergen,
            "overview": overview,
            "origin": origin,
            "common_foods": common_foods,
            "regulatory_notes": reg_notes,
            "efsa_url": val.get("efsa_evaluation_url", {}).get("en"),
            "wikidata": val.get("wikidata", {}).get("en"),
            "icon_type": get_icon(code, raw_classes),
            "search_keywords": " ".join(keywords),
        })

    os.makedirs(os.path.dirname(OUTPUT_PATH), exist_ok=True)
    with open(OUTPUT_PATH, "w", encoding="utf-8") as f:
        json.dump(additives, f, ensure_ascii=False, indent=2)

    print(f"Generated {len(additives)} additives at {OUTPUT_PATH}")

if __name__ == "__main__":
    main()
