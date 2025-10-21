import 'package:dio/dio.dart';
import 'package:ic_batch3_flutter_classes/core/network/dio_api_client.dart';

class DioClient {
  static DioClient? _instance;
  late Dio _dio;
  late DioApiClient _apiClient;

  DioClient._internal() {
    _dio = Dio();
    _setupInterceptors();
    _apiClient = DioApiClient(dio: _dio);
  }

  static DioClient get instance {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;
  DioApiClient get apiClient => _apiClient;

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      // Logging interceptor
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (log) => print('Dio Log: $log'),
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
