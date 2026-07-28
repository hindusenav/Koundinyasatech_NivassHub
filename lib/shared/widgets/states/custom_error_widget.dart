import 'package:flutter/material.dart';
import '../../../core/constants/string_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../buttons/secondary_button.dart';

/// Shown in place of a list/section when loading it failed. Named
/// `CustomErrorWidget` (not `ErrorWidget`) — Flutter's framework already
/// defines a top-level `ErrorWidget` for uncaught build errors.
class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    this.message = StringConstants.somethingWentWrong,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.error, size: AppDimensions.iconXl, color: AppColors.error),
            AppSpacing.gapMd,
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              AppSpacing.gapLg,
              SecondaryButton(
                label: StringConstants.retry,
                onPressed: onRetry,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
