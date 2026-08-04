import 'package:flutter/material.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../auth_colors.dart';

/// Fixed "+91" country-code chip shown to the left of every mobile-number
/// field in the auth flow (Login, Register). The chevron is decorative
/// only — no country picker is wired up (India-only for now, matching
/// `FormValidators.mobileNumber`/`SendOtpRequest`'s hardcoded default).
class CountryCodeBadge extends StatelessWidget {
  const CountryCodeBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.inputHeight,
      padding: AppSpacing.horizontal(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.radiusSm,
        border: Border.all(color: AuthColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '+91',
            style: AppTextStyles.bodyLarge.copyWith(color: AuthColors.heading),
          ),
          Icon(AppIcons.chevronDown, size: AppDimensions.iconXs, color: AuthColors.bodyText),
        ],
      ),
    );
  }
}
