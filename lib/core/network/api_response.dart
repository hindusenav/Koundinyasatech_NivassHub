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

  factory ApiResponse.success(T data, {String? message}) => ApiResponse._(
        success: true,
        data: data,
        message: message,
      );

  factory ApiResponse.failure(ApiException error, {String? message}) =>
      ApiResponse._(
        success: false,
        error: error,
        message: message ?? error.message,
      );

  final bool success;
  final T? data;
  final String? message;
  final ApiException? error;

  bool get isSuccess => success;
  bool get isFailure => !success;
}
