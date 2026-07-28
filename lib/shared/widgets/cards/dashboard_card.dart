import 'package:flutter/material.dart';
import '../../../core/utils/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'custom_card.dart';

/// A stat-tile card for dashboard summaries — an icon badge, a large value,
/// and a label underneath. Used for counts like "12 Open Complaints" or
/// "48 Residents".
class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = color ?? AppColors.primary;

    return CustomCard(
      elevated: true,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: AppSpacing.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: AppRadius.radiusSm,
            ),
            child: Icon(icon, color: accentColor, size: AppDimensions.iconMd),
          ),
          AppSpacing.gapWMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.headlineSmall
                      .copyWith(color: context.colorScheme.onSurface),
                ),
                AppSpacing.gapXs,
                Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
