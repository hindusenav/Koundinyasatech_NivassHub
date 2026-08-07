import 'api_exception.dart';

class ApiResponse<T> {
  const ApiResponse._({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse._(success: true, data: data, message: message);
  }

  factory ApiResponse.failure(ApiException error, {String? message}) {
    return ApiResponse._(
      success: false,
      error: error,
      message: message ?? error.message,
    );
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    final isSuccessStatus =
        json['status'] == 'success' || (json['success'] == true);
    return ApiResponse._(
      success: isSuccessStatus,
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
}
