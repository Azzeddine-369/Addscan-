class Product {
  final String code;
  final String productName;
  final String? brands;
  final String? imageUrl;
  final List<String> additivesTags;

  const Product({
    required this.code,
    required this.productName,
    this.brands,
    this.imageUrl,
    required this.additivesTags,
  });

  String get displayBrand => (brands != null && brands!.trim().isNotEmpty)
      ? brands!
      : 'Open Food Facts Item';
}
