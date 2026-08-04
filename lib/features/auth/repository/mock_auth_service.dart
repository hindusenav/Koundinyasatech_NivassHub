import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../models/register_request.dart';
import '../models/register_response_data.dart';
import '../models/resend_otp_request.dart';
import '../models/send_otp_request.dart';
import '../models/send_otp_response_data.dart';
import '../models/verify_otp_request.dart';
import '../models/verify_otp_response_data.dart';
import 'auth_service_base.dart';

/// Simulates the `/auth/*` backend while it's not ready yet. No `ApiClient`/
/// Dio dependency — just canned responses behind realistic delays, so the
/// existing loading states on the Login/OTP screens behave exactly as they
/// will against the real API. Selected instead of [AuthService] via the
/// `useMockApi` flag in `auth_config.dart` — swap that flag, not this file,
/// once the backend is live.
class MockAuthService implements AuthServiceBase {
  @override
  Future<ApiResponse<SendOtpResponseData>> sendOtp(SendOtpRequest request) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return ApiResponse.success(
      SendOtpResponseData(mobileNumber: request.mobileNumber, otpExpiry: 120),
    );
  }

  @override
  Future<ApiResponse<VerifyOtpResponseData>> verifyOtp(VerifyOtpRequest request) async {
    // Not specified in the mock spec — a short delay so the Verify OTP
    // button's existing loading spinner is visible for a moment instead of
    // an imperceptible flash.
    await Future.delayed(const Duration(milliseconds: 800));

    switch (request.otp) {
      case '1234':
        return ApiResponse.success(
          const VerifyOtpResponseData(
            userExists: false,
            registrationToken: 'temp_registration_token',
          ),
        );
      case '1111':
        return ApiResponse.success(const VerifyOtpResponseData(userExists: true));
      default:
        return ApiResponse.failure(
          const ApiException(message: 'Invalid OTP', type: ApiExceptionType.badRequest),
        );
    }
  }

  @override
  Future<ApiResponse<void>> resendOtp(ResendOtpRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    return ApiResponse<void>.success(null); // no data payload per the real contract
  }

  @override
  Future<ApiResponse<RegisterResponseData>> register(RegisterRequest request) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    // Test hook mirroring verifyOtp's '1234'/'1111' convention, so the
    // documented "Email already exists" failure is manually testable too.
    if (request.email?.trim().toLowerCase() == 'taken@example.com') {
      return ApiResponse.failure(
        const ApiException(message: 'Email already exists', type: ApiExceptionType.conflict),
      );
    }

    return ApiResponse.success(
      const RegisterResponseData(
        userId: 'USR100001',
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
      ),
    );
  }
}
