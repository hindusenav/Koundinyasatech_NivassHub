import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_shadows.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/custom_button.dart';
import 'package:flutter_nivasshub/models/notifications/visitor_notification_model.dart';

/// The compact gate-arrival approval card shown as a floating popup below
/// the Home dashboard's header (see `DashboardBody`/`VisitorNotificationSection`
/// for how it's anchored there). Purely presentational — no
/// `Provider`/business logic here, only data + callbacks — so it can be
/// previewed/tested in isolation and `VisitorNotificationSection` stays the
/// single place that owns state.
class VisitorNotificationBanner extends StatelessWidget {
  const VisitorNotificationBanner({
    super.key,
    required this.notification,
    required this.isApproving,
    required this.isRejecting,
    required this.onApprove,
    required this.onReject,
    required this.onClose,
    required this.onTap,
  });

  final VisitorNotificationModel notification;
  final bool isApproving;
  final bool isRejecting;

  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onClose;

  /// Tapping the card body (anywhere except the Approve/Reject buttons or
  /// the close icon, which intercept their own taps first) opens the
  /// "Delivery Details" bottom sheet — see
  /// `VisitorNotificationSection._handleTap`.
  final VoidCallback onTap;

  bool get _isBusy => isApproving || isRejecting;

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        boxShadow: isDark ? AppShadows.darkSm : AppShadows.sm,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.radiusLg,
          child: Padding(
            padding: AppSpacing.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _NotificationAvatar(company: notification.company),
                    AppSpacing.gapWSm,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: AppTextStyles.titleSmall.copyWith(
                                    color: context.colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              AppSpacing.gapWXs,
                              Text(
                                notification.time,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: isDark ? AppColors.grey300 : AppColors.grey500,
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.gapXs,
                          Text(
                            notification.subtitle,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark ? AppColors.grey300 : AppColors.grey500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.gapWXs,
                    InkWell(
                      onTap: onClose,
                      borderRadius: AppRadius.radiusFull,
                      child: CircleAvatar(
                        radius: AppDimensions.iconSm,
                        backgroundColor: isDark ? AppColors.grey800 : AppColors.grey100,
                        child: Icon(
                          AppIcons.close,
                          size: AppDimensions.iconXs,
                          color: isDark ? AppColors.grey300 : AppColors.grey600,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapMd,
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: 'Approve',
                        icon: AppIcons.check,
                        size: CustomButtonSize.small,
                        isLoading: isApproving,
                        backgroundColor: AppColors.success,
                        foregroundColor: AppColors.white,
                        onPressed: _isBusy ? null : onApprove,
                      ),
                    ),
                    AppSpacing.gapWSm,
                    Expanded(
                      child: CustomButton(
                        label: 'Reject Entry',
                        size: CustomButtonSize.small,
                        isLoading: isRejecting,
                        backgroundColor: AppColors.error,
                        foregroundColor: AppColors.white,
                        onPressed: _isBusy ? null : onReject,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The company-logo avatar with a small "visitor" badge overlapping its
/// bottom-right corner. No real logo/avatar image assets exist in this
/// project yet (see `VisitorNotificationModel`'s doc comment), so this
/// renders colored initials — the same fallback `ActivityCard` uses for
/// delivery-company avatars elsewhere in the app — rather than loading
/// `notification.logo`/`avatar` as an `Image.asset`.
class _NotificationAvatar extends StatelessWidget {
  const _NotificationAvatar({required this.company});

  final String company;

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
    final color = _brandColors[company] ?? AppColors.grey400;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: AppDimensions.avatarSm / 2,
          backgroundColor: color,
          child: Text(
            company.isNotEmpty ? company[0].toUpperCase() : '?',
            style: AppTextStyles.titleSmall.copyWith(color: AppColors.white),
          ),
        ),
        Positioned(
          bottom: -2,
          right: -2,
          child: Container(
            padding: const EdgeInsets.all(1.5),
            decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 8,
              backgroundColor: AppColors.grey200,
              child: Icon(AppIcons.profile, size: 10, color: AppColors.grey600),
            ),
          ),
        ),
      ],
    );
  }
}
