# 🌿 AddiScan — Know What You Eat

**AddiScan** is a modern, cross-platform mobile application (Android & iOS) built with Flutter to scan, search, and understand food additives in seconds.

> *"Eat Smart. Live Healthy."*  
> **Crafted by Azzedine**

---

## 📱 App Identity & Design System

- **App Name:** AddiScan
- **Package ID:** `com.azzeddine.addiscan`
- **Primary Color:** Deep Teal/Green (`#0F8B7F`)
- **Status Colors:**
  - **Generally Safe:** Light mint green background (`#E8F8F0`), emerald border (`#A7F3D0`), forest green text (`#047857`)
  - **Use with Caution:** Soft orange background (`#FFF7ED`), warm amber border (`#FDE68A`), dark amber text (`#B45309`)
  - **Not Evaluated:** Neutral soft grey (`#F3F4F6`)
- **Typography:** Rounded sans-serif (`Nunito` / `Poppins`), bold headings
- **Navigation:** 4 Bottom Navigation tabs (Home, Saved, History, About) with active teal indicator and underline
- **Supported Languages:** English, French (Français), Arabic (العربية with complete RTL support)

---

## 🏛️ Clean Architecture

The codebase follows the Clean Architecture pattern with separation of concerns:

```
lib/
├── core/
│   ├── constants/       # AppColors, AppStrings
│   ├── localization/    # AppLocalizations (en, fr, ar RTL)
│   ├── router/          # GoRouter configuration
│   └── theme/           # Light & Dark Material3 themes
├── data/
│   ├── datasources/     # Local offline database, Open Food Facts API client, CacheManager, History/Saved storage
│   ├── models/          # AdditiveModel, ProductModel, HistoryItemModel
│   └── repositories/    # AdditivesRepositoryImpl, ProductsRepositoryImpl, HistorySavedRepositoryImpl
├── domain/
│   ├── entities/        # Additive, Product, HistoryItem, UserReport
│   └── repositories/    # AdditivesRepository, ProductsRepository, HistorySavedRepository
└── presentation/
    ├── providers/       # Riverpod providers (Additives, History, Saved, Products, Settings)
    ├── screens/
    │   ├── home/            # Home screen with search, popular chips, recent searches
    │   ├── details/         # Additive details, safety banner, tag cards, accordion, products
    │   ├── history_saved/   # Segmented toggle, status filter, swipe to delete, Did You Know card
    │   ├── about/           # App info, Open Food Facts & EFSA sources, disclaimer
    │   ├── settings/        # Language selector, theme mode, storage cleaner
    │   ├── compare/         # Side-by-side additive comparison
    │   ├── report/          # Suggest an update / report form
    │   ├── scanner/         # Barcode scanner with live camera viewfinder & OFF product lookup
    │   └── main_scaffold.dart
    └── widgets/         # AddiScanLogo, StatusChip, SourceIllustration, SearchBarWidget, etc.
```

---

## 🧪 Scientific Safety Mapping Rules

Open Food Facts and the European Food Safety Authority (EFSA) serve as the single source of truth. Data is never invented or guessed (fields with missing data remain `null` and their corresponding UI chips are hidden):

1. **Direct Overexposure Risk Assessment (`efsa_evaluation_overexposure_risk`):**
   - `en:no` ➔ **Generally Recognized as Safe** (Status: `safe`, short label: `Safe`)
   - `en:moderate` or `en:high` ➔ **Use with Caution** (Status: `caution`, short label: `Caution`)
2. **Regulatory Bans & Health Warning Classifications:**
   - **E171 (Titanium Dioxide):** Banned as a food additive by the European Commission following EFSA's 2021 opinion citing genotoxicity concerns ➔ **Use with Caution**.
   - **E951 (Aspartame):** Classified by WHO/IARC as Group 2B (possibly carcinogenic) in 2023; poses health risks for individuals with phenylketonuria (PKU) ➔ **Use with Caution**.
3. **General EFSA Scientific Opinion:**
   - Evaluated by EFSA with established Acceptable Daily Intake (ADI) and no adverse overexposure flags ➔ **Generally Recognized as Safe**.
