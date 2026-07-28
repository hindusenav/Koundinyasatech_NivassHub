import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decoration.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

enum StatusChipType { active, inactive, pending, approved, rejected, expired, custom }

/// A pill-shaped status label (e.g. visitor "Checked In", complaint
/// "Pending", notice "Expired") — color follows [type] by default, or pass
/// [color] directly for a one-off.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.type = StatusChipType.custom,
    this.color,
  });

  final String label;
  final StatusChipType type;
  final Color? color;

  Color get _resolvedColor {
    if (color != null) return color!;
    switch (type) {
      case StatusChipType.active:
        return AppColors.statusActive;
      case StatusChipType.inactive:
        return AppColors.statusInactive;
      case StatusChipType.pending:
        return AppColors.statusPending;
      case StatusChipType.approved:
        return AppColors.statusApproved;
      case StatusChipType.rejected:
        return AppColors.statusRejected;
      case StatusChipType.expired:
        return AppColors.statusExpired;
      case StatusChipType.custom:
        return AppColors.grey500;
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolvedColor = _resolvedColor;
    return Container(
      padding: AppSpacing.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: AppDecoration.statusPill(resolvedColor),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: resolvedColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
