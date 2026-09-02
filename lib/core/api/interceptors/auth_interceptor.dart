import 'package:dio/dio.dart';

/// Attaches the current access token to every outgoing request and reacts
/// to `401` responses. Takes the token/refresh logic as callbacks rather
/// than depending on a concrete storage service directly, so the network
/// layer stays decoupled from `core/storage`.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.getAccessToken,
    this.onUnauthorized,
  });

  final Future<String?> Function() getAccessToken;

  /// Called once when a request comes back `401` — typically used to clear
  /// the session and redirect to the login screen.
  final Future<void> Function()? onUnauthorized;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await onUnauthorized?.call();
    }
    handler.next(err);
  }
}
