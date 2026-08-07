import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// The centered, muted "TODAY — JUL 29" / "YESTERDAY — JUL 28" label that
/// separates date sections on the Activities screen.
class DateHeader extends StatelessWidget {
  const DateHeader({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.symmetric(vertical: AppSpacing.sm),
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.grey500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
