import 'dart:io';

import 'package:dio/dio.dart';

class CustomInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final String message;

    String handleStatusCode(int? statusCode) {
      switch (statusCode) {
        case 400:
          return 'Invalid request';
        case 401:
          return 'Access denied';
        case 403:
          return 'Forbidden';
        case 404:
          return 'Requested information not found';
        case 500:
          return 'Internal server error';
        case 502:
          return 'Bad gateway';
        case 503:
          return 'Service unavailable';
        default:
          return 'Something went wrong';
      }
    }

    switch (err.type) {
      case DioExceptionType.cancel:
        message = 'Request to API server was cancelled';
        break;
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout with API server';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive connection timeout with API server';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send connection timeout with API server';
        break;
      case DioExceptionType.badResponse:
        message = handleStatusCode(err.response?.statusCode);
        break;
      case DioExceptionType.unknown:
        if (err.error is SocketException) {
          message = 'No Internet Connection';
        } else {
          message = 'Something went wrong';
        }
        break;
      default:
        message = 'Something went wrong';
        break;
    }

    super.onError(err.copyWith(message: message), handler);
  }
}
