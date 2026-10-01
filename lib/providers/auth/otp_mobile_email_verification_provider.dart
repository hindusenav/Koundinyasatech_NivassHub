import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/models/auth/check_user_exists_request.dart';
import 'package:flutter_nivasshub/models/auth/check_user_exists_response_data.dart';
import 'package:flutter_nivasshub/services/auth/auth_entry_service_base.dart';
import 'package:flutter_nivasshub/models/auth/user_registration_verify_otp_request.dart';
import 'package:flutter_nivasshub/services/auth/otp_verification_service_base.dart';

/// Which of the two OTPs sent after registration this call concerns.
/// `wireValue` is exactly the `identifier` the verify/resend APIs expect
/// (`"M"`/`"E"`), and [OtpMobileEmailVerificationProvider] tracks each
/// channel's state independently since they're two separate OTP records
/// server-side.
enum OtpChannel {
  mobile('M'),
  email('E');

  const OtpChannel(this.wireValue);

  final String wireValue;
}

/// Per-channel state for [OtpMobileEmailVerificationProvider] — kept as a
/// plain data holder rather than duplicating every field twice on the
/// provider itself.
class OtpChannelState {
  const OtpChannelState({
    this.isVerifying = false,
    this.isVerified = false,
    this.verifyError,
    this.isResending = false,
    this.resendError,
    this.lastResendAt,
    this.resendCount = 0,
  });

  final bool isVerifying;
  final bool isVerified;
  final String? verifyError;
  final bool isResending;
  final String? resendError;
  final DateTime? lastResendAt;
  final int resendCount;

  OtpChannelState copyWith({
    bool? isVerifying,
    bool? isVerified,
    String? verifyError,
    bool clearVerifyError = false,
    bool? isResending,
    String? resendError,
    bool clearResendError = false,
    DateTime? lastResendAt,
    int? resendCount,
  }) {
    return OtpChannelState(
      isVerifying: isVerifying ?? this.isVerifying,
      isVerified: isVerified ?? this.isVerified,
      verifyError: clearVerifyError ? null : (verifyError ?? this.verifyError),
      isResending: isResending ?? this.isResending,
      resendError: clearResendError ? null : (resendError ?? this.resendError),
      lastResendAt: lastResendAt ?? this.lastResendAt,
      resendCount: resendCount ?? this.resendCount,
    );
  }
}

/// Drives the post-registration Mobile + Email OTP verification screen.
///
/// Mirrors `ForgotPasswordProvider`'s shape (a `ChangeNotifier` wrapping a
/// service interface, plus a resend cooldown) but tracks two independent
/// [OtpChannel]s at once, since this screen verifies both in parallel
/// rather than one flow at a time.
class OtpMobileEmailVerificationProvider extends ChangeNotifier {
  OtpMobileEmailVerificationProvider({
    required OtpVerificationServiceBase service,
    required AuthEntryServiceBase authService,
    AuthIdentifier? resendIdentifier,
    required String userId,
    Set<OtpChannel> pendingChannels = const {OtpChannel.mobile, OtpChannel.email},
    bool otpJustSent = true,
  }) : _service = service,
       _authService = authService,
       _resendIdentifier = resendIdentifier,
       _userId = userId {
    // A channel that is not pending is already verified (resume flows).
    if (!pendingChannels.contains(OtpChannel.mobile)) {
      _mobileState = const OtpChannelState(isVerified: true);
    } else if (otpJustSent) {
      // Registration just sent the OTP: start the resend cooldown now.
      _mobileState = OtpChannelState(lastResendAt: DateTime.now());
    }
    if (!pendingChannels.contains(OtpChannel.email)) {
      _emailState = const OtpChannelState(isVerified: true);
    } else if (otpJustSent) {
      _emailState = OtpChannelState(lastResendAt: DateTime.now());
    }
  }

  final OtpVerificationServiceBase _service;
  final AuthEntryServiceBase _authService;
  final AuthIdentifier? _resendIdentifier;
  String _userId;

  static const _resendCooldown = Duration(seconds: 30);
  static const _maxResends = 5;

  OtpChannelState _mobileState = const OtpChannelState();
  OtpChannelState _emailState = const OtpChannelState();

  OtpChannelState stateFor(OtpChannel channel) =>
      channel == OtpChannel.mobile ? _mobileState : _emailState;

  bool get isFullyVerified => _mobileState.isVerified && _emailState.isVerified;

  String? _sessionToken;
  String? _nextStep;

  /// Latest token from verify-otp (`null` until one succeeds); hand this to
  /// the KYC screens. Rotates on every successful verify.
  String? get sessionToken => _sessionToken;

  /// `UVO` (verify the other channel) or `UKYC` (continue to KYC).
  String? get nextStep => _nextStep;

  /// Ready for KYC: the backend said so, or every pending channel is done.
  bool get canContinueToKyc => _nextStep == 'UKYC' || isFullyVerified;

  void _update(OtpChannel channel, OtpChannelState Function(OtpChannelState) update) {
    if (channel == OtpChannel.mobile) {
      _mobileState = update(_mobileState);
    } else {
      _emailState = update(_emailState);
    }
    notifyListeners();
  }

