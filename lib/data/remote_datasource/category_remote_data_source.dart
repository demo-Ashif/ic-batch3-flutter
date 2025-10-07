import 'package:ic_batch3_flutter_classes/core/network/api_client.dart';
import 'package:ic_batch3_flutter_classes/domain/models/category.dart';

/// Remote data source that fetches categories from the ecommerce API.
class CategoryRemoteDataSource {
  CategoryRemoteDataSource({required this.apiClient});

  final ApiClient apiClient;

  /// Fetch a list of categories.
  Future<List<Category>> fetchCategories() async {
    final result = await apiClient.get('/api/CategoryList');
    final data = (result is Map<String, dynamic>) ? result['data'] : result;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((e) => Category.fromJson(e))
          .toList();
    }
    if (data is List<dynamic>) {
      return data
          .map((e) => Category.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return [];
  }
}
