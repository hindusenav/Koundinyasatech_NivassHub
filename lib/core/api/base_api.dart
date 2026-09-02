import 'package:dio/dio.dart';
import 'package:flutter_nivasshub/core/api/endpoints.dart';
import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/interceptors/auth_interceptor.dart';
import 'package:flutter_nivasshub/core/api/interceptors/error_interceptor.dart';
import 'package:flutter_nivasshub/core/api/interceptors/logging_interceptor.dart';

/// Thin wrapper around [Dio] — the only place in the app that talks HTTP
/// directly. Feature services call these generic methods; nothing outside
/// `core/network` should construct a [Dio] instance of its own.
class ApiClient {
  ApiClient({
    Future<String?> Function()? getAccessToken,
    Future<void> Function()? onUnauthorized,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _dio.options
      ..baseUrl = ApiEndpoints.baseUrl
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 15)
      ..sendTimeout = const Duration(seconds: 15)
      ..responseType = ResponseType.json;

    _dio.interceptors.addAll([
      if (getAccessToken != null)
        AuthInterceptor(
          getAccessToken: getAccessToken,
          onUnauthorized: onUnauthorized,
        ),
      ErrorInterceptor(),
      LoggingInterceptor(),
    ]);
  }

  final Dio _dio;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _request(
      () => _dio.get(path, queryParameters: queryParameters, options: options),
    );
  }

  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _request(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _request(
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _request(
      () => _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _request(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  /// Multipart upload. [files] maps a form field name to a file path on
  /// disk; [fields] are plain text form fields sent alongside the files.
  Future<Response<dynamic>> uploadFile(
    String path, {
    required Map<String, String> files,
    Map<String, dynamic>? fields,
    void Function(int sent, int total)? onSendProgress,
  }) {
    return _request(() async {
      final formData = FormData.fromMap({
        ...?fields,
        for (final entry in files.entries)
          entry.key: await MultipartFile.fromFile(
            entry.value,
            filename: entry.value.split('/').last,
          ),
      });
      return _dio.post(path, data: formData, onSendProgress: onSendProgress);
    });
  }

  Future<Response<dynamic>> _request(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (e) {
      if (e.error is ApiException) throw e.error as ApiException;
      throw ApiException.fromDioException(e);
    }
  }
}
