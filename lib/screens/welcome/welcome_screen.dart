import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/constants/asset_constants.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/onboarding/onboarding_colors.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/primary_button.dart';

/// Landing screen shown after the splash intro: brand mark, greeting, and a
/// single entry point into the auth flow. Registration and sign-in both live
/// on the Login/Create Account screen, not here.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const double _cardRadius = 24;

  @override
  Widget build(BuildContext context) {
    final contentWidth = context.isDesktop
        ? AppDimensions.maxContentWidth * 0.4
        : (context.isTablet ? AppDimensions.maxContentWidth * 0.6 : double.infinity);
    final wide = context.isDesktop || context.isTablet;

    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: OnboardingColors.background,
                  borderRadius: BorderRadius.circular(_cardRadius),
                  border: Border.all(
                    color: OnboardingColors.primaryBlue.withValues(alpha: 0.35),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_cardRadius),
                  child: LayoutBuilder(
                    builder: (context, box) {
                      final h = box.maxHeight;
                      final logoSize = (h * 0.26).clamp(96.0, wide ? 260.0 : 190.0);
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: Column(
                              children: [
                                SizedBox(height: h * 0.04),
                                Image.asset(AppAssets.logo, width: logoSize, height: logoSize),
                                SizedBox(height: h * 0.03),
                                _title(context, 'Welcome!'),
                                _title(context, 'To NivaasHub'),
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
                            ),
                          ),
                          Positioned(
                            left: AppSpacing.lg,
                            right: AppSpacing.lg,
                            bottom: AppSpacing.lg,
                            child: PrimaryButton(
                              label: 'Get Started',
                              onPressed: () =>
                                  Navigator.pushNamed(context, AppRoutes.onboardingStepTwo),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context, String text) => Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.titleLarge.copyWith(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w700,
        ),
      );
}
