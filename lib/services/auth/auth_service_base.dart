import 'package:flutter_nivasshub/services/core/api_response.dart';
import 'package:flutter_nivasshub/models/auth/register_request.dart';
import 'package:flutter_nivasshub/models/auth/register_response_data.dart';
import 'package:flutter_nivasshub/models/auth/resend_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/send_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/send_otp_response_data.dart';
import 'package:flutter_nivasshub/models/auth/verify_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/verify_otp_response_data.dart';

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
