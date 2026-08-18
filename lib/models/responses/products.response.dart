import 'package:rexone_mobile/models/product.model.dart';

class ProductsResponse {
  final List<ProductModel> products;

  const ProductsResponse({required this.products});

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['products'] as List<dynamic>? ?? [];

    return ProductsResponse(
      products: raw
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .where((product) => product.active)
          .toList(),
    );
  }
}
