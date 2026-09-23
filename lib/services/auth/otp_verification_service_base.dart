import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/auth/otp_resend_request.dart';
import 'package:flutter_nivasshub/models/auth/otp_resend_response_data.dart';
import 'package:flutter_nivasshub/models/auth/user_registration_verify_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/user_registration_verify_otp_response_data.dart';

/// `POST /country-codes/user-registration/verify-otp` and
/// `POST /otp/resend` — verifies/resends the mobile and email OTPs sent
/// after registration.
abstract class OtpVerificationServiceBase {
  Future<ApiResponse<UserRegistrationVerifyOtpResponseData>> verifyOtp(
    UserRegistrationVerifyOtpRequest request,
  );

  Future<ApiResponse<OtpResendResponseData>> resendOtp(
    OtpResendRequest request,
  );
}
