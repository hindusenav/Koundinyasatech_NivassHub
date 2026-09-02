import 'package:dio/dio.dart';
import 'package:flutter_nivasshub/services/core/api_exception.dart';

/// Converts every [DioException] into an [ApiException] exactly once, at
/// the edge of the network layer, and attaches it as `err.error`. Downstream
/// code (`ApiClient`, `ApiService`) only ever needs to check
/// `err.error is ApiException` instead of re-deriving it from status codes.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(
      err.copyWith(error: ApiException.fromDioException(err)),
    );
  }
}
