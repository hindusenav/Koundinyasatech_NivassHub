import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';

/// Wraps [child] in a shimmer effect. Combine with [ShimmerBox] to mimic the
/// layout of the real content underneath, or use the ready-made
/// [ShimmerListPlaceholder] for a typical list loading state.
class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight,
      highlightColor:
          isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlightLight,
      child: child,
    );
  }
}

/// A single rectangular skeleton block — combine several inside a
/// [ShimmerLoader] to mimic the layout of the real content underneath.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: borderRadius ?? AppRadius.radiusSm,
      ),
    );
  }
}

/// Ready-made shimmering list — drop in while a real list (residents,
/// visitors, complaints, notices) is loading.
class ShimmerListPlaceholder extends StatelessWidget {
  const ShimmerListPlaceholder({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(
      child: ListView.separated(
        padding: AppSpacing.screenPadding,
        itemCount: itemCount,
        separatorBuilder: (_, _) => AppSpacing.gapMd,
        itemBuilder: (_, _) => Row(
          children: [
            const ShimmerBox(width: 48, height: 48, borderRadius: AppRadius.radiusFull),
            AppSpacing.gapWMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerBox(width: double.infinity, height: 14),
                  AppSpacing.gapXs,
                  const ShimmerBox(width: 120, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
