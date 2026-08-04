import 'api_exception.dart';

/// Uniform wrapper every service method returns instead of raw data or a
/// thrown exception — providers check [isSuccess]/[isFailure] and never need
/// a try/catch of their own.
class ApiResponse<T> {
  const ApiResponse._({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  /// Success response
  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse._(success: true, data: data, message: message);
  }

  /// Failure response
  factory ApiResponse.failure(ApiException error, {String? message}) {
    return ApiResponse._(
      success: false,
      error: error,
      message: message ?? error.message,
    );
  }

  /// Create ApiResponse from backend JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponse._(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  final bool success;
  final T? data;
  final String? message;
  final ApiException? error;

  bool get isSuccess => success;

  bool get isFailure => !success;

  @override
  String toString() {
    return '''
ApiResponse(
  success: $success,
  message: $message,
  data: $data,
  error: $error,
)
''';
  }
}
