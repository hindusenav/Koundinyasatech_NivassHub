import 'package:flutter/material.dart';
import '../../../app/app_routes.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../auth_colors.dart';

/// Shared bottom block for the registration flow's auth screens
/// (`RegisterScreen`, and `OtpVerificationScreen` when `isRegistrationFlow`
/// is true): an "OR" divider, an "Already have an account? Login" link back
/// to `LoginScreen`, and a non-interactive Privacy Policy assurance line.
class AuthRegistrationFooter extends StatelessWidget {
  const AuthRegistrationFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: AuthColors.border)),
            Padding(
              padding: AppSpacing.horizontal(AppSpacing.sm),
              child: Text(
                'OR',
                style: AppTextStyles.labelMedium.copyWith(color: AuthColors.bodyText),
              ),
            ),
            const Expanded(child: Divider(color: AuthColors.border)),
          ],
        ),
        SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: AppTextStyles.bodyMedium.copyWith(color: AuthColors.bodyText),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.login),
              child: Text(
                'Login',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AuthColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AppIcons.info, size: AppDimensions.iconXs, color: AuthColors.bodyText),
            AppSpacing.gapWXs,
            Text(
              'By continuing, you agree to our Privacy Policy',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ],
    );
  }
}
