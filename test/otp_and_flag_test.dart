import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/models/auth/check_user_exists_request.dart';
import 'package:flutter_nivasshub/models/auth/check_user_exists_response_data.dart';
import 'package:flutter_nivasshub/models/auth/user_registration_verify_otp_request.dart';
import 'package:flutter_nivasshub/models/auth/user_registration_verify_otp_response_data.dart';
import 'package:flutter_nivasshub/providers/auth/otp_mobile_email_verification_provider.dart';
import 'package:flutter_nivasshub/services/auth/auth_entry_service_base.dart';
import 'package:flutter_nivasshub/services/auth/otp_verification_service_base.dart';
import 'package:flutter_nivasshub/utils/flag_emoji.dart';
import 'package:flutter_test/flutter_test.dart';

/// Replays a scripted list of verify results and records every request.
class _ScriptedOtpService implements OtpVerificationServiceBase {
  _ScriptedOtpService(this.verifyResults);

  final List<ApiResponse<UserRegistrationVerifyOtpResponseData>> verifyResults;
  final verifyRequests = <UserRegistrationVerifyOtpRequest>[];

  @override
  Future<ApiResponse<UserRegistrationVerifyOtpResponseData>> verifyOtp(
    UserRegistrationVerifyOtpRequest request,
  ) async {
    verifyRequests.add(request);
    return verifyResults.removeAt(0);
  }
}

/// Counts registration-check calls (the resend path) and answers 412.
class _CountingAuthService implements AuthEntryServiceBase {
  int checks = 0;

  @override
  Future<ApiResponse<CheckUserExistsResponseData>> checkUserExists(
    CheckUserExistsRequest request,
  ) async {
    checks++;
    return ApiResponse.success(
      CheckUserExistsResponseData(
        userExists: true,
        identifier: request.identifier.normalized,
        outcome: RegistrationCheckOutcome.mobileEmailNotVerified,
        registrationToken: 'NEW_TOKEN',
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

const _mobile = AuthIdentifier(
  raw: '9391181130',
  channel: AuthChannel.mobile,
  countryCode: '+91',
);

ApiResponse<UserRegistrationVerifyOtpResponseData> _ok(
  String token,
  String nextStep,
) => ApiResponse.success(
  UserRegistrationVerifyOtpResponseData(
    verified: true,
    sessionToken: token,
    nextStep: nextStep,
  ),
);

ApiResponse<UserRegistrationVerifyOtpResponseData> _fail(
  int status,
  String code, {
  Map<String, dynamic>? data,
}) => ApiResponse.failure(
  ApiException(
    message: 'raw',
    type: ApiExceptionType.unknown,
    statusCode: status,
    code: code,
    data: data,
  ),
);

void main() {
  group('flagEmojiFromIso', () {
    test('maps ISO codes to flags, case-insensitively', () {
      expect(flagEmojiFromIso('IN'), '🇮🇳');
      expect(flagEmojiFromIso('us'), '🇺🇸');
    });

    test('returns null for anything that is not two letters', () {
      expect(flagEmojiFromIso(null), isNull);
      expect(flagEmojiFromIso(''), isNull);
      expect(flagEmojiFromIso('IND'), isNull);
      expect(flagEmojiFromIso('1N'), isNull);
    });
  });

  group('OtpMobileEmailVerificationProvider', () {
    test('UVO keeps the user on OTP; UKYC rotates the token and continues',
        () async {
      final auth = _CountingAuthService();
      final service = _ScriptedOtpService([
        _ok('TOKEN_1', 'UVO'),
        _ok('TOKEN_2', 'UKYC'),
      ]);
      final provider = OtpMobileEmailVerificationProvider(
        service: service,
        authService: auth,
        resendIdentifier: _mobile,
        userId: 'REG_TOKEN',
      );

      await provider.verifyOtp(OtpChannel.mobile, '111111');
      expect(provider.sessionToken, 'TOKEN_1');
      expect(provider.nextStep, 'UVO');
      expect(provider.canContinueToKyc, isFalse);

      await provider.verifyOtp(OtpChannel.email, '222222');
      expect(provider.sessionToken, 'TOKEN_2');
      expect(provider.canContinueToKyc, isTrue);
      // Verify keeps using the registration token, not the session token.
      expect(service.verifyRequests.map((r) => r.userId), everyElement('REG_TOKEN'));
    });

    test('a single pending channel is complete after one verify', () async {
      final auth = _CountingAuthService();
      final service = _ScriptedOtpService([_ok('TOKEN_1', 'UKYC')]);
      final provider = OtpMobileEmailVerificationProvider(
        service: service,
        authService: auth,
        resendIdentifier: _mobile,
        userId: 'REG_TOKEN',
        pendingChannels: const {OtpChannel.email},
        otpJustSent: false,
      );

      expect(provider.stateFor(OtpChannel.mobile).isVerified, isTrue);
      await provider.verifyOtp(OtpChannel.email, '222222');
      expect(provider.canContinueToKyc, isTrue);
    });

    test('OTP_MISMATCH shows attempts remaining and does not resend',
        () async {
      final auth = _CountingAuthService();
      final service = _ScriptedOtpService([
        _fail(401, 'OTP_MISMATCH', data: {
          'data': {'attemptsRemaining': 3},
        }),
      ]);
      final provider = OtpMobileEmailVerificationProvider(
        service: service,
        authService: auth,
        resendIdentifier: _mobile,
        userId: 'REG_TOKEN',
        otpJustSent: false,
      );

      final ok = await provider.verifyOtp(OtpChannel.mobile, '000000');

      expect(ok, isFalse);
      expect(provider.stateFor(OtpChannel.mobile).verifyError, contains('3 attempt'));
      expect(auth.checks, 0);
    });

    test('expired / used / missing / locked-out OTPs trigger a resend',
        () async {
      for (final entry in {
        'OTP_NOT_FOUND': 404,
        'OTP_ALREADY_USED': 409,
        'OTP_EXPIRED': 410,
        'MAX_ATTEMPTS_EXCEEDED': 429,
      }.entries) {
        final auth = _CountingAuthService();
      final service = _ScriptedOtpService([_fail(entry.value, entry.key)]);
        final provider = OtpMobileEmailVerificationProvider(
          service: service,
        authService: auth,
        resendIdentifier: _mobile,
          userId: 'REG_TOKEN',
        );

        await provider.verifyOtp(OtpChannel.mobile, '000000');

        expect(auth.checks, 1, reason: entry.key);
      }
    });
  });
}
