import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class CacheManager {
  static const String _productCachePrefix = 'cache_products_';
  static const Duration defaultTtl = Duration(hours: 24);

  final SharedPreferences? _prefs;

  CacheManager({SharedPreferences? prefs}) : _prefs = prefs;

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ?? await SharedPreferences.getInstance();
  }

  Future<List<ProductModel>?> getCachedProducts(String key) async {
    try {
      final prefs = await _getPrefs();
      final raw = prefs.getString('$_productCachePrefix$key');
      if (raw == null) return null;

      final data = json.decode(raw) as Map<String, dynamic>;
      final timestamp = data['timestamp'] as int? ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;

      if (now - timestamp > defaultTtl.inMilliseconds) {
        // Expired
        await prefs.remove('$_productCachePrefix$key');
        return null;
      }

      final list = data['items'] as List<dynamic>? ?? [];
      return list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> cacheProducts(String key, List<ProductModel> products) async {
    try {
      final prefs = await _getPrefs();
      final data = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'items': products.map((e) => e.toJson()).toList(),
      };
      await prefs.setString('$_productCachePrefix$key', json.encode(data));
    } catch (_) {}
  }

  Future<void> clearAllCache() async {
    try {
      final prefs = await _getPrefs();
      final keys = prefs.getKeys().where((k) => k.startsWith(_productCachePrefix)).toList();
      for (final k in keys) {
        await prefs.remove(k);
      }
    } catch (_) {}
  }
}
