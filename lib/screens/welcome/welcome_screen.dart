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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Start decoding the illustration immediately so it's ready by first paint.
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final width = MediaQuery.sizeOf(context).width;
    precacheImage(
      ResizeImage(
        const AssetImage(AppAssets.welcomeBackground),
        width: (width * dpr).round(),
      ),
      context,
    );
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
        : (context.isTablet
              ? AppDimensions.maxContentWidth * 0.6
              : double.infinity);
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
                final wordmarkWidth = (box.maxWidth * 0.55).clamp(
                  120.0,
                  wide ? 300.0 : 220.0,
                );
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
                    _title('To Nivaas Hub'),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: RepaintBoundary(
                          child: _illustration(context, box.maxWidth),
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

  /// Neighbourhood illustration, blended into the page instead of sitting on
  /// it like a pasted rectangle: the top edge fades into the page colour and
  /// the image fades in once decoded. Decoded at screen width (the source is
  /// 4096px wide) so the transition from splash doesn't stall on a ~55MB decode.
  Widget _illustration(BuildContext context, double width) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.black],
        stops: [0.0, 0.28],
      ).createShader(rect),
      child: Image.asset(
        AppAssets.welcomeBackground,
        width: double.infinity,
        fit: BoxFit.fitWidth,
        alignment: Alignment.bottomCenter,
        cacheWidth: (width * dpr).round(),
        filterQuality: FilterQuality.medium,
        frameBuilder: (context, child, frame, wasSyncLoaded) {
          if (wasSyncLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
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
