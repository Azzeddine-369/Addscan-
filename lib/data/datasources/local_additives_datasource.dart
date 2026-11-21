import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/additive_model.dart';

abstract class LocalAdditivesDatasource {
  Future<void> init();
  List<AdditiveModel> getAll();
  AdditiveModel? getByCode(String code);
  List<AdditiveModel> search(String query, {int limit = 20});
  List<AdditiveModel> getPopular();
}

class LocalAdditivesDatasourceImpl implements LocalAdditivesDatasource {
  final String assetPath;
  List<AdditiveModel> _additives = [];
  final Map<String, AdditiveModel> _codeIndex = {};
  final Map<String, AdditiveModel> _numericIndex = {};
  bool _initialized = false;

  LocalAdditivesDatasourceImpl({
    this.assetPath = 'assets/data/additives.json',
  });

  @override
  Future<void> init() async {
    if (_initialized) return;

    final jsonStr = await rootBundle.loadString(assetPath);
    final List<dynamic> rawList = json.decode(jsonStr) as List<dynamic>;

    _additives = rawList.map((e) => AdditiveModel.fromJson(e as Map<String, dynamic>)).toList();

    _codeIndex.clear();
    _numericIndex.clear();

    for (final item in _additives) {
      final codeNorm = item.code.trim().toUpperCase();
      final numNorm = item.eNumber.trim().toUpperCase();

      _codeIndex[codeNorm] = item;
      if (numNorm.isNotEmpty) {
        _numericIndex[numNorm] = item;
      }
    }

    _initialized = true;
  }

  @override
  List<AdditiveModel> getAll() => _additives;

  @override
  AdditiveModel? getByCode(String code) {
    final query = code.trim().toUpperCase();
    if (_codeIndex.containsKey(query)) {
      return _codeIndex[query];
    }
    // Clean 'E' prefix if user typed numeric '330'
    final numQuery = query.replaceAll(RegExp(r'^E'), '');
    if (_numericIndex.containsKey(numQuery)) {
      return _numericIndex[numQuery];
    }
    // Try adding 'E' prefix
    final eQuery = 'E$query';
    if (_codeIndex.containsKey(eQuery)) {
      return _codeIndex[eQuery];
    }
    return null;
  }

  @override
  List<AdditiveModel> search(String query, {int limit = 20}) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    final normalizedQ = q.replaceAll(RegExp(r'[\s\-_]'), '');

    // Score based matching for accurate autocomplete
    final scored = <MapEntry<AdditiveModel, int>>[];

    for (final item in _additives) {
      int score = 0;
      final codeLower = item.code.toLowerCase();
      final numLower = item.eNumber.toLowerCase();
      final nameLower = item.name.toLowerCase();
      final nameFrLower = item.nameFr?.toLowerCase() ?? '';
      final nameArLower = item.nameAr?.toLowerCase() ?? '';

      // 1. Exact matches
      if (codeLower == q || numLower == q) {
        score += 100;
      } else if (codeLower.replaceAll('e', '') == normalizedQ.replaceAll('e', '')) {
        score += 90;
      } else if (nameLower == q || nameFrLower == q || nameArLower == q) {
        score += 85;
      }
      // 2. Prefix matches
      else if (codeLower.startsWith(q) || numLower.startsWith(q)) {
        score += 70;
      } else if (nameLower.startsWith(q) || nameFrLower.startsWith(q) || nameArLower.startsWith(q)) {
        score += 60;
      }
      // 3. Substring keyword matches
      else if (item.searchKeywords.contains(q)) {
        score += 40;
      }

      if (score > 0) {
        scored.add(MapEntry(item, score));
      }
    }

    scored.sort((a, b) => b.value.compareTo(a.value));
    return scored.map((e) => e.key).take(limit).toList();
  }

  @override
  List<AdditiveModel> getPopular() {
    // Matches the popular search row in the UI design: E330, E621, E150d, E100
    final popularCodes = ['E330', 'E621', 'E150D', 'E150d', 'E100'];
    final list = <AdditiveModel>[];
    for (final c in popularCodes) {
      final item = getByCode(c);
      if (item != null && !list.any((existing) => existing.code.toUpperCase() == item.code.toUpperCase())) {
        list.add(item);
      }
    }
    return list;
  }
}
