import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const _supportedLocales = [
    Locale('en'),
    Locale('fr'),
    Locale('ar'),
  ];

  static List<Locale> get supportedLocales => _supportedLocales;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': 'AddiScan',
      'taglineHome': 'Know what you eat',
      'taglineAbout': 'Eat Smart. Live Healthy.',
      'footerCredit': 'Crafted by Azzedine',
      'heroTitle': 'Scan or search\nfood additives',
      'heroSubtitle': 'Get clear, reliable information in seconds!',
      'searchHint': 'Search for an E-code... (e.g. E330, E621)',
      'popularSearches': 'Popular Searches',
      'recentSearches': 'Your Recent Searches',
      'seeAll': 'See all',
      'detailsTitle': 'Additive Details',
      'safe': 'Safe',
      'caution': 'Caution',
      'notEvaluated': 'Not evaluated',
      'generallySafe': 'Generally Safe',
      'useWithCaution': 'Use with Caution',
      'generallyRecognizedAsSafe': 'Generally Recognized as Safe',
      'veganFriendly': 'Vegan Friendly',
      'noMajorAllergen': 'No Major Allergen',
      'naturalOrigin': 'Natural Origin',
      'overviewRole': 'Overview & Role in Food',
      'originSource': 'Origin / Source',
      'commonFoods': 'Common Foods Where It Appears',
      'regulatoryNotes': 'Regulatory & Safety Notes',
      'compare': 'Compare',
      'reportUpdate': 'Report / Suggest Update',
      'productsContaining': 'Products containing this additive',
      'noProductsFound': 'No products found online for this additive tag',
      'historySavedTitle': 'History & Saved',
      'historyTab': 'History',
      'savedTab': 'Saved',
      'filterHint': 'Filter by code or name...',
      'filterAll': 'All',
      'filterSafe': 'Safe Only',
      'filterCaution': 'Caution Only',
      'emptyHistory': 'No search history yet',
      'emptySaved': 'No bookmarked additives yet',
      'emptyFilter': 'No additives match the filter',
      'didYouKnow': 'Did you know?',
      'didYouKnowFact':
          'E330 (citric acid) is naturally found in citrus fruits and is one of the most common food additives.',
      'home': 'Home',
      'about': 'About',
      'settings': 'Settings',
      'language': 'Language',
      'theme': 'Appearance',
      'themeLight': 'Light Mode',
      'themeDark': 'Dark Mode',
      'themeSystem': 'System Default',
      'clearHistory': 'Clear Search History',
      'clearCache': 'Clear Product Cache',
      'historyCleared': 'Search history cleared successfully.',
      'cacheCleared': 'Product cache cleared successfully.',
      'medicalDisclaimerTitle': 'Medical Disclaimer',
      'medicalDisclaimerText':
          'Information for reference only, not medical advice. Consult a qualified physician or nutritionist for dietary restrictions, allergies, or health conditions.',
      'dataSourcesTitle': 'Data Sources & Methodology',
      'dataSourcesText':
          'Data is sourced from Open Food Facts taxonomy and European Food Safety Authority (EFSA) scientific re-evaluations. Safety levels are derived directly from published overexposure assessments and regulatory authorizations.',
      'scanBarcodeTitle': 'Barcode Scanner',
      'scanBarcodeDesc': 'Align food packaging barcode within the frame',
      'scanProductFound': 'Product Found',
      'scanAdditivesFound': 'Detected Additives',
      'scanNoAdditives': 'No additives detected in this product.',
      'compareTitle': 'Compare Additives',
      'compareSelect': 'Select another additive to compare',
      'reportTitle': 'Suggest an Update',
      'reportDescription':
          'Help us keep AddiScan accurate! Submit corrections or references below.',
      'reportReason': 'Reason / Topic',
      'reportMessage': 'Details or source link',
      'reportEmail': 'Your email (optional)',
      'reportSubmit': 'Submit Report',
      'reportSuccess': 'Thank you! Your suggestion has been recorded.',
      'safetyLevels': 'Safety Levels Explained',
      'safetySafeDesc':
          'Assessed by international food authorities (EFSA, JECFA) with an established Acceptable Daily Intake (ADI) and no adverse effects reported under regular consumption.',
      'safetyCautionDesc':
          'Safety authorities noted potential risks with high exposure, potential genotoxicity, or hypersensitivity warnings for susceptible populations.',
      'safetyNotEvalDesc':
          'Currently lacks published comprehensive EFSA re-evaluation or sufficient risk assessment data in the global taxonomy.',
      'today': 'Today',
      'yesterday': 'Yesterday',
      'shareSubject': 'Food Additive Info: ',
      'itemDeleted': 'Removed from history',
      'itemSaved': 'Saved to bookmarks',
      'itemUnsaved': 'Removed from bookmarks',
    },
    'fr': {
      'appName': 'AddiScan',
      'taglineHome': 'Sachez ce que vous mangez',
      'taglineAbout': 'Mangez sain. Vivez mieux.',
      'footerCredit': 'Créé par Azzedine',
      'heroTitle': 'Scannez ou recherchez\ndes additifs',
      'heroSubtitle': 'Obtenez des informations claires et fiables en quelques secondes !',
      'searchHint': 'Rechercher un code E... (ex. E330, E621)',
      'popularSearches': 'Recherches populaires',
      'recentSearches': 'Vos recherches récentes',
      'seeAll': 'Voir tout',
      'detailsTitle': 'Détails de l\'additif',
      'safe': 'Sûr',
      'caution': 'Attention',
      'notEvaluated': 'Non évalué',
      'generallySafe': 'Généralement sûr',
      'useWithCaution': 'À consommer avec modération',
      'generallyRecognizedAsSafe': 'Généralement reconnu comme sûr',
      'veganFriendly': 'Végan',
      'noMajorAllergen': 'Sans allergène majeur',
      'naturalOrigin': 'Origine naturelle',
      'overviewRole': 'Rôle dans l\'alimentation',
      'originSource': 'Origine / Source',
      'commonFoods': 'Aliments courants',
      'regulatoryNotes': 'Notes réglementaires & sécurité',
      'compare': 'Comparer',
      'reportUpdate': 'Suggérer une mise à jour',
      'productsContaining': 'Produits contenant cet additif',
      'noProductsFound': 'Aucun produit trouvé en ligne avec cet additif',
      'historySavedTitle': 'Historique & Favoris',
      'historyTab': 'Historique',
      'savedTab': 'Favoris',
      'filterHint': 'Filtrer par code ou nom...',
      'filterAll': 'Tous',
      'filterSafe': 'Sûrs uniquement',
      'filterCaution': 'Attention uniquement',
      'emptyHistory': 'Aucun historique de recherche',
      'emptySaved': 'Aucun additif enregistré',
      'emptyFilter': 'Aucun résultat correspondant',
      'didYouKnow': 'Le saviez-vous ?',
      'didYouKnowFact':
          'Le E330 (acide citrique) est naturellement présent dans les agrumes et constitue l\'un des additifs les plus courants.',
      'home': 'Accueil',
      'about': 'À propos',
      'settings': 'Paramètres',
      'language': 'Langue',
      'theme': 'Apparence',
      'themeLight': 'Mode clair',
      'themeDark': 'Mode sombre',
      'themeSystem': 'Système',
      'clearHistory': 'Effacer l\'historique',
      'clearCache': 'Vider le cache produit',
      'historyCleared': 'Historique effacé avec succès.',
      'cacheCleared': 'Cache vidé avec succès.',
      'medicalDisclaimerTitle': 'Avis médical',
      'medicalDisclaimerText':
          'Informations fournies à titre indicatif uniquement, ne constituant pas un avis médical.',
      'dataSourcesTitle': 'Sources des données',
      'dataSourcesText':
          'Données issues de la taxonomie Open Food Facts et des avis scientifiques de l\'EFSA.',
      'scanBarcodeTitle': 'Scanner de code-barres',
      'scanBarcodeDesc': 'Cadrez le code-barres de l\'emballage',
      'scanProductFound': 'Produit trouvé',
      'scanAdditivesFound': 'Additifs détectés',
      'scanNoAdditives': 'Aucun additif détecté dans ce produit.',
      'compareTitle': 'Comparer des additifs',
      'compareSelect': 'Choisir un autre additif',
      'reportTitle': 'Signaler ou suggérer',
      'reportDescription':
          'Aidez-nous à garder AddiScan précis ! Soumettez vos retours ci-dessous.',
      'reportReason': 'Motif',
      'reportMessage': 'Message ou lien source',
      'reportEmail': 'Votre email (optionnel)',
      'reportSubmit': 'Envoyer',
      'reportSuccess': 'Merci ! Votre suggestion a été enregistrée.',
      'safetyLevels': 'Niveaux de sécurité',
      'safetySafeDesc':
          'Évalué sans risque notable dans les conditions normales d\'utilisation.',
      'safetyCautionDesc':
          'Présente un risque de surexposition ou des réserves sanitaires signalées.',
      'safetyNotEvalDesc':
          'Données de réévaluation EFSA incomplètes ou non concluantes.',
      'today': 'Aujourd\'hui',
      'yesterday': 'Hier',
      'shareSubject': 'Info Additif AddiScan : ',
      'itemDeleted': 'Supprimé de l\'historique',
      'itemSaved': 'Ajouté aux favoris',
      'itemUnsaved': 'Retiré des favoris',
    },
    'ar': {
      'appName': 'أديسكان',
      'taglineHome': 'اعرف ما تأكل',
      'taglineAbout': 'كُل بذكاء. عش بصحة.',
      'footerCredit': 'صنع بواسطة عزالدين',
      'heroTitle': 'امسح أو ابحث عن\nالمضافات الغذائية',
      'heroSubtitle': 'احصل على معلومات دقيقة وموثوقة في ثوانٍ!',
      'searchHint': 'ابحث عن رمز E... (مثل E330, E621)',
      'popularSearches': 'الأكثر بحثاً',
      'recentSearches': 'عمليات البحث الأخيرة',
      'seeAll': 'عرض الكل',
      'detailsTitle': 'تفاصيل المضاف',
      'safe': 'آمن',
      'caution': 'تحذير',
      'notEvaluated': 'غير مقيّم',
      'generallySafe': 'آمن بشكل عام',
      'useWithCaution': 'استخدم بحذر',
      'generallyRecognizedAsSafe': 'معترف به كآمن بشكل عام',
      'veganFriendly': 'مناسب للنباتيين',
      'noMajorAllergen': 'خالٍ من مسببات الحساسية',
      'naturalOrigin': 'مصدر طبيعي',
      'overviewRole': 'نظرة عامة ودوره في الغذاء',
      'originSource': 'المصدر والأصل',
      'commonFoods': 'أطعمة شائعة يتواجد فيها',
      'regulatoryNotes': 'ملاحظات تنظيمية وصحية',
      'compare': 'مقارنة',
      'reportUpdate': 'اقتراح تعديل أو بلاغ',
      'productsContaining': 'منتجات تحتوي على هذا المضاف',
      'noProductsFound': 'لم يتم العثور على منتجات مسجلة بهذا المضاف',
      'historySavedTitle': 'السجل والمحفوظات',
      'historyTab': 'السجل',
      'savedTab': 'المحفوظات',
      'filterHint': 'تصفية حسب الرمز أو الاسم...',
      'filterAll': 'الكل',
      'filterSafe': 'الآمن فقط',
      'filterCaution': 'التحذيري فقط',
      'emptyHistory': 'لا يوجد سجل بحث حتى الآن',
      'emptySaved': 'لا توجد مضافات محفوظة',
      'emptyFilter': 'لا توجد نتائج مطابقة للتصفية',
      'didYouKnow': 'هل تعلم؟',
      'didYouKnowFact':
          'E330 (حمض الستريك) يتواجد طبيعياً في الحمضيات ويعد من أكثر المضافات الغذائية انتشاراً.',
      'home': 'الرئيسية',
      'about': 'حول التطبيق',
      'settings': 'الإعدادات',
      'language': 'اللغة',
      'theme': 'المظهر',
      'themeLight': 'الوضع الفاتح',
      'themeDark': 'الوضع الداكن',
      'themeSystem': 'تلقائي (النظام)',
      'clearHistory': 'مسح سجل البحث',
      'clearCache': 'مسح الذاكرة المؤقتة',
      'historyCleared': 'تم مسح سجل البحث بنجاح.',
      'cacheCleared': 'تم مسح الذاكرة المؤقتة بنجاح.',
      'medicalDisclaimerTitle': 'إخلاء مسؤولية طبي',
      'medicalDisclaimerText':
          'المعلومات لأغراض الاسترشاد والتوعية فقط وليست نصيحة طبية. استشر طبيبك المختص.',
      'dataSourcesTitle': 'مصادر البيانات',
      'dataSourcesText':
          'البيانات مستخلصة من قاعدة Open Food Facts وتقييمات الهيئة الأوروبية لسلامة الأغذية (EFSA).',
      'scanBarcodeTitle': 'ماسح الباركود',
      'scanBarcodeDesc': 'وجّه الكاميرا نحو باركود المنتج',
      'scanProductFound': 'تم التعرف على المنتج',
      'scanAdditivesFound': 'المضافات المكتشفة',
      'scanNoAdditives': 'لا توجد مضافات مسجلة لهذا المنتج.',
      'compareTitle': 'مقارنة المضافات',
      'compareSelect': 'اختر مضافاً آخر للمقارنة',
      'reportTitle': 'اقتراح تعديل',
      'reportDescription':
          'ساعدنا في الحفاظ على دقة أديسكان بإرسال ملاحظاتك ومصادرك.',
      'reportReason': 'الموضوع',
      'reportMessage': 'التفاصيل أو رابط المصدر',
      'reportEmail': 'بريدك الإلكتروني (اختياري)',
      'reportSubmit': 'إرسال الاقتراح',
      'reportSuccess': 'شكراً لك! تم استلام اقتراحك بنجاح.',
      'safetyLevels': 'مستويات الأمان المعتمدة',
      'safetySafeDesc':
          'تم تقييمه من الهيئات الغذائية الدولية بمستوى استهلاك يومي آمن دون أضرار مسجلة.',
      'safetyCautionDesc':
          'أشارت الدراسات إلى احتمال وجود مخاطر عند فرط الاستهلاك أو حساسية لبعض الفئات.',
      'safetyNotEvalDesc':
          'لا تتوفر دراسة تقييمية كاملة حديثة في قاعدة البيانات المفتوحة.',
      'today': 'اليوم',
      'yesterday': 'أمس',
      'shareSubject': 'معلومات المضاف الغذائي من أديسكان: ',
      'itemDeleted': 'تم الحذف من السجل',
      'itemSaved': 'تم الحفظ في المفضلة',
      'itemUnsaved': 'تمت الإزالة من المفضلة',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'fr', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
  String tr(String key) => loc.translate(key);
}
