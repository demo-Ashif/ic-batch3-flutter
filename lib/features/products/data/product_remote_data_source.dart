import 'package:ic_batch3_flutter_classes/core/network/api_client.dart';
import 'package:ic_batch3_flutter_classes/features/products/domain/product.dart';

/// Remote data source that fetches products from a public API.
class ProductRemoteDataSource {
  ProductRemoteDataSource({required this.apiClient});

  final ApiClient apiClient;

  /// Fetch a list of products.
  /// Uses https://fakestoreapi.com which is great for demos.
  Future<List<Product>> fetchProducts() async {
    final result = await apiClient.get('/products');
    if (result is List) {
      return result
          .whereType<Map<String, dynamic>>()
          .map((e) => Product.fromJson(e))
          .toList();
    }
    if (result is List<dynamic>) {
      return result
          .map((e) => Product.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return [];
  }
}

