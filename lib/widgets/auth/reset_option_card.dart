import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/widgets/shared/cards/custom_card.dart';

/// One tappable "how would you like to reset your password" option on the
/// Forgot Password "Choose Option" screen — a leading tinted icon tile,
/// title + subtitle, and a trailing chevron. Built on the shared
/// [CustomCard] so it gets the same tap ripple/border treatment as every
/// other card in the app.
class ResetOptionCard extends StatelessWidget {
  const ResetOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final heading = isDark ? AuthColors.headingDarkMode : AuthColors.heading;
    final bodyText = isDark ? AuthColors.bodyTextDarkMode : AuthColors.bodyText;
    final primaryBlue = isDark ? AuthColors.primaryBlueDarkMode : AuthColors.primaryBlue;
    final lightBlue = isDark ? AuthColors.lightBlueDarkMode : AuthColors.lightBlue;

    return CustomCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: lightBlue.withValues(alpha: 0.12),
              borderRadius: AppRadius.radiusMd,
            ),
            child: Icon(icon, size: AppDimensions.iconMd, color: primaryBlue),
          ),
          AppSpacing.gapWMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: heading,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.xxs),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(color: bodyText),
                ),
              ],
            ),
          ),
          Icon(AppIcons.chevronRight, size: AppDimensions.iconSm, color: bodyText),
        ],
      ),
    );
  }
}
