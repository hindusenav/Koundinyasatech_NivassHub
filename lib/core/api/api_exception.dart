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
  });

  final String message;
  final ApiExceptionType type;
  final int? statusCode;

  /// Field-level validation errors, e.g. `{"email": ["already taken"]}`,
  /// when [type] is [ApiExceptionType.validation].
  final Map<String, List<String>>? fieldErrors;

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
        return _fromStatusCode(e);

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

    switch (statusCode) {
      case 400:
        return ApiException(
          message: serverMessage ?? 'Invalid request.',
          type: ApiExceptionType.badRequest,
          statusCode: statusCode,
          fieldErrors: _extractFieldErrors(body),
        );
      case 401:
        return ApiException(
          message:
              serverMessage ?? 'Your session has expired. Please log in again.',
          type: ApiExceptionType.unauthorized,
          statusCode: statusCode,
        );
      case 403:
        return ApiException(
          message: serverMessage ?? 'You do not have permission to do this.',
          type: ApiExceptionType.forbidden,
          statusCode: statusCode,
        );
      case 404:
        return ApiException(
          message: serverMessage ?? 'The requested resource was not found.',
          type: ApiExceptionType.notFound,
          statusCode: statusCode,
        );
      case 409:
        return ApiException(
          message: serverMessage ?? 'This action conflicts with existing data.',
          type: ApiExceptionType.conflict,
          statusCode: statusCode,
        );
      case 422:
        return ApiException(
          message: serverMessage ?? 'Some fields are invalid.',
          type: ApiExceptionType.validation,
          statusCode: statusCode,
          fieldErrors: _extractFieldErrors(body),
        );
      default:
        if (statusCode != null && statusCode >= 500) {
          return ApiException(
            message: serverMessage ?? 'Server error. Please try again later.',
            type: ApiExceptionType.server,
            statusCode: statusCode,
          );
        }
        return ApiException(
          message: serverMessage ?? 'Something went wrong. Please try again.',
          type: ApiExceptionType.unknown,
          statusCode: statusCode,
        );
    }
  }

  static String? _extractMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      final message = body['message'] ?? body['error'];
      if (message is String) return message;
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
