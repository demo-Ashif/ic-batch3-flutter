# Dio Instance Usage Guide

## 🎯 **Where is the Dio Instance?**

The Dio instance is created and managed in the `DioClient` singleton class. Here's how it works:

## 📁 **File Structure**
```
lib/core/network/
├── dio_client.dart          # Singleton Dio client manager
├── dio_api_client.dart      # Convenience methods for API calls
└── api_service.dart         # Abstract base class
```

## 🔧 **How to Get Dio Instance**

### **Method 1: Using DioClient Singleton (Recommended)**
```dart
import 'package:ic_batch3_flutter_classes/core/network/dio_client.dart';

void main() {
  // Get Dio client instance
  final dioClient = DioClient.instance;
  
  // Configure the client
  dioClient.configureBaseUrl('https://ecommerce-api.codesilicon.com');
  dioClient.configureHeaders({
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });
  dioClient.configureTimeout(const Duration(seconds: 30));
  
  // Get the Dio instance
  final dio = dioClient.dio;
  
  // Get the API client (recommended)
  final apiClient = dioClient.apiClient;
}
```

### **Method 2: Direct Dio Instance**
```dart
import 'package:dio/dio.dart';
import 'package:ic_batch3_flutter_classes/core/network/dio_api_client.dart';

void main() {
  // Create Dio instance directly
  final dio = Dio();
  dio.options.baseUrl = 'https://ecommerce-api.codesilicon.com';
  dio.options.headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Create API client
  final apiClient = DioApiClient(dio: dio);
}
```

## 🚀 **Usage Examples**

### **Example 1: Basic API Call**
```dart
import 'package:ic_batch3_flutter_classes/core/network/dio_client.dart';

class ProductService {
  Future<Map<String, dynamic>> getProducts() async {
    // Get API client
    final apiClient = DioClient.instance.apiClient;
    
    // Make API call
    final response = await apiClient.getMethod('/api/ListProductByBrand/1');
    
    return response;
  }
}
```

### **Example 2: POST Request**
```dart
class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final apiClient = DioClient.instance.apiClient;
    
    final response = await apiClient.postMethod(
      '/api/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    
    return response;
  }
}
```

### **Example 3: With Query Parameters**
```dart
class SearchService {
  Future<Map<String, dynamic>> searchProducts(String query) async {
    final apiClient = DioClient.instance.apiClient;
    
    final response = await apiClient.getMethod(
      '/api/search',
      queryParameters: {
        'q': query,
        'page': 1,
        'limit': 20,
      },
    );
    
    return response;
  }
}
```

### **Example 4: Using Generic Methods**
```dart
class DataService {
  Future<List<dynamic>> getList() async {
    final apiClient = DioClient.instance.apiClient;
    
    // Use generic method for different return types
    final response = await apiClient.get<List<dynamic>>('/api/list');
    
    return response;
  }
  
  Future<String> getText() async {
    final apiClient = DioClient.instance.apiClient;
    
    final response = await apiClient.get<String>('/api/text');
    
    return response;
  }
}
```

## 🏗️ **Integration in Your App**

### **Step 1: Initialize in main.dart**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Dio client
  final dioClient = DioClient.instance;
  dioClient.configureBaseUrl('https://ecommerce-api.codesilicon.com');
  dioClient.configureHeaders({
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });
  dioClient.configureTimeout(const Duration(seconds: 30));
  
  runApp(MyApp());
}
```

### **Step 2: Use in Data Sources**
```dart
class ProductRemoteDataSource {
  ProductRemoteDataSource({required this.apiClient});
  
  final DioApiClient apiClient;
  
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await apiClient.getMethod('/api/products');
      final data = response['data'] as List<dynamic>;
      
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }
}
```

### **Step 3: Use in Repositories**
```dart
class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({required this.remoteDataSource});
  
  final ProductRemoteDataSource remoteDataSource;
  
  @override
  Future<List<Product>> getProducts() async {
    return await remoteDataSource.fetchProducts();
  }
}
```

## 🔧 **Configuration Options**

### **Base URL Configuration**
```dart
final dioClient = DioClient.instance;
dioClient.configureBaseUrl('https://api.example.com');
```

### **Headers Configuration**
```dart
dioClient.configureHeaders({
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': 'Bearer your_token_here',
  'User-Agent': 'FlutterApp/1.0',
});
```

### **Timeout Configuration**
```dart
dioClient.configureTimeout(const Duration(seconds: 30));
```

### **Interceptors (Already Configured)**
```dart
// Logging interceptor - logs all requests/responses
// Error interceptor - handles errors consistently
```

## 🎯 **Key Benefits**

1. **✅ Singleton Pattern** - One instance throughout the app
2. **✅ Automatic Configuration** - Headers, timeouts, interceptors
3. **✅ Error Handling** - Consistent error handling across all requests
4. **✅ Logging** - Automatic request/response logging
5. **✅ Type Safety** - Generic methods for different return types
6. **✅ Convenience Methods** - Easy-to-use methods for common operations

## 🚨 **Important Notes**

- **DioClient.instance** creates a singleton - only one instance exists
- **Configuration is done once** in main.dart
- **All API calls use the same configured instance**
- **Error handling is automatic** via interceptors
- **Logging is enabled by default** (can be disabled for production)

## 📝 **Complete Example**

See the following files for complete examples:
- `lib/examples/dio_complete_example.dart` - Full Flutter app example
- `lib/examples/dio_usage_example.dart` - Basic usage examples
- `lib/examples/product_dio_datasource_example.dart` - Data source integration
