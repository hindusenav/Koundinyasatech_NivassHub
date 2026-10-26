import 'package:dio/dio.dart';

/// Broad category of an [ApiException] — lets UI code decide how to react
/// (e.g. show a retry button on [network]/[timeout], redirect to login on
/// [unauthorized]) without string-matching messages.
enum ApiExceptionType {
  network,
  timeout,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  tooManyRequests,
  validation,
  server,
  cancelled,
  unknown,
}

/// Single exception type for every network failure in the app. Feature
/// services should never let a raw [DioException] escape — always convert
/// via [ApiException.fromDioException] (done automatically by
/// `ErrorInterceptor`).
class ApiException implements Exception {
  const ApiException({
    required this.message,
    required this.type,
    this.statusCode,
    this.fieldErrors,
    this.data,
    this.code,
  });

  final String message;
  final ApiExceptionType type;
  final int? statusCode;

  /// Field-level validation errors, e.g. `{"email": ["already taken"]}`,
  /// when [type] is [ApiExceptionType.validation].
  final Map<String, List<String>>? fieldErrors;

  /// The raw error response body, when it parsed as a JSON object. A
  /// non-2xx response can still carry a business payload alongside its
  /// `message` (e.g. `registration-check`'s 409/422 `data.userId` for an
  /// already-registered account) — callers that need it read it from
  /// here instead of re-fetching or re-decoding anything.
  final Map<String, dynamic>? data;

  /// The backend's machine-readable `code` / `errorCode` (e.g.
  /// `USER_ALREADY_REGISTERED`, `OTP_MISMATCH`), when the body carries one.
  /// Prefer this over matching on [message] text.
  final String? code;

  /// `meta.correlationId` from the error body, for logs and support.
  String? get correlationId {
    final meta = data?['meta'];
    return meta is Map ? meta['correlationId'] as String? : null;
  }

  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const ApiException(
          message: 'The request timed out. Please try again.',
          type: ApiExceptionType.timeout,
        );

      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'No internet connection. Please check your network.',
          type: ApiExceptionType.network,
        );

      case DioExceptionType.cancel:
        return const ApiException(
          message: 'Request was cancelled.',
          type: ApiExceptionType.cancelled,
        );

      case DioExceptionType.badResponse:
        return _fromStatusCode(e)._withCode(_extractCode(e.response?.data));

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return ApiException(
          message: e.message ?? 'Something went wrong. Please try again.',
          type: ApiExceptionType.unknown,
        );
    }
  }

  static ApiException _fromStatusCode(DioException e) {
    final statusCode = e.response?.statusCode;
    final body = e.response?.data;
    final serverMessage = _extractMessage(body);
    final data = body is Map<String, dynamic> ? body : null;

    switch (statusCode) {
      case 400:
        return ApiException(
          message: serverMessage ?? 'Invalid request.',
          type: ApiExceptionType.badRequest,
          statusCode: statusCode,
          fieldErrors: _extractFieldErrors(body),
          data: data,
        );
      case 401:
        return ApiException(
          message:
              serverMessage ?? 'Your session has expired. Please log in again.',
          type: ApiExceptionType.unauthorized,
          statusCode: statusCode,
          data: data,
        );
      case 403:
        return ApiException(
          message: serverMessage ?? 'You do not have permission to do this.',
          type: ApiExceptionType.forbidden,
          statusCode: statusCode,
          data: data,
        );
      case 404:
        return ApiException(
          message: serverMessage ?? 'The requested resource was not found.',
          type: ApiExceptionType.notFound,
          statusCode: statusCode,
          data: data,
        );
      case 409:
        return ApiException(
          message: serverMessage ?? 'This action conflicts with existing data.',
          type: ApiExceptionType.conflict,
          statusCode: statusCode,
          data: data,
        );
      case 422:
        return ApiException(
          message: serverMessage ?? 'Some fields are invalid.',
          type: ApiExceptionType.validation,
          statusCode: statusCode,
          fieldErrors: _extractFieldErrors(body),
          data: data,
        );
      case 429:
        return ApiException(
          message: serverMessage ?? 'Too many requests. Please wait and try again.',
          type: ApiExceptionType.tooManyRequests,
          statusCode: statusCode,
          data: data,
        );
      default:
        if (statusCode != null && statusCode >= 500) {
          return ApiException(
            message: serverMessage ?? 'Server error. Please try again later.',
            type: ApiExceptionType.server,
            statusCode: statusCode,
            data: data,
          );
        }
        return ApiException(
          message: serverMessage ?? 'Something went wrong. Please try again.',
          type: ApiExceptionType.unknown,
          statusCode: statusCode,
          data: data,
        );
    }
  }

  ApiException _withCode(String? code) => ApiException(
    message: message,
    type: type,
    statusCode: statusCode,
    fieldErrors: fieldErrors,
    data: data,
    code: code,
  );

  static String? _extractCode(dynamic body) {
    if (body is Map) {
      final code = body['code'] ?? body['errorCode'];
      if (code is String) return code;
    }
    return null;
  }

  static String? _extractMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      // Legacy SQL-stored-procedure endpoints (`/auth/login`,
      // `/country-codes/*`) return PascalCase error fields instead of the
      // generic `message`/`error` most of the API uses.
      final message =
          body['message'] ??
          body['error'] ??
          body['ErrorMsg'] ??
          body['StatusMessage'] ??
          body['Message'];
      if (message is String) return message;
      // Validation failures arrive as a list of messages.
      if (message is List) {
        final parts = message.whereType<String>().toList();
        if (parts.isNotEmpty) return parts.join('\n');
      }
    }
    return null;
  }

  static Map<String, List<String>>? _extractFieldErrors(dynamic body) {
    if (body is Map<String, dynamic> && body['errors'] is Map) {
      final rawErrors = body['errors'] as Map;
      return rawErrors.map(
        (key, value) => MapEntry(
          key.toString(),
          value is List
              ? value.map((e) => e.toString()).toList()
              : [value.toString()],
        ),
      );
    }
    return null;
  }

  bool get isAuthError => type == ApiExceptionType.unauthorized;
  bool get isNetworkError =>
      type == ApiExceptionType.network || type == ApiExceptionType.timeout;

  @override
  String toString() => message;
}
