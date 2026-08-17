import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';
import 'package:flutter_nivasshub/services/core/secure_storage_service.dart';
import 'package:flutter_nivasshub/constants/asset_constants.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_gradient_button.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_skyline_painter.dart';
import 'package:flutter_nivasshub/widgets/auth/success_check_icon.dart';
import 'package:flutter_nivasshub/screens/auth/create_profile_screen.dart';

/// Typed arguments for [AppRoutes.otpVerificationSuccess], unpacked in
/// `route_generator.dart`.
class OtpVerificationSuccessScreenArgs {
  const OtpVerificationSuccessScreenArgs({
    required this.userExists,
    this.registrationToken,
    required this.isRegistrationFlow,
  });

  final bool userExists;

  /// Present only when [userExists] is `false`.
  final String? registrationToken;

  /// Whether OTP verification was reached via the Create-Account flow
  /// rather than Login — used to send Back to the correct originating
  /// screen.
  final bool isRegistrationFlow;
}

/// Celebration screen shown immediately after a successful OTP verification.
/// Its "Continue" button does the userExists-based branching that used to
/// live directly in `OtpVerificationScreen` — reading [userExists]/
/// [registrationToken] from the route arguments, never hardcoded.
class OtpVerificationSuccessScreen extends StatefulWidget {
  const OtpVerificationSuccessScreen({
    super.key,
    required this.userExists,
    this.registrationToken,
    required this.isRegistrationFlow,
  });

  final bool userExists;
  final String? registrationToken;
  final bool isRegistrationFlow;

  @override
  State<OtpVerificationSuccessScreen> createState() => _OtpVerificationSuccessScreenState();
}

class _OtpVerificationSuccessScreenState extends State<OtpVerificationSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (widget.userExists) {
      // Existing-user login: the OTP-verify response carries no access
      // token (only registration does), so a locally-set session flag is
      // what lets Splash auto-navigate straight to Dashboard on relaunch.
      await context.read<SecureStorageService>().saveSession();
      if (!mounted) return;
      NavigationService.pushNamedAndRemoveUntil(AppRoutes.dashboard);
    } else {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.createProfile,
        arguments: CreateProfileScreenArgs(registrationToken: widget.registrationToken!),
      );
    }
  }

  /// Sends Back to the screen this OTP verification was started from —
  /// Login or Create Account — clearing the stack so no leftover
  /// OTP/mobile-entry screens remain reachable via further Back presses.
  void _handleBackPress() {
    NavigationService.pushNamedAndRemoveUntil(
      widget.isRegistrationFlow ? AppRoutes.register : AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = context.screenHeight;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _handleBackPress();
      },
      child: Scaffold(
      backgroundColor: AuthColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AuthColors.background,
                    AuthColors.background,
                    AuthColors.lightBlue.withValues(alpha: 0.05),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _entrance,
            builder: (context, _) {
              final illustrationT =
                  const Interval(0.20, 0.65, curve: Curves.easeOutCubic).transform(_entrance.value);
              final opacity = illustrationT.clamp(0.0, 1.0);
              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: screenHeight * 0.32,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.translate(
                      offset: Offset(0, (1 - opacity) * 20),
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: AuthSkylinePainter(progress: opacity),
                      ),
                    ),
                  ),
                ),
              );
            },
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
                      final logoT =
                          const Interval(0.00, 0.35, curve: Curves.easeOut).transform(t);
                      final iconT = const Interval(
                        0.10,
                        0.55,
                        curve: Curves.easeOutBack,
                      ).transform(t);
                      final titleT =
                          const Interval(0.35, 0.70, curve: Curves.easeOut).transform(t);
                      final subtitleT =
                          const Interval(0.42, 0.76, curve: Curves.easeOut).transform(t);
                      final buttonT = const Interval(
                        0.55,
                        0.90,
                        curve: Curves.easeOutCubic,
                      ).transform(t);
                      final footerT =
                          const Interval(0.68, 1.00, curve: Curves.easeOut).transform(t);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Opacity(
                            opacity: logoT.clamp(0.0, 1.0),
                            child: Image.asset(AppAssets.logo, width: 180),
                          ),
                          SizedBox(height: AppSpacing.xl),
                          SuccessCheckIcon(entrance: iconT),
                          SizedBox(height: AppSpacing.xl),
                          Opacity(
                            opacity: titleT.clamp(0.0, 1.0),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'OTP Successfully ',
                                    style: AppTextStyles.headlineSmall.copyWith(
                                      color: AuthColors.heading,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Verified!',
                                    style: AppTextStyles.headlineSmall.copyWith(
                                      color: AuthColors.primaryBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: AppSpacing.sm),
                          Opacity(
                            opacity: subtitleT.clamp(0.0, 1.0),
                            child: Text(
                              'Your mobile number has been verified successfully.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AuthColors.bodyText,
                              ),
                            ),
                          ),
                          SizedBox(height: AppSpacing.xxl),
                          Opacity(
                            opacity: buttonT.clamp(0.0, 1.0),
                            child: AuthGradientButton(
                              label: 'Continue',
                              onPressed: _handleContinue,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xl),
                          Opacity(
                            opacity: footerT.clamp(0.0, 1.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  AppIcons.checkCircle,
                                  size: AppDimensions.iconSm,
                                  color: AppColors.success,
                                ),
                                SizedBox(width: AppSpacing.xs),
                                Text(
                                  '100% Secure',
                                  style: AppTextStyles.caption,
                                ),
                              ],
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
