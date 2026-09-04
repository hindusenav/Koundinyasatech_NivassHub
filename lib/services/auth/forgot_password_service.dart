import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/core/api/api_service.dart';
import 'package:flutter_nivasshub/core/api/endpoints.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_otp_response_data.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_resend_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_send_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_update_password_request.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_update_password_response_data.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_verify_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_verify_otp_response_data.dart';
import 'package:flutter_nivasshub/services/auth/forgot_password_service_base.dart';

/// Real Dio-backed implementation, selected instead of
/// [MockForgotPasswordService] once `useMockApi` (in `auth_config.dart`) is
/// flipped to `false`.
///
/// Unlike `AuthService`, this does NOT route responses through a shared
/// `{success, message, data}` unwrap helper — the three forgot-password
/// endpoints each return a genuinely different envelope shape (see the
/// doc comments on the response models in `lib/models/auth/`), so each
/// method here checks that endpoint's own documented failure signal
/// directly off the raw response body.
class ForgotPasswordService extends ApiService implements ForgotPasswordServiceBase {
  const ForgotPasswordService(super.client);

  @override
  Future<ApiResponse<ForgotPasswordOtpResponseData>> sendOtp(
    ForgotPasswordSendOtpRequest request,
  ) {
    return handleRequest(
      () => client.post(ApiEndpoints.forgotPassword, data: request.toJson()),
      (json) => ForgotPasswordOtpResponseData.fromJson(_checkOtpBody(json)),
    );
  }

  @override
  Future<ApiResponse<ForgotPasswordOtpResponseData>> resendOtp(
    ForgotPasswordResendOtpRequest request,
  ) {
    return handleRequest(
      () => client.post(ApiEndpoints.forgotPassword, data: request.toJson()),
      (json) => ForgotPasswordOtpResponseData.fromJson(_checkOtpBody(json)),
    );
  }

  @override
  Future<ApiResponse<ForgotPasswordVerifyOtpResponseData>> verifyOtp(
    ForgotPasswordVerifyOtpRequest request,
  ) {
    return handleRequest(
      () => client.post(ApiEndpoints.forgotPasswordVerifyOtp, data: request.toJson()),
      (json) => ForgotPasswordVerifyOtpResponseData.fromJson(_checkVerifyBody(json)),
    );
  }

  @override
  Future<ApiResponse<ForgotPasswordUpdatePasswordResponseData>> updatePassword(
    ForgotPasswordUpdatePasswordRequest request,
  ) {
    return handleRequest(
      () => client.post(ApiEndpoints.forgotPasswordUpdatePassword, data: request.toJson()),
      (json) => _checkUpdatePasswordBody(json),
    );
  }

  /// POST /auth/forgot-password (GENERATE and RESEND) reports failure via
  /// `Success: false` + a PascalCase `Message`, independent of HTTP status.
  static Map<String, dynamic> _checkOtpBody(dynamic json) {
    final map = json as Map<String, dynamic>;
    if (map['Success'] == false) {
      throw ApiException(
        message: map['Message'] as String? ?? 'Request failed. Please try again.',
        type: ApiExceptionType.badRequest,
      );
    }
    return map;
  }

  /// POST /auth/forgot-password/verify-otp reports failure via lower-case
  /// `success: false` + `message`.
  static Map<String, dynamic> _checkVerifyBody(dynamic json) {
    final map = json as Map<String, dynamic>;
    if (map['success'] == false) {
      throw ApiException(
        message: map['message'] as String? ?? 'OTP verification failed.',
        type: ApiExceptionType.badRequest,
      );
    }
    return map;
  }

  /// POST /auth/forgot-password/update-password has no `success` boolean at
  /// all — `HttpStatus == 200` IS success.
  static ForgotPasswordUpdatePasswordResponseData _checkUpdatePasswordBody(dynamic json) {
    final map = json as Map<String, dynamic>;
    if (map['HttpStatus'] != 200) {
      throw ApiException(
        message: map['Message'] as String? ?? 'Failed to update password.',
        type: ApiExceptionType.badRequest,
      );
    }
    return const ForgotPasswordUpdatePasswordResponseData();
  }
}
