import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/models/shared/app_feature_icons.dart';
import 'package:flutter_nivasshub/models/shared/app_feature_model.dart';

/// A single Search result / Popular Search list row — a tinted rounded-
/// square icon badge, the title, and a trailing chevron. Deliberately not
/// shared with the Quick Actions grid tile: this is a left-aligned list row,
/// that's a centered grid cell — genuinely different layouts.
class SearchResultTile extends StatelessWidget {
  const SearchResultTile({super.key, required this.item, required this.onTap});

  final AppFeatureModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: AppDimensions.avatarSm,
              height: AppDimensions.avatarSm,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: AppRadius.radiusSm,
              ),
              alignment: Alignment.center,
              child: Icon(
                AppFeatureIcons.icon(item.iconKey),
                size: AppDimensions.iconSm,
                color: AppColors.primary,
              ),
            ),
            AppSpacing.gapWMd,
            Expanded(
              child: Text(
                item.title,
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.grey800),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.grey400, size: AppDimensions.iconMd),
          ],
        ),
      ),
    );
  }
}
