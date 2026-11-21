import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/cache_manager.dart';
import '../datasources/openfoodfacts_api_client.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final OpenFoodFactsApiClient apiClient;
  final CacheManager cacheManager;

  ProductsRepositoryImpl({
    required this.apiClient,
    required this.cacheManager,
  });

  @override
  Future<List<Product>> getProductsForAdditive(String additiveCode, {int limit = 10}) async {
    final cacheKey = additiveCode.trim().toLowerCase();

    // 1. Check local cache first
    final cached = await cacheManager.getCachedProducts(cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return cached.map((e) => e.toEntity()).toList();
    }

    // 2. Fetch from Open Food Facts API
    final fetched = await apiClient.searchProductsByAdditive(additiveCode, limit: limit);

    // 3. Cache results
    if (fetched.isNotEmpty) {
      await cacheManager.cacheProducts(cacheKey, fetched);
    }

    return fetched.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Product?> getProductByBarcode(String barcode) async {
    final model = await apiClient.getProductByBarcode(barcode);
    return model?.toEntity();
  }

  @override
  Future<void> clearProductCache() async {
    await cacheManager.clearAllCache();
  }
}
