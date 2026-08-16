import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/models/shared/app_feature_icons.dart';
import 'package:flutter_nivasshub/models/shared/app_feature_model.dart';
import 'package:flutter_nivasshub/widgets/shared/cards/custom_card.dart';

/// The bordered card-style tile — icon above a centered label, inside a
/// white `CustomCard` with a subtle border. Used for both the top shortcuts
/// row ("Manage Devices", "Nivaas Hub Locks") and the Marketplace section
/// ("Find Homes", "My Listings", "Create a listing"), which are visually
/// near-identical in Figma — consolidated into one reusable widget instead
/// of two near-duplicates.
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
    return CustomCard(
      onTap: onTap,
      padding: AppSpacing.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.md),
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
    );
  }
}
