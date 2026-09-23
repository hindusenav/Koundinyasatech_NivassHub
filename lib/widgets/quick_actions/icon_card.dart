import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_shadows.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/models/shared/app_feature_icons.dart';
import 'package:flutter_nivasshub/models/shared/app_feature_model.dart';

/// The icon-only grid tile — a bordered white square (same surface/border
/// language as `QuickActionCard`) containing only the icon, with the label
/// as a separate, centered 2-line text element below it (no background or
/// border behind the text), per Figma's tile look for Visitors & Security,
/// Community, Feed, Household, and Settings.
class IconCard extends StatelessWidget {
  const IconCard({super.key, required this.item, required this.onTap});

  final AppFeatureModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.radiusMd,
      child: Padding(
        padding: AppSpacing.all(AppSpacing.xs),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppDimensions.avatarLg,
              height: AppDimensions.avatarLg,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: AppRadius.radiusMd,
                border: Border.all(color: AppColors.borderLight, width: 1),
                boxShadow: AppShadows.sm,
              ),
              child: AppFeatureIcons.iconWidget(
                item.iconKey,
                size: AppDimensions.iconLg,
                color: AppColors.grey700,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              item.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.grey800),
            ),
          ],
        ),
      ),
    );
  }
}
