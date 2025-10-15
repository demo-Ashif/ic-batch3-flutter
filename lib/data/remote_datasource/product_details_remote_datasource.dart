import 'package:ic_batch3_flutter_classes/core/network/api_client.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product_details.dart';

class ProductDetailsRemoteDataSource {
  ProductDetailsRemoteDataSource({required this.apiClient});

  final ApiClient apiClient;

  Future<ProductDetails> fetchProductDetails(int productId) async {
    final response = await apiClient.get('/api/ProductDetailsById/$productId');

    if (response['msg'] == 'success' && response['data'] != null) {
      final data = response['data'] as List;
      if (data.isNotEmpty) {
        return ProductDetails.fromJson(data.first as Map<String, dynamic>);
      }
    }

    throw Exception('Failed to fetch product details');
  }
}