  Future<bool> verifyOtp(OtpChannel channel, String otp) async {
    _update(
      channel,
      (s) => s.copyWith(isVerifying: true, clearVerifyError: true),
    );

    final response = await _service.verifyOtp(
      UserRegistrationVerifyOtpRequest(
        userId: _userId,
        otp: otp,
        identifier: channel.wireValue,
      ),
    );

    final data = response.data;
    final verified = response.isSuccess && (data?.verified ?? false);

    if (verified) {
      // Token rotation: every successful verify issues a fresh token that
      // replaces the previous one.
      final rotated = data!.sessionToken;
      if (rotated != null && rotated.isNotEmpty) _sessionToken = rotated;
      _nextStep = data.nextStep ?? _nextStep;
      _update(
        channel,
        (s) => s.copyWith(
          isVerifying: false,
          isVerified: true,
          clearVerifyError: true,
        ),
      );
      return true;
    }

    final error = response.error;
    if (error != null) {
      debugPrint(
        '[Otp] verify failed status=${error.statusCode} code=${error.code} '
        'correlationId=${error.correlationId}',
      );
    }
    _update(
      channel,
      (s) => s.copyWith(
        isVerifying: false,
        isVerified: false,
        verifyError: _verifyMessage(error, response.message),
      ),
    );

    // Expired / missing / used / locked-out codes can only be fixed with a
    // new one, so request it right away (bypassing the cooldown).
    if (_needsNewOtp(error)) {
      await resendOtp(channel, force: true);
    }
    return false;
  }

  /// OTP 404 / 409 / 410 / 429 — the current code is unusable.
  static bool _needsNewOtp(ApiException? e) {
    switch (e?.code) {
      case 'OTP_NOT_FOUND':
      case 'OTP_ALREADY_USED':
      case 'OTP_EXPIRED':
      case 'MAX_ATTEMPTS_EXCEEDED':
        return true;
    }
    return const {404, 409, 410, 429}.contains(e?.statusCode);
  }

  /// User-facing message for each documented verify-otp failure.
  static String _verifyMessage(ApiException? e, String? fallback) {
    if (e == null) return fallback ?? 'Invalid OTP. Please try again.';
    final body = e.data;
    final inner = body?['data'];
    final remaining =
        (inner is Map ? inner['attemptsRemaining'] : null) ??
        body?['attemptsRemaining'];

    switch (e.code) {
      case 'OTP_MISMATCH':
        return remaining == null
            ? 'Incorrect OTP. Please try again.'
            : 'Incorrect OTP. $remaining attempt(s) remaining.';
      case 'OTP_NOT_FOUND':
        return 'No active OTP found. We sent you a new one.';
      case 'OTP_ALREADY_USED':
        return 'That OTP was already used. We sent you a new one.';
      case 'OTP_EXPIRED':
        return 'That OTP has expired. We sent you a new one.';
      case 'MAX_ATTEMPTS_EXCEEDED':
        return 'Too many incorrect attempts. We sent you a new OTP.';
      case 'VALIDATION_ERROR':
      case 'INVALID_USER':
        return 'Something is wrong with this request. Please go back and try again.';
      case 'INTERNAL_ERROR':
        return 'Server error. Please try again in a moment.';
    }
    return switch (e.statusCode ?? 0) {
      401 => remaining == null
          ? 'Incorrect OTP. Please try again.'
          : 'Incorrect OTP. $remaining attempt(s) remaining.',
      404 => 'No active OTP found. We sent you a new one.',
      409 => 'That OTP was already used. We sent you a new one.',
      410 => 'That OTP has expired. We sent you a new one.',
      429 => 'Too many incorrect attempts. We sent you a new OTP.',
      >= 500 => 'Server error. Please try again in a moment.',
      _ => fallback ?? 'Invalid OTP. Please try again.',
    };
  }

  bool canResend(OtpChannel channel) {
    final state = stateFor(channel);
    if (state.resendCount >= _maxResends) return false;
    final lastResendAt = state.lastResendAt;
    if (lastResendAt == null) return true;
    return DateTime.now().difference(lastResendAt) >= _resendCooldown;
  }

  int remainingCooldownSeconds(OtpChannel channel) {
    final lastResendAt = stateFor(channel).lastResendAt;
    if (lastResendAt == null) return 0;
    final remaining =
        _resendCooldown.inSeconds - DateTime.now().difference(lastResendAt).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  Future<bool> resendOtp(OtpChannel channel, {bool force = false}) async {
    if (!force && !canResend(channel)) {
      _update(
        channel,
        (s) => s.copyWith(
          resendError:
              'Please wait ${remainingCooldownSeconds(channel)} second(s) before requesting another resend.',
        ),
      );
      return false;
    }

    _update(
      channel,
      (s) => s.copyWith(isResending: true, clearResendError: true),
    );

    // The backend has no resend endpoint: repeating registration-check for
    // the same identifier re-issues the OTPs and returns a fresh token.
    final identifier = _resendIdentifier;
    String? failure;
    var succeeded = false;
    if (identifier == null) {
      failure = 'Could not resend the OTP. Please go back and try again.';
    } else {
      final response = await _authService.checkUserExists(
        CheckUserExistsRequest(identifier: identifier),
      );
      final data = response.data;
      final token = data?.registrationToken;
      final resumable = data != null &&
          const {
            RegistrationCheckOutcome.mobileNotVerified,
            RegistrationCheckOutcome.emailNotVerified,
            RegistrationCheckOutcome.mobileEmailNotVerified,
          }.contains(data.resolvedOutcome);
      if (response.isSuccess && resumable && token != null && token.isNotEmpty) {
        _userId = token;
        succeeded = true;
      } else {
        failure = response.message ?? 'Failed to resend OTP. Please try again.';
      }
    }

    _update(
      channel,
      (s) => s.copyWith(
        isResending: false,
        resendError: succeeded ? null : failure,
        clearResendError: succeeded,
        lastResendAt: succeeded ? DateTime.now() : s.lastResendAt,
        resendCount: succeeded ? s.resendCount + 1 : s.resendCount,
      ),
    );
    return succeeded;
  }
}
