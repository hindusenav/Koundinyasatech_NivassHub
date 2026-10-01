import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/auth/user_registration_verify_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/user_registration_verify_otp_response_data.dart';

/// `POST /country-codes/user-registration/verify-otp`
/// — verifies the mobile and email OTPs sent
/// after registration.
abstract class OtpVerificationServiceBase {
  Future<ApiResponse<UserRegistrationVerifyOtpResponseData>> verifyOtp(
    UserRegistrationVerifyOtpRequest request,
  );
}
