import 'package:flutter_nivasshub/services/core/api_endpoints.dart';
import 'package:flutter_nivasshub/services/core/api_exception.dart';
import 'package:flutter_nivasshub/services/core/api_response.dart';
import 'package:flutter_nivasshub/services/core/api_service.dart';
import 'package:flutter_nivasshub/models/auth/register_request.dart';
import 'package:flutter_nivasshub/models/auth/register_response_data.dart';
import 'package:flutter_nivasshub/models/auth/resend_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/send_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/send_otp_response_data.dart';
import 'package:flutter_nivasshub/models/auth/verify_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/verify_otp_response_data.dart';
import 'package:flutter_nivasshub/services/auth/auth_service_base.dart';

class AuthService extends ApiService implements AuthServiceBase {
  const AuthService(super.client);

  @override
  Future<ApiResponse<SendOtpResponseData>> sendOtp(SendOtpRequest request) {
    return handleRequest(
      () => client.post(ApiEndpoints.sendOtp, data: request.toJson()),
      (json) => SendOtpResponseData.fromJson(_unwrapData(json)),
    );
  }

  @override
  Future<ApiResponse<VerifyOtpResponseData>> verifyOtp(VerifyOtpRequest request) {
    return handleRequest(
      () => client.post(ApiEndpoints.verifyOtp, data: request.toJson()),
      (json) => VerifyOtpResponseData.fromJson(_unwrapData(json)),
    );
  }

  @override
  Future<ApiResponse<void>> resendOtp(ResendOtpRequest request) {
    return handleRequest<void>(
      () => client.post(ApiEndpoints.resendOtp, data: request.toJson()),
      (json) => _unwrapData(json), // throws on {success:false}; no data to return.
    );
  }

  @override
  Future<ApiResponse<RegisterResponseData>> register(RegisterRequest request) {
    return handleRequest(
      () => client.post(ApiEndpoints.register, data: request.toJson()),
      (json) => RegisterResponseData.fromJson(_unwrapData(json)),
    );
  }

  /// The OTP endpoints wrap their payload in `{success, message, data}` and
  /// can report `success: false` with an HTTP 200 (not just via a 4xx status
  /// `ApiClient` would already turn into a `DioException`) — this covers
  /// both cases by throwing `ApiException` here, which `handleRequest`'s
  /// existing catch already converts to `ApiResponse.failure`.
  static Map<String, dynamic> _unwrapData(dynamic json) {
    final map = json as Map<String, dynamic>;
    if (map['success'] == false) {
      throw ApiException(
        message: map['message'] as String? ?? 'Request failed. Please try again.',
        type: ApiExceptionType.badRequest,
      );
    }
    return map['data'] as Map<String, dynamic>? ?? {};
  }
}
