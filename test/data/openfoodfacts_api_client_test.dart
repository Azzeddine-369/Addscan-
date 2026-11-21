import 'package:flutter_test/flutter_test.dart';
import 'package:addiscan/data/models/product_model.dart';

void main() {
  group('Open Food Facts ProductModel Parsing Tests', () {
    test('ProductModel parses JSON correctly', () {
      final sample = {
        'code': '8410757001090',
        'product_name': 'Crema Manos',
        'brands': 'S\'nonas',
        'image_front_small_url': 'https://images.openfoodfacts.org/sample.jpg',
        'additives_tags': ['en:e330', 'en:e218', 'en:e422'],
      };

      final model = ProductModel.fromJson(sample);

      expect(model.code, '8410757001090');
      expect(model.productName, 'Crema Manos');
      expect(model.brands, 'S\'nonas');
      expect(model.imageUrl, 'https://images.openfoodfacts.org/sample.jpg');
      expect(model.additivesTags.length, 3);
      expect(model.additivesTags.contains('en:e330'), true);
    });

    test('ProductModel fallback to English or French product name if main name empty', () {
      final sample = {
        'code': '12345678',
        'product_name': '',
        'product_name_en': 'Organic Orange Juice',
        'brands': 'BioBrand',
        'additives_tags': <String>[],
      };

      final model = ProductModel.fromJson(sample);
      expect(model.productName, 'Organic Orange Juice');
    });
  });
}
