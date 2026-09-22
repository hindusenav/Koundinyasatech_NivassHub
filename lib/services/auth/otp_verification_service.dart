import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/core/api/api_service.dart';
import 'package:flutter_nivasshub/core/api/endpoints.dart';
import 'package:flutter_nivasshub/models/auth/otp_resend_request.dart';
import 'package:flutter_nivasshub/models/auth/otp_resend_response_data.dart';
import 'package:flutter_nivasshub/models/auth/user_registration_verify_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/user_registration_verify_otp_response_data.dart';
import 'package:flutter_nivasshub/services/auth/otp_verification_service_base.dart';

/// Dio-backed implementation of `POST
/// /country-codes/user-registration/verify-otp` and `POST /otp/resend`.
class OtpVerificationService extends ApiService implements OtpVerificationServiceBase {
  const OtpVerificationService(super.client);

  @override
  Future<ApiResponse<UserRegistrationVerifyOtpResponseData>> verifyOtp(
    UserRegistrationVerifyOtpRequest request,
  ) {
    return handleRequest(
      () => client.post(
        ApiEndpoints.userRegistrationVerifyOtp,
        data: request.toJson(),
      ),
      (json) {
        final map = json as Map<String, dynamic>;
        final data = map['data'];
        return UserRegistrationVerifyOtpResponseData.fromJson(
          data is Map ? Map<String, dynamic>.from(data) : const {},
        );
      },
    );
  }

  @override
  Future<ApiResponse<OtpResendResponseData>> resendOtp(
    OtpResendRequest request,
  ) {
    return handleRequest(
      () => client.post(ApiEndpoints.otpResend, data: request.toJson()),
      (json) {
        final map = json as Map<String, dynamic>;
        final data = map['data'];
        return OtpResendResponseData.fromJson(
          data is Map ? Map<String, dynamic>.from(data) : const {},
        );
      },
    );
  }
}
