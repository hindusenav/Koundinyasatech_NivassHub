import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';

/// Shared bottom block for the registration flow's auth screens
/// (`RegisterScreen`, and `OtpVerificationScreen` when `isRegistrationFlow`
/// is true): an "OR" divider, an "Already have an account? Login" link back
/// to `LoginScreen`, and a non-interactive Privacy Policy assurance line.
class AuthRegistrationFooter extends StatelessWidget {
  const AuthRegistrationFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AuthColors.borderDarkMode : AuthColors.border;
    final bodyText = isDark
        ? AuthColors.bodyTextDarkMode
        : AuthColors.bodyText;
    final primaryBlue = isDark
        ? AuthColors.primaryBlueDarkMode
        : AuthColors.primaryBlue;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: border)),
            Padding(
              padding: AppSpacing.horizontal(AppSpacing.sm),
              child: Text(
                'OR',
                style: AppTextStyles.labelMedium.copyWith(color: bodyText),
              ),
            ),
            Expanded(child: Divider(color: border)),
          ],
        ),
        SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: AppTextStyles.bodyMedium.copyWith(color: bodyText),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.login),
              child: Text(
                'Login',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: primaryBlue,
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
            Icon(AppIcons.info, size: AppDimensions.iconXs, color: bodyText),
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
