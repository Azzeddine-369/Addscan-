import '../../domain/entities/product.dart';

class ProductModel {
  final String code;
  final String productName;
  final String? brands;
  final String? imageUrl;
  final List<String> additivesTags;

  const ProductModel({
    required this.code,
    required this.productName,
    this.brands,
    this.imageUrl,
    required this.additivesTags,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    List<String> tags = [];
    if (json['additives_tags'] != null && json['additives_tags'] is List) {
      tags = (json['additives_tags'] as List)
          .map((e) => e.toString())
          .toList();
    }

    String pName = json['product_name'] as String? ?? '';
    if (pName.trim().isEmpty) {
      pName = json['product_name_en'] as String? ??
          json['product_name_fr'] as String? ??
          'Unknown Product';
    }

    return ProductModel(
      code: json['code']?.toString() ?? '',
      productName: pName,
      brands: json['brands'] as String?,
      imageUrl: json['image_front_small_url'] as String? ??
          json['image_front_url'] as String? ??
          json['image_url'] as String?,
      additivesTags: tags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'product_name': productName,
      'brands': brands,
      'image_front_small_url': imageUrl,
      'additives_tags': additivesTags,
    };
  }

  Product toEntity() {
    return Product(
      code: code,
      productName: productName,
      brands: brands,
      imageUrl: imageUrl,
      additivesTags: additivesTags,
    );
  }
}
