import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:addiscan/data/models/additive_model.dart';

void main() {
  group('AdditiveModel JSON & Search Tests', () {
    final sampleJson = {
      'id': 'en:e330',
      'code': 'E330',
      'e_number': '330',
      'name': 'Citric acid',
      'name_fr': 'Acide citrique',
      'name_ar': 'حمض الليمون',
      'category': 'Antioxidant / Sequestrant',
      'safety_status': 'safe',
      'safety_label': 'Generally Recognized as Safe',
      'safety_description': 'Widely used in food, with no major health concerns at normal levels.',
      'vegan': true,
      'vegetarian': true,
      'natural_origin': true,
      'no_major_allergen': true,
      'overview': 'Acidulant and pH regulator.',
      'origin': 'Naturally found in citrus fruits.',
      'common_foods': 'Soft drinks, candies, jams.',
      'regulatory_notes': 'EFSA Evaluation: Scientific Opinion on citric acid.',
      'efsa_url': 'http://dx.doi.org/10.2903/j.efsa.2013.3152',
      'wikidata': 'Q159683',
      'icon_type': 'lemon',
      'search_keywords': 'e330 330 citric acid acide citrique حمض الليمون',
    };

    test('AdditiveModel parses from JSON correctly', () {
      final model = AdditiveModel.fromJson(sampleJson);

      expect(model.code, 'E330');
      expect(model.eNumber, '330');
      expect(model.name, 'Citric acid');
      expect(model.nameFr, 'Acide citrique');
      expect(model.nameAr, 'حمض الليمون');
      expect(model.safetyStatus, 'safe');
      expect(model.vegan, true);
      expect(model.iconType, 'lemon');
    });

    test('AdditiveModel converts to domain Entity properly', () {
      final model = AdditiveModel.fromJson(sampleJson);
      final entity = model.toEntity();

      expect(entity.code, 'E330');
      expect(entity.isSafe, true);
      expect(entity.isCaution, false);
      expect(entity.getLocalizedName('en'), 'Citric acid');
      expect(entity.getLocalizedName('fr'), 'Acide citrique');
      expect(entity.getLocalizedName('ar'), 'حمض الليمون');
    });

    test('Search keyword normalization matches tolerant queries', () {
      final model = AdditiveModel.fromJson(sampleJson);
      final keywords = model.searchKeywords.toLowerCase();

      // Variations of E330
      expect(keywords.contains('e330'), true);
      expect(keywords.contains('330'), true);
      expect(keywords.contains('citric'), true);
      expect(keywords.contains('acide'), true);
      expect(keywords.contains('حمض'), true);
    });
  });
}
