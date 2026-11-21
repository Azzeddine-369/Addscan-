import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

abstract class OpenFoodFactsApiClient {
  Future<List<ProductModel>> searchProductsByAdditive(String additiveCode, {int limit = 10});
  Future<ProductModel?> getProductByBarcode(String barcode);
}

class OpenFoodFactsApiClientImpl implements OpenFoodFactsApiClient {
  final http.Client client;
  static const String baseUrl = 'https://world.openfoodfacts.org';
  static const Map<String, String> _headers = {
    'User-Agent': 'AddiScan - Android/Flutter - Version 1.0 (contact: azzedine)',
    'Accept': 'application/json',
  };

  OpenFoodFactsApiClientImpl({http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<List<ProductModel>> searchProductsByAdditive(
    String additiveCode, {
    int limit = 10,
  }) async {
    // Normalise to Open Food Facts tag: e.g. "en:e330"
    final cleanCode = additiveCode.trim().toLowerCase().replaceAll(RegExp(r'^en:'), '');
    final tag = 'en:$cleanCode';

    final uri = Uri.parse(
      '$baseUrl/api/v2/search?additives_tags=$tag&page_size=$limit&fields=code,product_name,brands,image_front_small_url,additives_tags',
    );

    try {
      final response = await client.get(uri, headers: _headers).timeout(
            const Duration(seconds: 12),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final productsRaw = data['products'] as List<dynamic>? ?? [];

        return productsRaw
            .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
            .where((p) => p.productName.trim().isNotEmpty)
            .toList();
      }
      return [];
    } catch (e) {
      // Graceful offline fallback
      return [];
    }
  }

  @override
  Future<ProductModel?> getProductByBarcode(String barcode) async {
    final cleanBarcode = barcode.trim();
    if (cleanBarcode.isEmpty) return null;

    final uri = Uri.parse('$baseUrl/api/v0/product/$cleanBarcode.json');

    try {
      final response = await client.get(uri, headers: _headers).timeout(
            const Duration(seconds: 12),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final status = data['status'];
        if (status == 1 && data['product'] != null) {
          return ProductModel.fromJson(data['product'] as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
