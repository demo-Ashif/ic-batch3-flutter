import 'package:ic_batch3_flutter_classes/core/network/dio_client.dart';

class DioUsageExample {
  static Future<void> demonstrateUsage() async {
    // Get Dio client instance
    final dioClient = DioClient.instance;

    // Configure the client
    dioClient.configureBaseUrl('https://ecommerce-api.codesilicon.com');
    dioClient.configureHeaders({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    dioClient.configureTimeout(const Duration(seconds: 30));

    // Get the API client
    final apiClient = dioClient.apiClient;

    try {
      // Example 1: GET request using convenience method
      print('Making GET request...');
      final response = await apiClient.getMethod('/api/ListProductByBrand/1');
      print('GET Response: $response');

      // Example 2: POST request using convenience method
      print('Making POST request...');
      final postResponse = await apiClient.postMethod(
        '/api/endpoint',
        data: {'email': 'test@example.com', 'password': 'password123'},
      );
      print('POST Response: $postResponse');

      // Example 3: GET request with query parameters
      print('Making GET request with query params...');
      final queryResponse = await apiClient.getMethod(
        '/api/search',
        queryParameters: {'q': 'flutter', 'page': 1, 'limit': 10},
      );
      print('Query Response: $queryResponse');

      // Example 4: Using generic methods for different return types
      print('Using generic methods...');
      final stringResponse = await apiClient.get<String>('/api/text');
      final listResponse = await apiClient.get<List<dynamic>>('/api/list');

      print('String Response: $stringResponse');
      print('List Response: $listResponse');
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}

// Usage in your app
void main() async {
  // Initialize Dio client
  final dioClient = DioClient.instance;
  dioClient.configureBaseUrl('https://ecommerce-api.codesilicon.com');

  // Use the API client
  final apiClient = dioClient.apiClient;

  try {
    // Make API calls
    final products = await apiClient.getMethod('/api/ListProductByBrand/1');
    print('Products: $products');
  } catch (e) {
    print('Error: $e');
  }
}
