import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';

/// Shown in place of a list/section when there is no data to display.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.title = 'No data found',
    this.message,
    this.icon = AppIcons.empty,
    this.action,
  });

  final String title;
  final String? message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark
        ? AppColors.textDisabledDark
        : AppColors.textDisabledLight;
    final titleColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final messageColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppDimensions.iconXl, color: iconColor),
            AppSpacing.gapMd,
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(color: titleColor),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              AppSpacing.gapSm,
              Text(
                message!,
                style: AppTextStyles.bodyMedium.copyWith(color: messageColor),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              AppSpacing.gapLg,
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
