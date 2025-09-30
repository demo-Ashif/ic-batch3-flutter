import 'package:ic_batch3_flutter_classes/core/network/api_client.dart';
import 'package:ic_batch3_flutter_classes/domain/models/brand.dart';

/// Remote data source that fetches brands from the ecommerce API.
class BrandRemoteDataSource {
  BrandRemoteDataSource({required this.apiClient});

  final ApiClient apiClient;

  /// Fetch a list of brands.
  Future<List<Brand>> fetchBrands() async {
    final result = await apiClient.get('/api/BrandList');
    final data = (result is Map<String, dynamic>) ? result['data'] : result;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((e) => Brand.fromJson(e))
          .toList();
    }
    if (data is List<dynamic>) {
      return data
          .map((e) => Brand.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return [];
  }
}
