import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';

/// The pill-shaped, red-outlined "Raise Alert" action in the Visitors &
/// Security section header — structurally a section-level action button,
/// not a grid tile, so it isn't modeled as an `AppFeatureModel`.
class RaiseAlertButton extends StatelessWidget {
  const RaiseAlertButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(AppIcons.error, size: AppDimensions.iconSm, color: AppColors.error),
      label: Text(
        'Raise Alert',
        style: AppTextStyles.labelMedium.copyWith(color: AppColors.error),
      ),
      style: OutlinedButton.styleFrom(
        // Overrides the app theme's `OutlinedButtonThemeData.minimumSize`,
        // which is `Size(double.infinity, ...)` for full-width Column
        // buttons (Login, Create Account). Without this override, this
        // button — placed inline in `SectionTitle`'s `Row` — inherits that
        // infinite minimum width and Flutter throws "BoxConstraints forces
        // an infinite width" during layout, which blanks the entire
        // scrollable body around it.
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: const BorderSide(color: AppColors.error),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusFull),
        padding: AppSpacing.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      ),
    );
  }
}