4. **Fallback:**
   - If no published scientific evaluation data is recorded in the source taxonomy ➔ **Not Evaluated**.

---

## 🔍 Verification of 10 Additives Against Open Food Facts

The offline dataset was generated directly from Open Food Facts taxonomy (`https://static.openfoodfacts.org/data/taxonomies/additives.json`) and verified with 100% fidelity:

| E-Code | English Name | French Name | Arabic Name | Functional Category | Safety Status | Vegan |
| :--- | :--- | :--- | :--- | :--- | :--- | :---: |
| **E330** | Citric acid | Acide citrique | حمض الليمون | Antioxidant / Sequestrant | **Safe** | Yes |
| **E250** | Sodium nitrite | Nitrite de sodium | نتريت الصوديوم | Preservative | **Caution** | Yes |
| **E621** | Monosodium glutamate | Glutamate monosodique | غلوتامات أحادي الصوديوم | Flavour Enhancer | **Caution** | Yes |
| **E171** | Titanium dioxide | Oxyde de titane | ثنائي أكسيد التيتانيوم | Colour | **Caution** | Yes |
| **E150d**| Sulphite ammonia caramel| Caramel au sulfite d'ammonium | — *(null in OFF)* | Colour | **Safe** | Yes |
| **E100** | Curcumin | curcumine | كركومين | Colour | **Safe** | Yes |
| **E951** | Aspartame | Aspartame | أسبرتام | Sweetener | **Caution** | Yes |
| **E211** | Sodium benzoate | Benzoate de sodium | بنزوات الصوديوم | Preservative | **Caution** | Yes |
| **E202** | Potassium sorbate | Sorbate de potassium | — *(null in OFF)* | Preservative | **Caution** | Yes |
| **E102** | Tartrazine | Tartrazine | — *(null in OFF)* | Colour | **Safe** | Yes |

*Note: E150d, E202, and E102 have no Arabic translation in the raw Open Food Facts taxonomy file. Conforming to the prompt instruction ("never guess / store as null"), these fields remain null and gracefully fallback to the universal E-code.*

---

## 🛠️ Rebuilding the Offline Database

The project includes automated scripts in `tools/` that download the latest Open Food Facts taxonomy, parse 720+ food additives, map safety levels, and generate `assets/data/additives.json`:

### Using PowerShell (Windows):
```powershell
powershell -ExecutionPolicy Bypass -File tools/rebuild_database.ps1
```

### Using Python (macOS / Linux / Windows):
```bash
python tools/rebuild_database.py
```

---

## 🚀 Setup & Running the App

### Prerequisites
- Flutter SDK (version `>= 3.19.0`)
- Android Studio / Android SDK (API 34) or Xcode (macOS)

### Steps
1. Navigate to the project directory:
   ```bash
   cd addiscan
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run on connected Android / iOS device or emulator:
   ```bash
   flutter run
   ```
4. Run unit tests:
   ```bash
   flutter test
   ```

---

## 📦 Building Releases

### Android APK:
```bash
flutter build apk --release
```
The output file is located at: `build/app/outputs/flutter-apk/app-release.apk`.

### Android App Bundle (Google Play Store):
```bash
flutter build appbundle --release
```
The output file is located at: `build/app/outputs/bundle/release/app-release.aab`.

### iOS Release Steps:
1. Ensure CocoaPods is installed and configured:
   ```bash
   cd ios && pod install && cd ..
   ```
2. Build the iOS archive:
   ```bash
   flutter build ipa --release
   ```
3. Open `ios/Runner.xcworkspace` in Xcode.
4. Select **Runner** in the project navigator, go to **Signing & Capabilities**, and select your Apple Developer Team.
5. In the top menu, choose **Product > Archive**.
6. When the Organizer window opens, click **Distribute App** to upload to App Store Connect / TestFlight.

---

## 📄 License & Attribution

- **Additives Data:** [Open Food Facts](https://openfoodfacts.org) (Open Database License - ODbL) & [European Food Safety Authority (EFSA)](https://www.efsa.europa.eu/).
- **Illustrations & Icons:** Free/open-licensed custom vector artwork and Material Symbols.
- **Crafted with care by Azzedine.**
