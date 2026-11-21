import '../entities/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> getProductsForAdditive(String additiveCode, {int limit = 10});
  Future<Product?> getProductByBarcode(String barcode);
  Future<void> clearProductCache();
}
