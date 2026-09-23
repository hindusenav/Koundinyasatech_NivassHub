import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/models/auth/otp_resend_request.dart';
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
    required String userId,
    required String mobileNumber,
    required String email,
  }) : _service = service,
       _userId = userId,
       _mobileNumber = mobileNumber,
       _email = email;

  final OtpVerificationServiceBase _service;
  final String _userId;
  final String _mobileNumber;
  final String _email;

  static const _resendCooldown = Duration(seconds: 30);
  static const _maxResends = 5;

  OtpChannelState _mobileState = const OtpChannelState();
  OtpChannelState _emailState = const OtpChannelState();

  OtpChannelState stateFor(OtpChannel channel) =>
      channel == OtpChannel.mobile ? _mobileState : _emailState;

  String identifierFor(OtpChannel channel) =>
      channel == OtpChannel.mobile ? _mobileNumber : _email;

  bool get isFullyVerified => _mobileState.isVerified && _emailState.isVerified;

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

    final verified = response.isSuccess && (response.data?.verified ?? false);
    _update(
      channel,
      (s) => s.copyWith(
        isVerifying: false,
        isVerified: verified,
        verifyError: verified ? null : (response.message ?? 'Invalid OTP. Please try again.'),
        clearVerifyError: verified,
      ),
    );
    return verified;
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

  Future<bool> resendOtp(OtpChannel channel) async {
    if (!canResend(channel)) {
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

    final response = await _service.resendOtp(
      OtpResendRequest(uid: _userId, identifier: identifierFor(channel)),
    );

    final succeeded = response.isSuccess;
    _update(
      channel,
      (s) => s.copyWith(
        isResending: false,
        resendError: succeeded ? null : (response.message ?? 'Failed to resend OTP. Please try again.'),
        clearResendError: succeeded,
        lastResendAt: succeeded ? DateTime.now() : s.lastResendAt,
        resendCount: succeeded ? s.resendCount + 1 : s.resendCount,
      ),
    );
    return succeeded;
  }
}
