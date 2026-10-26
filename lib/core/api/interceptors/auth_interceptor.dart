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
    // A 401 only means "the session expired" when the failed request was
    // actually carrying our bearer token. Pre-auth endpoints (login itself,
    // registration-check, forgot-password) never attach one and can return
    // their own documented 401 for business reasons (wrong password, OTP
    // mismatch) — forcing a logout/redirect for those disposes whatever
    // screen is mid-request and crashes it, and hijacks a login/forgot-
    // password error the screen already knows how to show inline.
    final hadAuthHeader =
        (err.requestOptions.headers['Authorization'] as String?)
            ?.isNotEmpty ??
        false;
    if (err.response?.statusCode == 401 && hadAuthHeader) {
      await onUnauthorized?.call();
    }
    handler.next(err);
  }
}
