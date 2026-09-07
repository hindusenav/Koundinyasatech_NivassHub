import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/providers/auth/forgot_password_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/auth/update_password_screen.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_back_button.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_gradient_button.dart';
import 'package:flutter_nivasshub/widgets/auth/otp_input_boxes.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';

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

class _ForgotPasswordVerifyOtpScreenState extends State<ForgotPasswordVerifyOtpScreen>
    with SingleTickerProviderStateMixin {
  static const int _otpLength = 6;
  static const int _resendCooldownSeconds = 30;

  late final AnimationController _entrance;
  Timer? _countdownTimer;
  int _secondsRemaining = _resendCooldownSeconds;
  String _otpCode = '';

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _startCountdown();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _countdownTimer?.cancel();
    super.dispose();
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
  /// email's local part is masked, e.g. "hindu@example.com" ->
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = context.screenHeight;
    final forgotPassword = context.watch<ForgotPasswordProvider>();
    final background = isDark ? AuthColors.backgroundDarkMode : AuthColors.background;
    final heading = isDark ? AuthColors.headingDarkMode : AuthColors.heading;
    final bodyText = isDark ? AuthColors.bodyTextDarkMode : AuthColors.bodyText;
    final primaryBlue = isDark ? AuthColors.primaryBlueDarkMode : AuthColors.primaryBlue;
    final lightBlue = isDark ? AuthColors.lightBlueDarkMode : AuthColors.lightBlue;

    return PopScope(
      canPop: !(forgotPassword.isVerifyingOtp || forgotPassword.isResendingOtp),
      child: Scaffold(
        backgroundColor: background,
        body: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [background, background, lightBlue.withValues(alpha: 0.05)],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: AppSpacing.all(AppSpacing.sm),
                  child: AuthBackButton(onTap: () => Navigator.pop(context)),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: Padding(
                  padding: AppSpacing.horizontal(AppSpacing.lg),
                  child: SingleChildScrollView(
                    child: AnimatedBuilder(
                      animation: _entrance,
                      builder: (context, _) {
                        final t = _entrance.value;
                        final titleT = const Interval(0.00, 0.40, curve: Curves.easeOut).transform(t);
                        final subtitleT =
                            const Interval(0.10, 0.48, curve: Curves.easeOut).transform(t);
                        final otpT =
                            const Interval(0.22, 0.60, curve: Curves.easeOutCubic).transform(t);
                        final resendT = const Interval(0.34, 0.68, curve: Curves.easeOut).transform(t);
                        final buttonT =
                            const Interval(0.46, 0.82, curve: Curves.easeOutCubic).transform(t);
                        final footerT = const Interval(0.58, 0.94, curve: Curves.easeOut).transform(t);

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: screenHeight * 0.08),
                            Opacity(
                              opacity: titleT.clamp(0.0, 1.0),
                              child: Text(
                                widget.channel == ForgotPasswordChannel.mobile
                                    ? 'Verify Your Mobile Number'
                                    : 'Verify Your Email Address',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.headlineSmall.copyWith(
                                  color: heading,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: AppSpacing.sm),
                            Opacity(
                              opacity: subtitleT.clamp(0.0, 1.0),
                              child: Text(
                                widget.channel == ForgotPasswordChannel.mobile
                                    ? 'Enter the 6-digit OTP sent to your mobile number '
                                        '+91 $_maskedIdentifier'
                                    : 'Enter the 6-digit OTP sent to your email address '
                                        '$_maskedIdentifier',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyMedium.copyWith(color: bodyText),
                              ),
                            ),
                            SizedBox(height: AppSpacing.xxl),
                            Opacity(
                              opacity: otpT.clamp(0.0, 1.0),
                              child: OtpInputBoxes(
                                length: _otpLength,
                                onChanged: (code) => setState(() => _otpCode = code),
                                onCompleted: (code) => setState(() => _otpCode = code),
                              ),
                            ),
                            SizedBox(height: AppSpacing.xl),
                            Opacity(
                              opacity: resendT.clamp(0.0, 1.0),
                              child: _secondsRemaining > 0
                                  ? Text(
                                      "Didn't receive the OTP? Resend in $_formattedCountdown",
                                      style: AppTextStyles.bodyMedium.copyWith(color: bodyText),
                                    )
                                  : GestureDetector(
                                      onTap: forgotPassword.isResendingOtp ? null : _handleResend,
                                      child: Text(
                                        forgotPassword.isResendingOtp ? 'Resending...' : 'Resend OTP',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: primaryBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(height: AppSpacing.xxl),
                            Opacity(
                              opacity: buttonT.clamp(0.0, 1.0),
                              child: AuthGradientButton(
                                label: 'Verify OTP',
                                isLoading: forgotPassword.isVerifyingOtp,
                                onPressed: _otpCode.length == _otpLength ? _handleVerify : null,
                              ),
                            ),
                            SizedBox(height: AppSpacing.lg),
                            Opacity(
                              opacity: footerT.clamp(0.0, 1.0),
                              child: GestureDetector(
                                onTap: () =>
                                    Navigator.popUntil(context, (route) => route.isFirst || route.settings.name == AppRoutes.forgotPassword),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(AppIcons.back, size: AppDimensions.iconXs, color: primaryBlue),
                                    AppSpacing.gapWXs,
                                    Text(
                                      'Back to Options',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: primaryBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.06),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
