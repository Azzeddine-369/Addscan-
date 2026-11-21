import '../../domain/entities/additive.dart';

class AdditiveModel {
  final String id;
  final String code;
  final String eNumber;
  final String name;
  final String? nameFr;
  final String? nameAr;
  final String? category;
  final String safetyStatus;
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
  final String searchKeywords;

  const AdditiveModel({
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
    required this.searchKeywords,
  });

  factory AdditiveModel.fromJson(Map<String, dynamic> json) {
    return AdditiveModel(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      eNumber: json['e_number']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      nameFr: json['name_fr'] as String?,
      nameAr: json['name_ar'] as String?,
      category: json['category'] as String?,
      safetyStatus: json['safety_status'] as String? ?? 'not_evaluated',
      safetyLabel: json['safety_label'] as String? ?? 'Not Evaluated',
      safetyDescription: json['safety_description'] as String? ?? '',
      vegan: json['vegan'] as bool?,
      vegetarian: json['vegetarian'] as bool?,
      naturalOrigin: json['natural_origin'] as bool?,
      noMajorAllergen: json['no_major_allergen'] as bool?,
      overview: json['overview'] as String?,
      origin: json['origin'] as String?,
      commonFoods: json['common_foods'] as String?,
      regulatoryNotes: json['regulatory_notes'] as String?,
      efsaUrl: json['efsa_url'] as String?,
      wikidata: json['wikidata'] as String?,
      iconType: json['icon_type'] as String? ?? 'flask',
      searchKeywords: json['search_keywords'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'e_number': eNumber,
      'name': name,
      'name_fr': nameFr,
      'name_ar': nameAr,
      'category': category,
      'safety_status': safetyStatus,
      'safety_label': safetyLabel,
      'safety_description': safetyDescription,
      'vegan': vegan,
      'vegetarian': vegetarian,
      'natural_origin': naturalOrigin,
      'no_major_allergen': noMajorAllergen,
      'overview': overview,
      'origin': origin,
      'common_foods': commonFoods,
      'regulatory_notes': regulatoryNotes,
      'efsa_url': efsaUrl,
      'wikidata': wikidata,
      'icon_type': iconType,
      'search_keywords': searchKeywords,
    };
  }

  Additive toEntity() {
    SafetyStatus status;
    switch (safetyStatus.toLowerCase()) {
      case 'safe':
        status = SafetyStatus.safe;
        break;
      case 'caution':
        status = SafetyStatus.caution;
        break;
      default:
        status = SafetyStatus.notEvaluated;
    }

    return Additive(
      id: id,
      code: code,
      eNumber: eNumber,
      name: name,
      nameFr: nameFr,
      nameAr: nameAr,
      category: category,
      safetyStatus: status,
      safetyLabel: safetyLabel,
      safetyDescription: safetyDescription,
      vegan: vegan,
      vegetarian: vegetarian,
      naturalOrigin: naturalOrigin,
      noMajorAllergen: noMajorAllergen,
      overview: overview,
      origin: origin,
      commonFoods: commonFoods,
      regulatoryNotes: regulatoryNotes,
      efsaUrl: efsaUrl,
      wikidata: wikidata,
      iconType: iconType,
    );
  }
}
