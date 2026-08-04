import '../../../core/network/api_response.dart';
import '../models/register_request.dart';
import '../models/register_response_data.dart';
import '../models/resend_otp_request.dart';
import '../models/send_otp_request.dart';
import '../models/send_otp_response_data.dart';
import '../models/verify_otp_request.dart';
import '../models/verify_otp_response_data.dart';

/// Contract `AuthProvider` depends on — lets the real Dio-backed
/// `AuthService` and the demo `MockAuthService` be swapped at the
/// composition root (`main.dart`) via the `useMockApi` flag without either
/// the provider or any screen knowing which one is in use.
abstract class AuthServiceBase {
  Future<ApiResponse<SendOtpResponseData>> sendOtp(SendOtpRequest request);
  Future<ApiResponse<VerifyOtpResponseData>> verifyOtp(VerifyOtpRequest request);

  /// The real `/auth/resend-otp` response carries no `data` payload — only
  /// `{success, message}` — so unlike [sendOtp] there is no fresh expiry to
  /// return.
  Future<ApiResponse<void>> resendOtp(ResendOtpRequest request);

  Future<ApiResponse<RegisterResponseData>> register(RegisterRequest request);
}
