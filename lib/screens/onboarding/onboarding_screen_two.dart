import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/widgets/shared/common/fade_slide_in.dart';
import 'package:flutter_nivasshub/constants/onboarding/onboarding_colors.dart';
import 'package:flutter_nivasshub/widgets/onboarding/onboarding_action_buttons.dart';
import 'package:flutter_nivasshub/widgets/onboarding/onboarding_illustration_painter.dart';
import 'package:flutter_nivasshub/widgets/onboarding/onboarding_logo_card.dart';

/// Onboarding Screen 2 — reached from Onboarding 1's "Get Started" action.
/// Offers the Create Account / Login choice before handing off to the real
/// auth screens.
class OnboardingScreenTwo extends StatefulWidget {
  const OnboardingScreenTwo({super.key});

  @override
  State<OnboardingScreenTwo> createState() => _OnboardingScreenTwoState();
}

class _OnboardingScreenTwoState extends State<OnboardingScreenTwo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
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
        : (context.isTablet
              ? AppDimensions.maxContentWidth * 0.6
              : double.infinity);
    final background = isDark
        ? OnboardingColors.backgroundDarkMode
        : OnboardingColors.background;
    final heading = isDark
        ? OnboardingColors.headingDarkMode
        : OnboardingColors.heading;
    final bodyText = isDark
        ? OnboardingColors.bodyTextDarkMode
        : OnboardingColors.bodyText;

    return Scaffold(
      backgroundColor: background,
      body: AnimatedBuilder(
        animation: _entrance,
        builder: (context, _) {
          final t = _entrance.value;
          final logoT = const Interval(
            0.00,
            0.45,
            curve: Curves.easeOutCubic,
          ).transform(t);
          final headingT = const Interval(
            0.25,
            0.65,
            curve: Curves.easeOutCubic,
          ).transform(t);
          final descriptionT = const Interval(
            0.32,
            0.70,
            curve: Curves.easeOutCubic,
          ).transform(t);
          final illustrationT = const Interval(
            0.30,
            0.70,
            curve: Curves.easeOutCubic,
          ).transform(t);
          final createAccountT = const Interval(
            0.55,
            0.90,
            curve: Curves.easeOutCubic,
          ).transform(t);
          final loginT = const Interval(
            0.68,
            1.00,
            curve: Curves.easeOutCubic,
          ).transform(t);
          final illustrationOpacity = illustrationT.clamp(0.0, 1.0);

          return Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        isDark ? AppColors.backgroundDark : Colors.white,
                        background,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: screenHeight * 0.42,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: illustrationOpacity,
                    child: Transform.translate(
                      offset: Offset(0, (1 - illustrationOpacity) * 20),
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: OnboardingIllustrationPainter(
                          progress: illustrationOpacity,
                        ),
                      ),
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
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: screenHeight - AppSpacing.xxxl,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 48),
                              OnboardingLogoCard(entrance: logoT),
                              SizedBox(height: AppSpacing.xl),
                              FadeSlideIn(
                                progress: headingT,
                                child: Text(
                                  'One Community,\nOne Platform',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: heading,
                                    height: 1.25,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              FadeSlideIn(
                                progress: descriptionT,
                                distance: 0,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 340,
                                  ),
                                  child: Text(
                                    'NivaasHub connects residents, manages visitors, '
                                    'handles payments, and keeps your society running '
                                    'smoothly — all in one place.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: bodyText,
                                      height: 1.625,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: AppSpacing.xxl),
                              FadeSlideIn(
                                progress: createAccountT,
                                child: CreateAccountButton(
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.register,
                                  ),
                                ),
                              ),
                              SizedBox(height: AppSpacing.md),
                              FadeSlideIn(
                                progress: loginT,
                                child: OnboardingLoginButton(
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.login,
                                  ),
                                ),
                              ),
                              SizedBox(height: AppSpacing.xl),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
