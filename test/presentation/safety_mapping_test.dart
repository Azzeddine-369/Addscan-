import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('10 Additives Verification Against Open Food Facts Offline Database', () {
    late List<dynamic> additives;

    setUpAll(() {
      final file = File('assets/data/additives.json');
      expect(file.existsSync(), true, reason: 'Offline database assets/data/additives.json must exist');
      final jsonStr = file.readAsStringSync();
      additives = json.decode(jsonStr) as List<dynamic>;
    });

    Map<String, dynamic>? findByCode(String code) {
      final matches = additives.where((e) => (e['code'] as String).toUpperCase() == code.toUpperCase()).toList();
      return matches.isNotEmpty ? matches.first as Map<String, dynamic> : null;
    }

    test('1. E330 (Citric Acid) is Safe', () {
      final e330 = findByCode('E330');
      expect(e330, isNotNull);
      expect(e330!['code'], 'E330');
      expect(e330['safety_status'], 'safe');
      expect(e330['vegan'], true);
    });

    test('2. E250 (Sodium Nitrite) is Caution', () {
      final e250 = findByCode('E250');
      expect(e250, isNotNull);
      expect(e250!['safety_status'], 'caution');
    });

    test('3. E621 (Monosodium Glutamate) is Caution', () {
      final e621 = findByCode('E621');
      expect(e621, isNotNull);
      expect(e621!['safety_status'], 'caution');
    });

    test('4. E171 (Titanium Dioxide) is Caution', () {
      final e171 = findByCode('E171');
      expect(e171, isNotNull);
      expect(e171!['safety_status'], 'caution');
    });

    test('5. E150d (Sulphite Ammonia Caramel) is Safe', () {
      final e150d = findByCode('E150d');
      expect(e150d, isNotNull);
      expect(e150d!['safety_status'], 'safe');
    });

    test('6. E100 (Curcumin) is Safe', () {
      final e100 = findByCode('E100');
      expect(e100, isNotNull);
      expect(e100!['safety_status'], 'safe');
    });

    test('7. E951 (Aspartame) is Caution', () {
      final e951 = findByCode('E951');
      expect(e951, isNotNull);
      expect(e951!['safety_status'], 'caution');
    });

    test('8. E211 (Sodium Benzoate) is Caution', () {
      final e211 = findByCode('E211');
      expect(e211, isNotNull);
      expect(e211!['safety_status'], 'caution');
    });

    test('9. E202 (Potassium Sorbate) is Caution', () {
      final e202 = findByCode('E202');
      expect(e202, isNotNull);
      expect(e202!['safety_status'], 'caution');
    });

    test('10. E102 (Tartrazine) is Evaluated / Safe', () {
      final e102 = findByCode('E102');
      expect(e102, isNotNull);
      expect(e102!['safety_status'], 'safe');
    });
  });
}
