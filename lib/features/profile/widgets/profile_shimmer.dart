import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/loaders/shimmer_loader.dart';

/// Loading placeholder for the Profile screen — avatar + name, then 3
/// card-shaped blocks approximating Contact Details / Address / Active
/// Society.
class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(
      child: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            const ShimmerBox(
              width: AppDimensions.avatarXl,
              height: AppDimensions.avatarXl,
              borderRadius: AppRadius.radiusFull,
            ),
            AppSpacing.gapMd,
            const ShimmerBox(width: 140, height: 18),
            AppSpacing.gapXl,
            _cardBlock(),
            AppSpacing.gapLg,
            _cardBlock(),
            AppSpacing.gapLg,
            _cardBlock(),
          ],
        ),
      ),
    );
  }

  Widget _cardBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerBox(width: 120, height: 16),
        AppSpacing.gapSm,
        const ShimmerBox(width: double.infinity, height: 72, borderRadius: AppRadius.radiusMd),
      ],
    );
  }
}
