import 'package:dio/dio.dart';

import 'api_service.dart';

class DioApiClient extends ApiService {
  DioApiClient({required Dio dio}) : super(dio);

  // Convenience method for GET requests that returns Map<String, dynamic>
  Future<Map<String, dynamic>> getMethod(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await get<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Convenience method for POST requests that returns Map<String, dynamic>
  Future<Map<String, dynamic>> postMethod(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await post<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
  
}
