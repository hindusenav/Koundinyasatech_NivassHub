import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/models/shared/app_feature_icons.dart';
import 'package:flutter_nivasshub/models/shared/app_feature_model.dart';

/// The flat, icon-only grid tile — a circular grey icon badge above a
/// centered 2-line label, no card border, per Figma's flat tile look for
/// Visitors & Security, Community, Feed, Household, and Settings.
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
              width: AppDimensions.avatarMd,
              height: AppDimensions.avatarMd,
              decoration: const BoxDecoration(color: AppColors.grey100, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(
                AppFeatureIcons.icon(item.iconKey),
                size: AppDimensions.iconMd,
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
