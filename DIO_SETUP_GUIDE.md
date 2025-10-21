# Dio Package Setup and Implementation Guide

## Table of Contents
1. [What is Dio?](#what-is-dio)
2. [Why Use Dio Over HTTP Package?](#why-use-dio-over-http-package)
3. [Installation](#installation)
4. [Basic Setup](#basic-setup)
5. [Advanced Configuration](#advanced-configuration)
6. [Implementation Steps for Product Repository](#implementation-steps-for-product-repository)
7. [Best Practices](#best-practices)
8. [Error Handling](#error-handling)
9. [Testing with Dio](#testing-with-dio)

## What is Dio?

Dio is a powerful HTTP client for Dart/Flutter that provides:
- **Interceptors**: Request/response transformation
- **Request/Response Cancellation**: Cancel ongoing requests
- **File Upload/Download**: Built-in support for file operations
- **FormData**: Easy multipart/form-data handling
- **Request/Response Logging**: Built-in logging capabilities
- **Global Configuration**: Centralized configuration
- **Cookie Management**: Automatic cookie handling
- **Timeout Configuration**: Per-request and global timeouts

## Why Use Dio Over HTTP Package?

| Feature | HTTP Package | Dio Package |
|---------|-------------|-------------|
| Interceptors | ❌ No | ✅ Yes |
| Request Cancellation | ❌ No | ✅ Yes |
| File Upload/Download | ❌ Manual | ✅ Built-in |
| Global Configuration | ❌ No | ✅ Yes |
| Request/Response Logging | ❌ Manual | ✅ Built-in |
| Cookie Management | ❌ Manual | ✅ Automatic |
| Error Handling | ❌ Basic | ✅ Advanced |
| Request Timeout | ❌ Basic | ✅ Advanced |

## Installation

### Step 1: Add Dio to pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.4.0  # Add this line
  # ... other dependencies
```

### Step 2: Install the package

```bash
flutter pub get
```

## Basic Setup

### Step 1: Create Dio Client

Create a new file: `lib/core/network/dio_client.dart`

```dart
import 'package:dio/dio.dart';

class DioClient {
  static DioClient? _instance;
  late Dio _dio;

  DioClient._internal() {
    _dio = Dio();
    _setupInterceptors();
  }

  static DioClient get instance {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      // Logging interceptor
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (log) => print(log),
      ),
      
      // Error handling interceptor
      InterceptorsWrapper(
        onError: (error, handler) {
          print('Dio Error: ${error.message}');
          handler.next(error);
        },
      ),
    ]);
  }

  // Configure base URL
  void configureBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  // Configure default headers
  void configureHeaders(Map<String, String> headers) {
    _dio.options.headers.addAll(headers);
  }

  // Configure timeout
  void configureTimeout(Duration timeout) {
    _dio.options.connectTimeout = timeout;
    _dio.options.receiveTimeout = timeout;
    _dio.options.sendTimeout = timeout;
  }
}
```

### Step 2: Initialize Dio Client

In your `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'core/network/dio_client.dart';

void main() {
  // Initialize Dio client
  final dioClient = DioClient.instance;
  dioClient.configureBaseUrl('https://your-api-base-url.com');
  dioClient.configureHeaders({
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });
  dioClient.configureTimeout(const Duration(seconds: 30));

  runApp(MyApp());
}
```

## Advanced Configuration

### Step 1: Enhanced Dio Client with Error Handling

```dart
import 'package:dio/dio.dart';

class EnhancedDioClient {
  static EnhancedDioClient? _instance;
  late Dio _dio;

  EnhancedDioClient._internal() {
    _dio = Dio();
    _setupInterceptors();
  }

  static EnhancedDioClient get instance {
    _instance ??= EnhancedDioClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      // Request interceptor
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add authentication token if available
          final token = _getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),

      // Response interceptor
      InterceptorsWrapper(
        onResponse: (response, handler) {
          // Log successful responses
          print('Response: ${response.statusCode} - ${response.requestOptions.path}');
          handler.next(response);
        },
      ),

      // Error interceptor
      InterceptorsWrapper(
        onError: (error, handler) {
          _handleError(error);
          handler.next(error);
        },
      ),

      // Logging interceptor
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (log) => print(log),
      ),
    ]);
  }

  String? _getAuthToken() {
    // Implement your token retrieval logic
    return null;
  }

  void _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        print('Connection timeout');
        break;
      case DioExceptionType.sendTimeout:
        print('Send timeout');
        break;
      case DioExceptionType.receiveTimeout:
        print('Receive timeout');
        break;
      case DioExceptionType.badResponse:
        print('Bad response: ${error.response?.statusCode}');
        break;
      case DioExceptionType.cancel:
        print('Request cancelled');
        break;
      case DioExceptionType.connectionError:
        print('Connection error');
        break;
      case DioExceptionType.unknown:
        print('Unknown error: ${error.message}');
        break;
    }
  }
}
```

### Step 2: API Service Base Class

```dart
import 'package:dio/dio.dart';

