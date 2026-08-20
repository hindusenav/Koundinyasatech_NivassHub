import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/string_constants.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/secondary_button.dart';

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
