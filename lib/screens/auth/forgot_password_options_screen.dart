import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/providers/auth/forgot_password_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_skyline_painter.dart';
import 'package:flutter_nivasshub/widgets/auth/reset_option_card.dart';
import 'package:flutter_nivasshub/widgets/shared/brand/nivass_logo_mark.dart';
import 'package:flutter_nivasshub/widgets/shared/common/fade_slide_in.dart';

/// Entry point of the Forgot Password flow (`AppRoutes.forgotPassword`) —
/// lets the user pick whether to reset via mobile OTP or email OTP, or bail
/// back to Login. No arguments; resets any leftover `ForgotPasswordProvider`
/// state from a previously abandoned attempt on entry.
class ForgotPasswordOptionsScreen extends StatefulWidget {
  const ForgotPasswordOptionsScreen({super.key});

  @override
  State<ForgotPasswordOptionsScreen> createState() => _ForgotPasswordOptionsScreenState();
}

class _ForgotPasswordOptionsScreenState extends State<ForgotPasswordOptionsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    // Clears any stale otpKey/fpToken from a previously abandoned attempt
    // so a fresh entry into this flow always starts clean.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ForgotPasswordProvider>().reset();
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = context.screenHeight;
    final contentWidth = context.isDesktop
        ? AppDimensions.maxContentWidth * 0.4
        : (context.isTablet ? AppDimensions.maxContentWidth * 0.6 : double.infinity);
    final background = isDark ? AuthColors.backgroundDarkMode : AuthColors.background;
    final heading = isDark ? AuthColors.headingDarkMode : AuthColors.heading;
    final bodyText = isDark ? AuthColors.bodyTextDarkMode : AuthColors.bodyText;
    final primaryBlue = isDark ? AuthColors.primaryBlueDarkMode : AuthColors.primaryBlue;
    final lightBlue = isDark ? AuthColors.lightBlueDarkMode : AuthColors.lightBlue;

    return Scaffold(
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
                height: screenHeight * 0.24,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: opacity,
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: AuthSkylinePainter(progress: opacity),
                    ),
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: AppSpacing.all(AppSpacing.sm),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(AppIcons.back, color: heading),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Padding(
                  padding: AppSpacing.horizontal(AppSpacing.lg),
                  child: SingleChildScrollView(
                    child: AnimatedBuilder(
                      animation: _entrance,
                      builder: (context, _) {
                        final t = _entrance.value;
                        final logoT = const Interval(0.00, 0.35, curve: Curves.easeOutBack).transform(t);
                        final headingT = const Interval(0.10, 0.45, curve: Curves.easeOut).transform(t);
                        final subheadingT =
                            const Interval(0.16, 0.50, curve: Curves.easeOut).transform(t);
                        final optionsT =
                            const Interval(0.26, 0.72, curve: Curves.easeOutCubic).transform(t);
                        final footerT = const Interval(0.55, 0.90, curve: Curves.easeOut).transform(t);

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: AppSpacing.lg),
                            Opacity(
                              opacity: logoT.clamp(0.0, 1.0),
                              child: Transform.scale(
                                scale: 0.85 + logoT.clamp(0.0, 1.0) * 0.15,
                                child: const NivassLogoMark(size: 72),
                              ),
                            ),
                            SizedBox(height: AppSpacing.lg),
                            FadeSlideIn(
                              progress: headingT,
                              child: Text(
                                'Forgot Password?',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.headlineSmall.copyWith(
                                  color: heading,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: AppSpacing.xs),
                            FadeSlideIn(
                              progress: subheadingT,
                              child: Text(
                                'How would you like to reset your password?',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyLarge.copyWith(color: bodyText),
                              ),
                            ),
                            SizedBox(height: AppSpacing.xl),
                            FadeSlideIn(
                              progress: optionsT,
                              child: Column(
                                children: [
                                  ResetOptionCard(
                                    icon: AppIcons.phone,
                                    title: 'Via Mobile Number',
                                    subtitle: 'Receive OTP on your registered mobile number',
                                    onTap: () =>
                                        Navigator.pushNamed(context, AppRoutes.forgotPasswordMobile),
                                  ),
                                  SizedBox(height: AppSpacing.md),
                                  ResetOptionCard(
                                    icon: AppIcons.email,
                                    title: 'Via Email Address',
                                    subtitle: 'Receive OTP on your registered email address',
                                    onTap: () =>
                                        Navigator.pushNamed(context, AppRoutes.forgotPasswordEmail),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: AppSpacing.xl),
                            Opacity(
                              opacity: footerT.clamp(0.0, 1.0),
                              child: GestureDetector(
                                onTap: () => Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoutes.login,
                                  (route) => false,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(AppIcons.back, size: AppDimensions.iconXs, color: primaryBlue),
                                    AppSpacing.gapWXs,
                                    Text(
                                      'Back to Login',
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
          ),
        ],
      ),
    );
  }
}
