import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/auth/otp_resend_request.dart';
import 'package:flutter_nivasshub/models/auth/otp_resend_response_data.dart';
import 'package:flutter_nivasshub/models/auth/user_registration_verify_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/user_registration_verify_otp_response_data.dart';
import 'package:flutter_nivasshub/services/auth/otp_verification_service_base.dart';

/// In-memory stand-in for [OtpVerificationService], used by widget tests
/// so they don't need live `POST /country-codes/user-registration/verify-otp`
/// or `POST /otp/resend` calls. Any 6-digit code verifies successfully.
class FakeOtpVerificationService implements OtpVerificationServiceBase {
  const FakeOtpVerificationService();

  @override
  Future<ApiResponse<UserRegistrationVerifyOtpResponseData>> verifyOtp(
    UserRegistrationVerifyOtpRequest request,
  ) async {
    return ApiResponse.success(
      UserRegistrationVerifyOtpResponseData(verified: request.otp.length == 6),
    );
  }

  @override
  Future<ApiResponse<OtpResendResponseData>> resendOtp(
    OtpResendRequest request,
  ) async {
    return ApiResponse.success(
      OtpResendResponseData(identifier: request.identifier, expiresAt: ''),
    );
  }
}
