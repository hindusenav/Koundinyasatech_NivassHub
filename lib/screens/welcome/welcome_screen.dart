import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/onboarding/onboarding_screen_two.dart';
import 'package:flutter_nivasshub/constants/asset_constants.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/onboarding/onboarding_colors.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';

/// Landing screen shown after the splash intro: brand mark and greeting. It
/// advances on its own to the Create Account / Login screen after a short
/// pause — registration and sign-in both live there, not here.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  /// How long the greeting stays up before moving on.
  static const Duration displayDuration = Duration(seconds: 2);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(WelcomeScreen.displayDuration, _advance);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _advance() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        settings: const RouteSettings(name: AppRoutes.onboardingStepTwo),
        transitionDuration: const Duration(milliseconds: 550),
        pageBuilder: (_, _, _) => const OnboardingScreenTwo(),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contentWidth = context.isDesktop
        ? AppDimensions.maxContentWidth * 0.4
        : (context.isTablet ? AppDimensions.maxContentWidth * 0.6 : double.infinity);
    final wide = context.isDesktop || context.isTablet;

    return Scaffold(
      backgroundColor: OnboardingColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentWidth),
            child: LayoutBuilder(
              builder: (context, box) {
                final h = box.maxHeight;
                final markSize = (h * 0.13).clamp(48.0, wide ? 120.0 : 90.0);
                final wordmarkWidth =
                    (box.maxWidth * 0.55).clamp(120.0, wide ? 300.0 : 220.0);
                return Column(
                  children: [
                    SizedBox(height: h * 0.08),
                    SvgPicture.asset(
                      AppAssets.splashMark,
                      width: markSize,
                      height: markSize,
                    ),
                    SizedBox(height: h * 0.02),
                    SvgPicture.asset(
                      AppAssets.splashWordmark,
                      width: wordmarkWidth,
                    ),
                    SizedBox(height: h * 0.012),
                    Text(
                      'ONE COMMUNITY · ONE PLATFORM',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.5,
                        color: OnboardingColors.bodyText,
                      ),
                    ),
                    SizedBox(height: h * 0.07),
                    _title('Welcome!', large: true),
                    _title('To NivaasHub'),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          AppAssets.welcomeBackground,
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(String text, {bool large = false}) => Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.titleLarge.copyWith(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w700,
          fontSize: large ? 26 : null,
        ),
      );
}
