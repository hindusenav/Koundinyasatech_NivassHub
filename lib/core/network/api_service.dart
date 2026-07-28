import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_exception.dart';
import 'api_response.dart';

/// Base class every feature service (`features/*/services/*.dart`) extends.
/// Wraps an [ApiClient] call with consistent parsing and error handling so
/// individual services don't repeat try/catch boilerplate.
abstract class ApiService {
  const ApiService(this.client);

  final ApiClient client;

  /// Runs [request], parses the raw response body with [fromJson], and
  /// returns a typed [ApiResponse]. Any [ApiException] — or unexpected
  /// error — is captured as [ApiResponse.failure] instead of propagating,
  /// so providers never need their own try/catch around a service call.
  Future<ApiResponse<T>> handleRequest<T>(
    Future<Response<dynamic>> Function() request,
    T Function(dynamic json) fromJson,
  ) async {
    try {
      final response = await request();
      return ApiResponse.success(fromJson(response.data));
    } on ApiException catch (e) {
      return ApiResponse.failure(e);
    } catch (e) {
      return ApiResponse.failure(
        const ApiException(
          message: 'Something went wrong. Please try again.',
          type: ApiExceptionType.unknown,
        ),
      );
    }
  }
}
