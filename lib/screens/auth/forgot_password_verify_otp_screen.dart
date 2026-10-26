import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/utils/responsive.dart';
import 'package:flutter_nivasshub/providers/auth/forgot_password_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/auth/update_password_screen.dart';
import 'package:flutter_nivasshub/services/auth/sms_otp_listener.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/widgets/auth/otp_input_boxes.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_scaffold.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_widgets.dart';

/// Typed arguments for [AppRoutes.forgotPasswordVerifyOtp], unpacked in
/// `auth_router.dart`.
class ForgotPasswordVerifyOtpScreenArgs {
  const ForgotPasswordVerifyOtpScreenArgs({
    required this.identifier,
    required this.channel,
  });

  /// The mobile number or email that received the OTP — used only for the
  /// on-screen "OTP sent to ..." copy. The actual verify call reads its own
  /// live copy off [ForgotPasswordProvider], which may have rotated
  /// (resend) since this screen was pushed.
  final String identifier;
  final ForgotPasswordChannel channel;
}

/// Screens 3 & 5 combined into one screen parameterized by [channel] —
/// mirrors how `OtpVerificationScreen` already handles two flavors via a
/// single boolean flag rather than two near-duplicate files.
class ForgotPasswordVerifyOtpScreen extends StatefulWidget {
  const ForgotPasswordVerifyOtpScreen({
    super.key,
    required this.identifier,
    required this.channel,
  });

  final String identifier;
  final ForgotPasswordChannel channel;

  @override
  State<ForgotPasswordVerifyOtpScreen> createState() => _ForgotPasswordVerifyOtpScreenState();
}

class _ForgotPasswordVerifyOtpScreenState extends State<ForgotPasswordVerifyOtpScreen> {
  static const int _otpLength = 6;
  static const int _resendCooldownSeconds = 30;

  Timer? _countdownTimer;
  int _secondsRemaining = _resendCooldownSeconds;
  String _otpCode = '';

  // SMS auto-fill for the mobile channel only; email OTP stays manual.
  final TextEditingController _otpController = TextEditingController();
  late final SmsOtpListener _smsListener = SmsOtpListener(
    length: _otpLength,
    onCode: _onSmsCode,
  );

  @override
  void initState() {
    super.initState();
    if (widget.channel == ForgotPasswordChannel.mobile) _smsListener.start();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _smsListener.stop();
    _otpController.dispose();
    super.dispose();
  }

  void _onSmsCode(String code) {
    if (!mounted) return;
    _otpController.text = code;
    setState(() => _otpCode = code);
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() => _secondsRemaining = _resendCooldownSeconds);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _secondsRemaining--);
    });
  }

  String get _formattedCountdown {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Matches the Figma reference: the mobile number is shown in full (as on
  /// the Login/registration OTP screens elsewhere in this app), while the
  /// email's local part is masked, e.g. "Saran@example.com" ->
  /// "hi****@example.com".
  String get _maskedIdentifier {
    if (widget.channel == ForgotPasswordChannel.email) {
      final parts = widget.identifier.split('@');
      if (parts.length != 2 || parts[0].length <= 2) return widget.identifier;
      return '${parts[0].substring(0, 2)}${'*' * (parts[0].length - 2)}@${parts[1]}';
    }
    return widget.identifier;
  }

  Future<void> _handleVerify() async {
    context.hideKeyboard();
    final forgotPassword = context.read<ForgotPasswordProvider>();
    final success = await forgotPassword.verifyOtp(_otpCode);
    if (!mounted) return;

    if (success) {
      final fpToken = forgotPassword.fpToken;
      if (fpToken == null || fpToken.isEmpty) {
        CustomSnackbar.error(
          context,
          'Verification succeeded but no reset token was returned. Please try again.',
        );
        return;
      }
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.updatePassword,
        arguments: UpdatePasswordScreenArgs(fpToken: fpToken),
      );
    } else {
      CustomSnackbar.error(context, forgotPassword.errorMessage ?? 'Invalid OTP. Please try again.');
    }
  }

  Future<void> _handleResend() async {
    final forgotPassword = context.read<ForgotPasswordProvider>();
    final success = await forgotPassword.resendOtp();
    if (!mounted) return;

    if (success) {
      _startCountdown();
      if (widget.channel == ForgotPasswordChannel.mobile) _smsListener.restart();
      CustomSnackbar.success(context, 'OTP resent successfully');
    } else {
      CustomSnackbar.error(
        context,
        forgotPassword.errorMessage ?? 'Failed to resend OTP. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final forgotPassword = context.watch<ForgotPasswordProvider>();
    final mobilePrefix = widget.channel == ForgotPasswordChannel.mobile
        ? '${forgotPassword.countryCode ?? ''} '
        : '';
    final isMobile = widget.channel == ForgotPasswordChannel.mobile;

    return PopScope(
      canPop: !(forgotPassword.isVerifyingOtp || forgotPassword.isResendingOtp),
      child: FigmaHeaderScaffold(
        title: 'Verify OTP',
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: context.pageInsets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isMobile
                      ? 'Verify Your Mobile Number'
                      : 'Verify Your Email Address',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                context.gapSm,
                Text(
                  isMobile
                      ? 'Enter the 6-digit OTP sent to your mobile number\n'
                          '$mobilePrefix$_maskedIdentifier'
                      : 'Enter the 6-digit OTP sent to your email address\n'
                          '$_maskedIdentifier',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: AppColors.textMuted,
                  ),
                ),
                SizedBox(height: context.rs(28)),
                FigmaCard(
                  child: Center(
                    child: OtpInputBoxes(
                      length: _otpLength,
                      controller: _otpController,
                      onChanged: (code) => setState(() => _otpCode = code),
                      onCompleted: (code) => setState(() => _otpCode = code),
                    ),
                  ),
                ),
                context.gapMd,
                Center(
                  child: _secondsRemaining > 0
                      ? Text(
                          "Didn't receive the OTP? Resend in $_formattedCountdown",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        )
                      : TextButton(
                          onPressed:
                              forgotPassword.isResendingOtp ? null : _handleResend,
                          child: Text(
                            forgotPassword.isResendingOtp
                                ? 'Resending...'
                                : 'Resend OTP',
                            style: const TextStyle(
                              color: AppColors.primaryOrange,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                ),
                SizedBox(height: context.rs(20)),
                FigmaButton(
                  label: 'Verify OTP',
                  showArrow: true,
                  isLoading: forgotPassword.isVerifyingOtp,
                  onPressed: _otpCode.length == _otpLength ? _handleVerify : null,
                ),
                SizedBox(height: context.rs(12)),
                TextButton(
                  onPressed: () => Navigator.popUntil(
                    context,
                    (route) =>
                        route.isFirst ||
                        route.settings.name == AppRoutes.forgotPassword,
                  ),
                  child: const Text(
                    'Back to Options',
                    style: TextStyle(
                      color: AppColors.primaryOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
