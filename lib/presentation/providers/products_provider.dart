import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/cache_manager.dart';
import '../../data/datasources/openfoodfacts_api_client.dart';
import '../../data/repositories/products_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';

final apiClientProvider = Provider<OpenFoodFactsApiClient>((ref) {
  return OpenFoodFactsApiClientImpl();
});

final cacheManagerProvider = Provider<CacheManager>((ref) {
  return CacheManager();
});

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  final cache = ref.watch(cacheManagerProvider);
  return ProductsRepositoryImpl(apiClient: client, cacheManager: cache);
});

final productsForAdditiveProvider =
    FutureProvider.family<List<Product>, String>((ref, code) async {
  final repo = ref.watch(productsRepositoryProvider);
  return repo.getProductsForAdditive(code);
});

final productByBarcodeProvider =
    FutureProvider.family<Product?, String>((ref, barcode) async {
  final repo = ref.watch(productsRepositoryProvider);
  return repo.getProductByBarcode(barcode);
});
