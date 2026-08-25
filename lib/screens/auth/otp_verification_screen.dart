import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/providers/auth/auth_provider.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_back_button.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_gradient_button.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_registration_footer.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_shield_badge.dart';
import 'package:flutter_nivasshub/widgets/auth/otp_input_boxes.dart';
import 'package:flutter_nivasshub/screens/auth/otp_verification_success_screen.dart';

/// Typed arguments for [AppRoutes.otpVerification], unpacked in
/// `route_generator.dart`.
class OtpVerificationScreenArgs {
  const OtpVerificationScreenArgs({
    required this.mobileNumber,
    required this.otpExpirySeconds,
    required this.isRegistrationFlow,
  });

  final String mobileNumber;
  final int otpExpirySeconds;

  /// Whether this screen was reached via the Create-Account flow
  /// (`RegisterScreen`) rather than `LoginScreen` — shows the shield badge,
  /// registration-flavored copy, and the "Already have an account? Login"
  /// footer when true.
  final bool isRegistrationFlow;
}

/// 4-digit OTP entry, reached after the Login or Register screen
/// successfully sends an OTP. Verifies the code and branches to Create
/// Profile (new user) or the Home Dashboard (existing user, clearing the
/// nav stack).
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.mobileNumber,
    required this.otpExpirySeconds,
    required this.isRegistrationFlow,
  });

  final String mobileNumber;
  final int otpExpirySeconds;
  final bool isRegistrationFlow;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  Timer? _countdownTimer;
  late int _secondsRemaining;
  String _otpCode = '';

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _secondsRemaining = widget.otpExpirySeconds;
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

  /// e.g. "9876543210" -> "9*******10" — used only in the registration-flow
  /// copy, matching the masked-number treatment in that Figma frame.
  String get _maskedMobileNumber {
    final m = widget.mobileNumber;
    if (m.length <= 3) return m;
    return '${m[0]}${'*' * (m.length - 3)}${m.substring(m.length - 2)}';
  }

  Future<void> _handleVerify() async {
    context.hideKeyboard();
    final auth = context.read<AuthProvider>();
    final success = await auth.verifyOtp(_otpCode);
    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.otpVerificationSuccess,
        arguments: OtpVerificationSuccessScreenArgs(
          userExists: auth.userExists,
          registrationToken: auth.registrationToken,
          isRegistrationFlow: widget.isRegistrationFlow,
          mobileNumber: widget.mobileNumber,
          otpExpirySeconds: widget.otpExpirySeconds,
        ),
      );
    } else {
      CustomSnackbar.error(
        context,
        auth.errorMessage ?? 'Invalid OTP. Please try again.',
      );
    }
  }

  Future<void> _handleResend() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.resendOtp();
    if (!mounted) return;

    if (success) {
      setState(() => _secondsRemaining = auth.otpExpirySeconds);
      _startCountdown();
      CustomSnackbar.success(context, 'OTP resent successfully');
    } else {
      CustomSnackbar.error(
        context,
        auth.errorMessage ?? 'Failed to resend OTP. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = context.screenHeight;
    final auth = context.watch<AuthProvider>();
    final background = isDark
        ? AuthColors.backgroundDarkMode
        : AuthColors.background;
    final heading = isDark ? AuthColors.headingDarkMode : AuthColors.heading;
    final bodyText = isDark
        ? AuthColors.bodyTextDarkMode
        : AuthColors.bodyText;
    final primaryBlue = isDark
        ? AuthColors.primaryBlueDarkMode
        : AuthColors.primaryBlue;
    final lightBlue = isDark
        ? AuthColors.lightBlueDarkMode
        : AuthColors.lightBlue;

    return PopScope(
      canPop: !(auth.isVerifyingOtp || auth.isResendingOtp),
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
                    colors: [
                      background,
                      background,
                      lightBlue.withValues(alpha: 0.05),
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
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
                        final badgeT = const Interval(
                          0.00,
                          0.32,
                          curve: Curves.easeOutBack,
                        ).transform(t);
                        final titleT = const Interval(
                          0.00,
                          0.40,
                          curve: Curves.easeOut,
                        ).transform(t);
                        final subtitleT = const Interval(
                          0.10,
                          0.48,
                          curve: Curves.easeOut,
                        ).transform(t);
                        final otpT = const Interval(
                          0.22,
                          0.60,
                          curve: Curves.easeOutCubic,
                        ).transform(t);
                        final resendT = const Interval(
                          0.34,
                          0.68,
                          curve: Curves.easeOut,
                        ).transform(t);
                        final buttonT = const Interval(
                          0.46,
                          0.82,
                          curve: Curves.easeOutCubic,
                        ).transform(t);
                        final footerT = const Interval(
                          0.58,
                          0.94,
                          curve: Curves.easeOut,
                        ).transform(t);

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: screenHeight * 0.10),
                            if (widget.isRegistrationFlow) ...[
                              Opacity(
                                opacity: badgeT.clamp(0.0, 1.0),
                                child: Transform.scale(
                                  scale: 0.85 + badgeT.clamp(0.0, 1.0) * 0.15,
                                  child: const AuthShieldBadge(),
                                ),
                              ),
                              SizedBox(height: AppSpacing.lg),
                            ],
                            Opacity(
                              opacity: titleT.clamp(0.0, 1.0),
                              child: Text(
                                widget.isRegistrationFlow
                                    ? 'Verify Your Mobile Number'
                                    : 'Verify OTP',
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
                              child: widget.isRegistrationFlow
                                  ? Column(
                                      children: [
                                        Text(
                                          'Enter the 4 digit code sent to +91 $_maskedMobileNumber',
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.bodyLarge
                                              .copyWith(
                                                color: heading,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(height: AppSpacing.xs),
                                        Text(
                                          'We sent a 4-digit code via SMS. This helps keep your account secure.',
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                color: bodyText,
                                              ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Text(
                                          "We've sent an OTP to",
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.bodyLarge
                                              .copyWith(
                                                color: bodyText,
                                              ),
                                        ),
                                        Text(
                                          '+91 ${widget.mobileNumber}',
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.bodyLarge
                                              .copyWith(
                                                color: heading,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                            ),
                            SizedBox(height: AppSpacing.xxl),
                            Opacity(
                              opacity: otpT.clamp(0.0, 1.0),
                              child: OtpInputBoxes(
                                length: 4,
                                onChanged: (code) =>
                                    setState(() => _otpCode = code),
                                onCompleted: (code) =>
                                    setState(() => _otpCode = code),
                              ),
                            ),
                            SizedBox(height: AppSpacing.xl),
                            Opacity(
                              opacity: resendT.clamp(0.0, 1.0),
                              child: _secondsRemaining > 0
                                  ? (widget.isRegistrationFlow
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                AppIcons.clock,
                                                size: AppDimensions.iconXs,
                                                color: bodyText,
                                              ),
                                              AppSpacing.gapWXs,
                                              Text(
                                                'Code expires in $_formattedCountdown',
                                                style: AppTextStyles.bodyMedium
                                                    .copyWith(
                                                      color: bodyText,
                                                    ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            'Resend OTP in $_formattedCountdown',
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(
                                                  color: bodyText,
                                                ),
                                          ))
                                  : GestureDetector(
                                      onTap: auth.isResendingOtp
                                          ? null
                                          : _handleResend,
                                      child: widget.isRegistrationFlow
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  AppIcons.refresh,
                                                  size: AppDimensions.iconXs,
                                                  color: primaryBlue,
                                                ),
                                                AppSpacing.gapWXs,
                                                Text(
                                                  auth.isResendingOtp
                                                      ? 'Resending...'
                                                      : 'Resend Code',
                                                  style: AppTextStyles
                                                      .bodyMedium
                                                      .copyWith(
                                                        color: primaryBlue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            )
                                          : Text(
                                              auth.isResendingOtp
                                                  ? 'Resending...'
                                                  : 'Resend OTP',
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
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
                                isLoading: auth.isVerifyingOtp,
                                onPressed: _otpCode.length == 4
                                    ? _handleVerify
                                    : null,
                              ),
                            ),
                            if (widget.isRegistrationFlow) ...[
                              SizedBox(height: AppSpacing.xl),
                              Opacity(
                                opacity: footerT.clamp(0.0, 1.0),
                                child: const AuthRegistrationFooter(),
                              ),
                            ],
                            SizedBox(height: screenHeight * 0.06),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: AppSpacing.all(AppSpacing.sm),
                child: AuthBackButton(
                  onTap: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
