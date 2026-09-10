import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_otp_response_data.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_resend_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_send_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_update_password_request.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_update_password_response_data.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_verify_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/forgot_password_verify_otp_response_data.dart';

/// Contract `ForgotPasswordProvider` depends on — lets the real Dio-backed
/// `ForgotPasswordService` and the demo `MockForgotPasswordService` be
/// swapped at the composition root (`main.dart`) via the same `useMockApi`
/// flag used for `AuthServiceBase`, without the provider or any screen
/// knowing which one is in use.
abstract class ForgotPasswordServiceBase {
  Future<ApiResponse<ForgotPasswordOtpResponseData>> sendOtp(
    ForgotPasswordSendOtpRequest request,
  );

  Future<ApiResponse<ForgotPasswordOtpResponseData>> resendOtp(
    ForgotPasswordResendOtpRequest request,
  );

  Future<ApiResponse<ForgotPasswordVerifyOtpResponseData>> verifyOtp(
    ForgotPasswordVerifyOtpRequest request,
  );

  Future<ApiResponse<ForgotPasswordUpdatePasswordResponseData>> updatePassword(
    ForgotPasswordUpdatePasswordRequest request,
  );
}
