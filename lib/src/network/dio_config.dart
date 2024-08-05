import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndeals/src/constants/api_endpoints.dart';
import 'custom_interceptor.dart';

class DioConfig {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 3),
        receiveTimeout: const Duration(seconds: 3),
        sendTimeout: const Duration(seconds: 3),
      ),
    );

    dio.interceptors.add(CustomInterceptor());

    return dio;
  }
}

final dioProvider = Provider<Dio>((ref) {
  return DioConfig.createDio();
});
