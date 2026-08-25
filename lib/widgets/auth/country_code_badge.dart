import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';

/// Fixed "+91" country-code chip shown to the left of every mobile-number
/// field in the auth flow (Login, Register). The chevron is decorative
/// only — no country picker is wired up (India-only for now, matching
/// `FormValidators.mobileNumber`/`SendOtpRequest`'s hardcoded default).
class CountryCodeBadge extends StatelessWidget {
  const CountryCodeBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: AppDimensions.inputHeight,
      padding: AppSpacing.horizontal(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.radiusSm,
        border: Border.all(
          color: isDark ? AuthColors.borderDarkMode : AuthColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '+91',
            style: AppTextStyles.bodyLarge.copyWith(
              color: isDark ? AuthColors.headingDarkMode : AuthColors.heading,
            ),
          ),
          Icon(
            AppIcons.chevronDown,
            size: AppDimensions.iconXs,
            color: isDark ? AuthColors.bodyTextDarkMode : AuthColors.bodyText,
          ),
        ],
      ),
    );
  }
}
