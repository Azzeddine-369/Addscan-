enum SafetyStatus {
  safe,
  caution,
  notEvaluated,
}

class Additive {
  final String id;
  final String code;
  final String eNumber;
  final String name;
  final String? nameFr;
  final String? nameAr;
  final String? category;
  final SafetyStatus safetyStatus;
  final String safetyLabel;
  final String safetyDescription;
  final bool? vegan;
  final bool? vegetarian;
  final bool? naturalOrigin;
  final bool? noMajorAllergen;
  final String? overview;
  final String? origin;
  final String? commonFoods;
  final String? regulatoryNotes;
  final String? efsaUrl;
  final String? wikidata;
  final String iconType;

  const Additive({
    required this.id,
    required this.code,
    required this.eNumber,
    required this.name,
    this.nameFr,
    this.nameAr,
    this.category,
    required this.safetyStatus,
    required this.safetyLabel,
    required this.safetyDescription,
    this.vegan,
    this.vegetarian,
    this.naturalOrigin,
    this.noMajorAllergen,
    this.overview,
    this.origin,
    this.commonFoods,
    this.regulatoryNotes,
    this.efsaUrl,
    this.wikidata,
    required this.iconType,
  });

  /// Get localized name or fallback to English / code
  String getLocalizedName(String languageCode) {
    if (languageCode == 'fr' && nameFr != null && nameFr!.trim().isNotEmpty) {
      return nameFr!;
    }
    if (languageCode == 'ar' && nameAr != null && nameAr!.trim().isNotEmpty) {
      return nameAr!;
    }
    return name;
  }

  bool get isSafe => safetyStatus == SafetyStatus.safe;
  bool get isCaution => safetyStatus == SafetyStatus.caution;
  bool get isNotEvaluated => safetyStatus == SafetyStatus.notEvaluated;
}
