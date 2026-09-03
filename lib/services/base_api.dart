import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Base API configuration for the application
class BaseApi {
  /// Base URL for all API requests
  static const String baseUrl = 'http://10.10.10.126:3000';
 ///
  /// Create Dio instance with default configuration
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('[API] Request: ${options.method} ${options.path}');
          debugPrint('[API] Data: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('[API] Response: ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('[API] Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}
