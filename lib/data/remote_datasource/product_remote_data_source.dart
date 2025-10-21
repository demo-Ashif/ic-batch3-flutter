import 'package:ic_batch3_flutter_classes/core/network/api_client.dart';
import 'package:ic_batch3_flutter_classes/core/network/dio_api_client.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product.dart';

/// Remote data source that fetches products from the ecommerce API.
class ProductRemoteDataSource {
  ProductRemoteDataSource({required this.apiClient});

  final DioApiClient apiClient;

  /// Fetch all products.
  Future<List<Product>> fetchProducts() async {
    // TODO: Replace with all-products endpoint if available.
    // Using brand 1 as a default initial product list.
    final result = await apiClient.get('/api/ListProductByBrand/1');
    final data = (result is Map<String, dynamic>) ? result['data'] : result;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((e) => Product.fromJson(e))
          .toList();
    }
    if (data is List<dynamic>) {
      return data
          .map((e) => Product.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return [];
  }

  /// Fetch products by brand ID.
  Future<List<Product>> fetchProductsByBrand(int brandId) async {
    final result = await apiClient.get('/api/ListProductByBrand/$brandId');
    final data = (result is Map<String, dynamic>) ? result['data'] : result;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((e) => Product.fromJson(e))
          .toList();
    }
    if (data is List<dynamic>) {
      return data
          .map((e) => Product.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return [];
  }
}
