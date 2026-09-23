import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_otp_response_data.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_resend_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_send_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_update_password_request.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_update_password_response_data.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_verify_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_verify_otp_response_data.dart';
import 'package:flutter_nivasshub/services/auth/forgot_password_service_base.dart';

/// Simulates the `/auth/forgot-password*` backend while it's not ready yet.
/// No `ApiClient`/Dio dependency — just canned responses behind realistic
/// delays. Selected instead of [ForgotPasswordService] via the `useMockApi`
/// flag in `auth_config.dart` — swap that flag, not this file, once the
/// backend is live.
///
/// Manual test hooks (mirrors `MockAuthService`'s `'taken@example.com'`/
/// `'1234'` convention) — use these `umail` values on the Send/Resend OTP
/// screens to exercise each documented error family, and these OTP/password
/// values on the later screens:
///  - `'4030204000'` (mobile) / `'badrequest@example.com'`   -> 400
///  - `'4030203000'` (mobile) / `'forbidden@example.com'`    -> 403
///  - `'4030201000'` (mobile) / `'notfound@example.com'`     -> 404
///  - `'4030205000'` (mobile) / `'ratelimited@example.com'`  -> 429
///  - `'4030206000'` (mobile) / `'servererror@example.com'`  -> 500
///  - any other valid mobile/email                            -> success
///  - OTP `'123456'` (fixed dev OTP)                          -> verify success
///  - any other 6-digit OTP                                   -> "Invalid OTP"
///  - new password `'serverfail123!A'`                        -> update-password 500
class MockForgotPasswordService implements ForgotPasswordServiceBase {
  static const String _devOtp = '123456';

  @override
  Future<ApiResponse<ForgotPasswordOtpResponseData>> sendOtp(
    ForgotPasswordSendOtpRequest request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return _mockOtpResponse(request.identifier);
  }

  @override
  Future<ApiResponse<ForgotPasswordOtpResponseData>> resendOtp(
    ForgotPasswordResendOtpRequest request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 900));
    return _mockOtpResponse(request.identifier);
  }

  static ApiResponse<ForgotPasswordOtpResponseData> _mockOtpResponse(String identifier) {
    final failure = _errorForIdentifier(identifier);
    if (failure != null) return ApiResponse.failure(failure);

    return ApiResponse.success(
      ForgotPasswordOtpResponseData(
        otpKey: 'MOCK_OTP_KEY_${DateTime.now().millisecondsSinceEpoch}',
        identifier: identifier,
        otpType: 'UFP',
        otp: _devOtp,
      ),
    );
  }

  static ApiException? _errorForIdentifier(String identifier) {
    switch (identifier) {
      case '4030204000':
      case 'badrequest@example.com':
        return const ApiException(
          message: 'Enter user mobile or mail address.',
          type: ApiExceptionType.badRequest,
        );
      case '4030203000':
      case 'forbidden@example.com':
        return const ApiException(
          message: 'Process declined. Mail or mobile is not verified.',
          type: ApiExceptionType.forbidden,
        );
      case '4030201000':
      case 'notfound@example.com':
        return const ApiException(
          message: 'User not found.',
          type: ApiExceptionType.notFound,
        );
      case '4030205000':
      case 'ratelimited@example.com':
        return const ApiException(
          message: 'Please wait 17 second(s) before requesting another resend.',
          type: ApiExceptionType.tooManyRequests,
        );
      case '4030206000':
      case 'servererror@example.com':
        return const ApiException(
          message: 'An unexpected error occurred while processing the request.',
          type: ApiExceptionType.server,
        );
      default:
        return null;
    }
  }

  @override
  Future<ApiResponse<ForgotPasswordVerifyOtpResponseData>> verifyOtp(
    ForgotPasswordVerifyOtpRequest request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (request.otp != _devOtp) {
      return ApiResponse.failure(
        const ApiException(
          message: 'Invalid OTP. Please try again.',
          type: ApiExceptionType.badRequest,
        ),
      );
    }

    return ApiResponse.success(
      ForgotPasswordVerifyOtpResponseData(
        fpToken: 'MOCK_FP_TOKEN_${DateTime.now().millisecondsSinceEpoch}',
      ),
    );
  }

  @override
  Future<ApiResponse<ForgotPasswordUpdatePasswordResponseData>> updatePassword(
    ForgotPasswordUpdatePasswordRequest request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    // Test hook mirroring the other mock services' convention, so the
    // documented 500 failure path is manually testable.
    if (request.newPassword == 'serverfail123!A') {
      return ApiResponse.failure(
        const ApiException(
          message: 'An unexpected error occurred while updating the password.',
          type: ApiExceptionType.server,
        ),
      );
    }

    return ApiResponse.success(
      const ForgotPasswordUpdatePasswordResponseData(),
      message: 'Password updated successfully.',
    );
  }
}
