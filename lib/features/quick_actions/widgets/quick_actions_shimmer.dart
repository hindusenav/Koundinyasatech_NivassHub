import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/loaders/shimmer_loader.dart';

/// Loading placeholder for the Quick Actions screen — approximates the
/// search bar, the shortcuts row, and a couple of grid rows.
class QuickActionsShimmer extends StatelessWidget {
  const QuickActionsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(
      child: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(width: double.infinity, height: 48, borderRadius: AppRadius.radiusSm),
            AppSpacing.gapLg,
            Row(
              children: [
                const Expanded(
                  child: ShimmerBox(height: 88, borderRadius: AppRadius.radiusMd),
                ),
                AppSpacing.gapWMd,
                const Expanded(
                  child: ShimmerBox(height: 88, borderRadius: AppRadius.radiusMd),
                ),
              ],
            ),
            AppSpacing.gapLg,
            const ShimmerBox(width: 160, height: 18),
            AppSpacing.gapMd,
            _gridRow(),
            AppSpacing.gapMd,
            _gridRow(),
            AppSpacing.gapLg,
            const ShimmerBox(width: 160, height: 18),
            AppSpacing.gapMd,
            _gridRow(),
          ],
        ),
      ),
    );
  }

  Widget _gridRow() {
    return Row(
      children: List.generate(4, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == 3 ? 0 : AppSpacing.sm),
            child: const ShimmerBox(height: 72, borderRadius: AppRadius.radiusMd),
          ),
        );
      }),
    );
  }
}