abstract class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout. Please check your internet connection.');
      case DioExceptionType.sendTimeout:
        return Exception('Send timeout. Please try again.');
      case DioExceptionType.receiveTimeout:
        return Exception('Receive timeout. Please try again.');
      case DioExceptionType.badResponse:
        return Exception('Server error: ${e.response?.statusCode}');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled.');
      case DioExceptionType.connectionError:
        return Exception('Connection error. Please check your internet connection.');
      case DioExceptionType.unknown:
        return Exception('Unknown error occurred.');
    }
  }
}
```

## Implementation Steps for Product Repository

### Step 1: Update pubspec.yaml

Add Dio dependency to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.4.0  # Add this line
  # ... existing dependencies
```

### Step 2: Create Dio-based API Client

Create `lib/core/network/dio_api_client.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:ic_batch3_flutter_classes/core/network/api_service.dart';

class DioApiClient extends ApiService {
  DioApiClient({required Dio dio}) : super(dio);

  // Generic GET method
  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await get<Map<String, dynamic>>(path, queryParameters: queryParams);
  }

  // Generic POST method
  Future<Map<String, dynamic>> post(String path, {dynamic data, Map<String, dynamic>? queryParams}) async {
    return await post<Map<String, dynamic>>(path, data: data, queryParameters: queryParams);
  }
}
```

### Step 3: Create Dio-based Product Remote Data Source

Create `lib/data/remote_datasource/product_dio_remote_datasource.dart`:

```dart
import 'package:ic_batch3_flutter_classes/core/network/dio_api_client.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product.dart';

class ProductDioRemoteDataSource {
  ProductDioRemoteDataSource({required this.apiClient});

  final DioApiClient apiClient;

  /// Fetch all products using Dio
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await apiClient.get('/api/ListProductByBrand/1');
      final data = response['data'] as List<dynamic>? ?? [];
      
      return data
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  /// Fetch products by brand ID using Dio
  Future<List<Product>> fetchProductsByBrand(int brandId) async {
    try {
      final response = await apiClient.get('/api/ListProductByBrand/$brandId');
      final data = response['data'] as List<dynamic>? ?? [];
      
      return data
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products by brand: $e');
    }
  }

  /// Fetch product details by ID using Dio
  Future<Product> fetchProductDetails(int productId) async {
    try {
      final response = await apiClient.get('/api/ProductDetailsById/$productId');
      final data = response['data'] as Map<String, dynamic>? ?? {};
      
      return Product.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch product details: $e');
    }
  }

  /// Search products using Dio
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await apiClient.get('/api/ProductListByRemark/$query');
      final data = response['data'] as List<dynamic>? ?? [];
      
      return data
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }
}
```

### Step 4: Update Product Repository Implementation

Update `lib/data/repository_impl/product_repository_impl.dart`:

```dart
import 'package:ic_batch3_flutter_classes/data/remote_datasource/product_dio_remote_datasource.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({required this.remoteDataSource});

  final ProductDioRemoteDataSource remoteDataSource;

  @override
  Future<List<Product>> getProductsByBrand(int brandId) async {
    try {
      return await remoteDataSource.fetchProductsByBrand(brandId);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  // Add new methods for enhanced functionality
  Future<List<Product>> getAllProducts() async {
    try {
      return await remoteDataSource.fetchProducts();
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  Future<Product> getProductDetails(int productId) async {
    try {
      return await remoteDataSource.fetchProductDetails(productId);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      return await remoteDataSource.searchProducts(query);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
```

### Step 5: Update Product Repository Interface

Update `lib/domain/repository/product_repository.dart`:

```dart
import 'package:ic_batch3_flutter_classes/domain/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProductsByBrand(int brandId);
  
  // Add new method signatures
  Future<List<Product>> getAllProducts();
  Future<Product> getProductDetails(int productId);
  Future<List<Product>> searchProducts(String query);
}
```

### Step 6: Initialize Dio in Main App

