import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/models/shared/app_feature_icons.dart';
import 'package:flutter_nivasshub/models/shared/app_feature_model.dart';

/// The bordered card-style tile — icon above a centered label, inside a
/// white card with a subtle border. Used for both the top shortcuts
/// row ("Manage Devices", "Nivaas Hub Locks") and the Marketplace section
/// ("Find Homes", "My Listings", "Create a listing"), which are visually
/// near-identical in Figma — consolidated into one reusable widget instead
/// of two near-duplicates.
///
/// Deliberately doesn't use the shared `CustomCard` here: that widget picks
/// its surface color from `Theme.of(context).brightness`, but
/// `QuickActionsScreen` hardcodes a light background/app bar regardless of
/// system theme. On a device with system dark mode on, that mismatch turned
/// this card near-black (`AppColors.surfaceDark`) while everything around it
/// stayed light. Pinning the surface/border to the light palette keeps this
/// card visually identical to the (already light-only) rest of the screen on
/// every device, in both debug and release builds.
class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    super.key,
    required this.item,
    required this.onTap,
    this.iconSize = AppDimensions.iconLg,
  });

  final AppFeatureModel item;
  final VoidCallback onTap;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radiusMd,
        child: Ink(
          padding: AppSpacing.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: AppRadius.radiusMd,
            border: Border.all(color: AppColors.borderLight, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(AppFeatureIcons.icon(item.iconKey), size: iconSize, color: AppColors.primary),
              AppSpacing.gapSm,
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.grey800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
