import 'package:flutter/foundation.dart';

/// `data` payload for `POST /auth/verify-otp`.
class VerifyOtpResponseData {
  const VerifyOtpResponseData({required this.userExists, this.registrationToken});

  final bool userExists;

  /// Present only when [userExists] is `false`.
  final String? registrationToken;

  factory VerifyOtpResponseData.fromJson(Map<String, dynamic> json) {
    final userExists = json['userExists'] as bool? ?? false;
    final registrationToken = json['registrationToken'] as String?;
    if (kDebugMode && !userExists && (registrationToken == null || registrationToken.isEmpty)) {
      // Contract violation: verify-otp says this is a new user (userExists
      // == false) but gave no registrationToken to carry into Create
      // Profile. Not thrown here — surfaced instead as a graceful recovery
      // in OtpVerificationSuccessScreen._handleContinue(). Logged so it's
      // visible during development/QA against a misbehaving backend/mock.
      debugPrint(
        '[VerifyOtpResponseData] contract violation: userExists=false but '
        'registrationToken is missing/empty.',
      );
    }
    return VerifyOtpResponseData(userExists: userExists, registrationToken: registrationToken);
  }
}
