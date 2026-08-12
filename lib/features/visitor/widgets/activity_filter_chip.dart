import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions/context_extensions.dart';

/// A single selectable pill in the Activities screen's horizontally
/// scrollable filter bar ("All" / "Deliveries" / "Visitors" / "Wrong" /
/// "Pre-approved"). Custom-built rather than a stock `ChoiceChip` — the
/// Figma's filled-orange-when-selected look doesn't match `ChipThemeData`'s
/// neutral chip styling (used elsewhere for static labels, not this
/// single-select bar).
class ActivityFilterChip extends StatelessWidget {
  const ActivityFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.radiusFull,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: AppSpacing.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? AppColors.tertiary : surfaceColor,
          borderRadius: AppRadius.radiusFull,
          border: Border.all(color: selected ? AppColors.tertiary : borderColor),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: selected ? AppColors.white : context.colorScheme.onSurface,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
