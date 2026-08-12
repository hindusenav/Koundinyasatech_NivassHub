import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

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
  });

  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final int columns;
  final double spacing;
  final double childAspectRatio;

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
      ),
      itemBuilder: (context, index) => itemBuilder(items[index]),
    );
  }
}
