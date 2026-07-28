import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logs every request/response/error to the console in debug builds only.
/// Never active in release builds — request/response bodies may contain
/// sensitive data.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint('--> ${options.method} ${options.uri}');
      if (options.data != null) debugPrint('    body: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint(
        '<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}',
      );
      debugPrint('    data: ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '<-- ERROR ${err.response?.statusCode} ${err.requestOptions.method} ${err.requestOptions.uri}',
      );
      debugPrint('    message: ${err.message}');
    }
    handler.next(err);
  }
}
