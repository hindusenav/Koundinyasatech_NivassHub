import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';

/// A section header used to break up a screen (e.g. "Recent Visitors")
/// with an optional trailing action ("See all") — or, via [trailing], any
/// other trailing widget (e.g. a "Raise Alert" button) when a plain text
/// link isn't the right fit. [trailing] takes priority when both it and
/// [actionLabel] are supplied.
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
    this.trailing,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (trailing != null)
            trailing!
          else if (actionLabel != null)
            TextButton(
              onPressed: onActionTap,
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel!,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                  ),
                  Icon(Icons.chevron_right_rounded, size: AppDimensions.iconSm, color: AppColors.primary),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
