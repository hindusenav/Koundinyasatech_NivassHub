import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/cards/custom_card.dart';
import '../../../shared/widgets/common/custom_divider.dart';
import '../../../shared/widgets/feedback/status_chip.dart';
import '../models/approval_activity_model.dart';

/// One row on the Activities screen: company/visitor avatar, status badge,
/// name + verification note, and the Call / Wrong Entry action bar. Built on
/// the shared [CustomCard] and [StatusChip] so it inherits the app's
/// standard card and pill styling rather than defining its own.
class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.activity,
    this.onCall,
    this.onWrongEntry,
  });

  final ApprovalActivityModel activity;
  final VoidCallback? onCall;
  final VoidCallback? onWrongEntry;

  StatusChipType get _statusType {
    switch (activity.status.toUpperCase()) {
      case 'INSIDE':
        return StatusChipType.approved;
      case 'DENIED':
        return StatusChipType.rejected;
      case 'LEFT':
      default:
        return StatusChipType.inactive;
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteColor = activity.isDenied ? AppColors.error : AppColors.success;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ActivityAvatar(label: activity.company ?? activity.name),
              AppSpacing.gapWMd,
              Expanded(
                child: Text(
                  activity.company ?? activity.name,
                  style: AppTextStyles.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AppSpacing.gapWSm,
              StatusChip(label: activity.status, type: _statusType),
            ],
          ),
          AppSpacing.gapSm,
          Row(
            children: [
              Expanded(
                child: Text(
                  activity.name,
                  style: AppTextStyles.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (activity.approvedBy != null) ...[
                Icon(AppIcons.checkCircle, size: AppDimensions.iconXs, color: AppColors.info),
                AppSpacing.gapWXs,
              ],
              Icon(AppIcons.clock, size: AppDimensions.iconXs, color: AppColors.grey400),
              AppSpacing.gapWXs,
              Text(
                activity.timestamp,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
              ),
            ],
          ),
          if (activity.approvalNoteText.isNotEmpty) ...[
            AppSpacing.gapXs,
            Row(
              children: [
                Icon(AppIcons.shield, size: AppDimensions.iconXs, color: noteColor),
                AppSpacing.gapWXs,
                Expanded(
                  child: Text(
                    activity.approvalNoteText,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: noteColor,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          AppSpacing.gapSm,
          const CustomDivider(),
          Row(
            children: [
              TextButton.icon(
                onPressed: onCall,
                icon: Icon(AppIcons.phone, size: AppDimensions.iconSm, color: AppColors.success),
                label: Text('Call', style: AppTextStyles.labelLarge.copyWith(color: AppColors.success)),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onWrongEntry,
                icon: Icon(
                  AppIcons.close,
                  size: AppDimensions.iconSm,
                  color: activity.isWrongEntry ? AppColors.error : AppColors.grey500,
                ),
                label: Text(
                  activity.isWrongEntry ? 'Marked Wrong' : 'Wrong Entry',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: activity.isWrongEntry ? AppColors.error : AppColors.grey500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Colored initials circle for the card's leading avatar. Delivery brands
/// get a deterministic color from [_brandColors]; anything else (a service
/// or ad-hoc visitor with no brand identity) falls back to a neutral grey.
class _ActivityAvatar extends StatelessWidget {
  const _ActivityAvatar({required this.label});

  final String label;

  static const Map<String, Color> _brandColors = {
    'Blinkit': AppColors.tertiary,
    'Zepto': AppColors.primaryDark,
    'Amazon': AppColors.warning,
    'Dunzo': AppColors.secondaryDark,
    'Swiggy': AppColors.error,
    'BigBasket': AppColors.success,
  };

  @override
  Widget build(BuildContext context) {
    final color = _brandColors[label] ?? AppColors.grey400;

    return CircleAvatar(
      radius: AppDimensions.avatarSm / 2,
      backgroundColor: color,
      child: Text(
        label.isNotEmpty ? label[0].toUpperCase() : '?',
        style: AppTextStyles.titleSmall.copyWith(color: AppColors.white),
      ),
    );
  }
}