Update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'core/network/dio_client.dart';
import 'core/network/dio_api_client.dart';
import 'data/remote_datasource/product_dio_remote_datasource.dart';
import 'data/repository_impl/product_repository_impl.dart';

void main() {
  // Initialize Dio
  final dioClient = DioClient.instance;
  dioClient.configureBaseUrl('https://your-api-base-url.com');
  dioClient.configureHeaders({
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });
  dioClient.configureTimeout(const Duration(seconds: 30));

  // Initialize API client
  final apiClient = DioApiClient(dio: dioClient.dio);

  // Initialize data sources
  final productRemoteDataSource = ProductDioRemoteDataSource(apiClient: apiClient);

  // Initialize repositories
  final productRepository = ProductRepositoryImpl(remoteDataSource: productRemoteDataSource);

  runApp(MyApp(
    productRepository: productRepository,
  ));
}

class MyApp extends StatelessWidget {
  final ProductRepository productRepository;

  const MyApp({super.key, required this.productRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(productRepository: productRepository),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final ProductRepository productRepository;

  const MyHomePage({super.key, required this.productRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio Implementation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  final products = await productRepository.getProductsByBrand(1);
                  print('Products fetched: ${products.length}');
                } catch (e) {
                  print('Error: $e');
                }
              },
              child: const Text('Fetch Products'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Best Practices

### 1. Error Handling
```dart
try {
  final response = await dio.get('/api/products');
  return response.data;
} on DioException catch (e) {
  if (e.response?.statusCode == 404) {
    throw ProductNotFoundException();
  } else if (e.response?.statusCode == 401) {
    throw UnauthorizedException();
  } else {
    throw NetworkException(e.message);
  }
}
```

### 2. Request Cancellation
```dart
class ProductService {
  CancelToken? _cancelToken;

  Future<List<Product>> fetchProducts() async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    
    try {
      final response = await dio.get(
        '/api/products',
        cancelToken: _cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw RequestCancelledException();
      }
      rethrow;
    }
  }

  void cancelRequest() {
    _cancelToken?.cancel();
  }
}
```

### 3. Request Retry
```dart
class RetryInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 500 && err.requestOptions.extra['retry'] != true) {
      err.requestOptions.extra['retry'] = true;
      final response = await dio.fetch(err.requestOptions);
      handler.resolve(response);
    } else {
      handler.next(err);
    }
  }
}
```

### 4. Authentication Token Refresh
```dart
class AuthInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Refresh token
      final newToken = await refreshToken();
      if (newToken != null) {
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      }
    }
    handler.next(err);
  }
}
```

## Error Handling

### Custom Exception Classes
```dart
abstract class AppException implements Exception {
  final String message;
  AppException(this.message);
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class ProductNotFoundException extends AppException {
  ProductNotFoundException() : super('Product not found');
}

class UnauthorizedException extends AppException {
  UnauthorizedException() : super('Unauthorized access');
}

class RequestCancelledException extends AppException {
  RequestCancelledException() : super('Request was cancelled');
}
```

## Testing with Dio

### Mock Dio for Testing
```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('ProductDioRemoteDataSource Tests', () {
    late MockDio mockDio;
    late ProductDioRemoteDataSource dataSource;

    setUp(() {
      mockDio = MockDio();
      dataSource = ProductDioRemoteDataSource(apiClient: DioApiClient(dio: mockDio));
    });

    test('should fetch products by brand successfully', () async {
      // Arrange
      final mockResponse = {
        'data': [
          {'id': 1, 'title': 'Test Product', 'price': 100, 'image': 'test.jpg'}
        ]
      };
      when(mockDio.get(any)).thenAnswer((_) async => Response(
        data: mockResponse,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/api/ListProductByBrand/1'),
      ));

      // Act
      final result = await dataSource.fetchProductsByBrand(1);

      // Assert
      expect(result, isA<List<Product>>());
      expect(result.length, 1);
      expect(result.first.title, 'Test Product');
    });
  });
}
```

## Summary

This guide provides a comprehensive approach to implementing Dio in your Flutter project:

1. **Installation**: Add Dio to pubspec.yaml
2. **Basic Setup**: Create DioClient with interceptors
3. **Advanced Configuration**: Enhanced error handling and authentication
4. **Implementation**: Step-by-step migration from HTTP to Dio
5. **Best Practices**: Error handling, cancellation, retry logic
6. **Testing**: Mock Dio for unit tests

Dio provides a more robust and feature-rich HTTP client compared to the basic HTTP package, making it ideal for production applications with complex networking requirements.
