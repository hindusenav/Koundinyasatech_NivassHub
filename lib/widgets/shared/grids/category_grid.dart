import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_spacing.dart';

/// A generic, non-scrolling grid — extracted from the Quick Actions screen so
/// any future module can render a fixed-column grid of cards/tiles without
/// re-writing the `GridView.builder` boilerplate. Intended to live inside an
/// already-scrollable parent (hence `shrinkWrap: true` +
/// `NeverScrollableScrollPhysics`).
class CategoryGrid<T> extends StatelessWidget {
  const CategoryGrid({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.columns = 4,
    this.spacing = AppSpacing.md,
    this.childAspectRatio = 0.82,
    this.mainAxisExtent,
  });

  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final int columns;
  final double spacing;
  final double childAspectRatio;

  /// Fixed cell height, overriding [childAspectRatio] when set. Use this
  /// instead of the aspect ratio for tiles with a fixed-px content height
  /// (padding + icon + multi-line label) that shouldn't shrink just because
  /// the column got narrower on a smaller screen. `null` (default)
  /// preserves the existing aspect-ratio-based sizing for every other
  /// caller of this shared grid.
  final double? mainAxisExtent;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
        mainAxisExtent: mainAxisExtent,
      ),
      itemBuilder: (context, index) => itemBuilder(items[index]),
    );
  }
}
