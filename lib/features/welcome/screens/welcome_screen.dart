import 'package:flutter/material.dart';
import '../../../app/app_routes.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions/context_extensions.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../widgets/welcome_background.dart';

/// Landing screen shown after the splash intro: brand mark, greeting, and a
/// single entry point into the auth flow. Registration and sign-in both live
/// on the Login/Create Account screen, not here.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = context.screenHeight;
    final bottomReserve = screenHeight * 0.14;
    final logoWidth = context.isDesktop || context.isTablet ? 320.0 : 250.0;
    final contentWidth = context.isDesktop
        ? AppDimensions.maxContentWidth * 0.4
        : (context.isTablet ? AppDimensions.maxContentWidth * 0.6 : double.infinity);

    return Scaffold(
      body: Stack(
        children: [
          const WelcomeBackground(),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppAssets.logo, width: logoWidth),
                          SizedBox(height: AppSpacing.xxl),
                          Text(
                            'Welcome!',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.titleLarge.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'To NivaasHub',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.titleLarge.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xxl),
                          PrimaryButton(
                            label: 'Get Started',
                            onPressed: () =>
                                Navigator.pushNamed(context, AppRoutes.onboardingStepTwo),
                          ),
                          SizedBox(height: bottomReserve),
                        ],
                      ),
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
