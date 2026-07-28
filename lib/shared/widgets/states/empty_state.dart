import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

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
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppDimensions.iconXl, color: AppColors.grey400),
            AppSpacing.gapMd,
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              AppSpacing.gapSm,
              Text(
                message!,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
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
