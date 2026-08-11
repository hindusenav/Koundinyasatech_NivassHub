import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions/context_extensions.dart';
import '../../../shared/widgets/buttons/custom_button.dart';
import '../../../shared/widgets/buttons/secondary_button.dart';
import '../../../shared/widgets/common/custom_divider.dart';
import '../../../shared/widgets/common/section_title.dart';
import '../../../shared/widgets/feedback/custom_snackbar.dart';
import '../../../shared/widgets/feedback/status_chip.dart';
import '../../../shared/widgets/loaders/loader.dart';
import '../../../shared/widgets/states/custom_error_widget.dart';
import '../../dashboard/data/models/banner_model.dart';
import '../../dashboard/presentation/provider/dashboard_provider.dart';
import '../models/visitor_details_model.dart';
import '../provider/visitor_details_provider.dart';
import '../provider/visitor_notification_provider.dart';
import '../repository/mock_visitor_details_service.dart';
import '../repository/visitor_details_repository.dart';

/// The "Delivery Details" bottom sheet opened by tapping the Home screen's
/// gate-arrival notification card anywhere except its own Approve/Reject
/// buttons — see `VisitorNotificationSection._handleTap`.
///
/// Reuses the SAME `VisitorNotificationProvider` instance the card itself
/// owns (passed in to [show] as `notificationProvider`) so Approve/Reject
/// tapped from here go through the exact existing `_respond()` flow — no
/// duplicate provider/model/logic. A fresh `VisitorDetailsProvider` is
/// created just for this sheet's own mock fetch and disposed automatically
/// when the sheet closes.
///
/// Deliberately bypasses `CustomBottomSheet` (which pads every side,
/// including the top) and calls `showModalBottomSheet` directly instead —
/// same pattern `ActivityTypeFilterSheet` uses — so the advertisement
/// banner can render full-bleed/flush at the very top, below the theme's
/// auto-drawn drag handle (`bottomSheetTheme.showDragHandle`, see
/// `app_theme.dart`).
class DeliveryDetailsSheet extends StatelessWidget {
  const DeliveryDetailsSheet({
    super.key,
    required this.onApprove,
    required this.onReject,
  });

  final Future<void> Function() onApprove;
  final Future<void> Function() onReject;

  static Future<void> show(
    BuildContext context, {
    required String visitorId,
    required VisitorNotificationProvider notificationProvider,
    required Future<void> Function() onApprove,
    required Future<void> Function() onReject,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => MultiProvider(
        providers: [
          ChangeNotifierProvider<VisitorNotificationProvider>.value(value: notificationProvider),
          ChangeNotifierProvider<VisitorDetailsProvider>(
            create: (_) => VisitorDetailsProvider(
              VisitorDetailsRepository(MockVisitorDetailsService()),
            )..loadDetails(visitorId),
          ),
        ],
        child: DeliveryDetailsSheet(onApprove: onApprove, onReject: onReject),
      ),
    );
  }

  Future<void> _handleApprove(BuildContext context) async {
    await onApprove();
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _handleReject(BuildContext context) async {
    await onReject();
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _handleLeaveAtGate(BuildContext context, VisitorDetailsProvider provider) async {
    final succeeded = await provider.leaveAtGate();
    if (!context.mounted) return;
    if (succeeded) {
      CustomSnackbar.success(context, 'Visitor marked as left at the gate.');
    } else {
      CustomSnackbar.error(context, provider.errorMessage ?? 'Something went wrong. Please try again.');
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final banner = context.watch<DashboardProvider>().advertisementBanners.firstOrNull;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (banner != null) _AdBanner(banner: banner),
            Padding(
              padding: AppSpacing.all(AppSpacing.md),
              child: Consumer<VisitorDetailsProvider>(
                builder: (context, detailsProvider, _) {
                  if (detailsProvider.isLoading) {
                    return const SizedBox(height: 240, child: Loader());
                  }
                  if (detailsProvider.hasError) {
                    return SizedBox(
                      height: 240,
                      child: CustomErrorWidget(
                        message: detailsProvider.errorMessage ?? 'Something went wrong. Please try again.',
                        onRetry: detailsProvider.retry,
                      ),
                    );
                  }

                  final details = detailsProvider.details;
                  if (details == null) return const SizedBox.shrink();

                  return _DeliveryDetailsContent(
                    details: details,
                    onApprove: () => _handleApprove(context),
                    onReject: () => _handleReject(context),
                    onLeaveAtGate: () => _handleLeaveAtGate(context, detailsProvider),
                    isLeavingAtGate: detailsProvider.isLeavingAtGate,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The advertisement banner, rendered edge-to-edge at the very top of the
/// sheet (Figma requirement) — sourced from `DashboardProvider`'s existing
/// `advertisementBanners`, not a new banner model. `BannerCard` (used
/// elsewhere on the Home screen) is NOT reused here: it hardcodes side
/// margins/decorative icons and never actually loads `banner.image`, which
/// is incompatible with a flush, real-image hero banner.
class _AdBanner extends StatelessWidget {
  const _AdBanner({required this.banner});

  final BannerModel banner;

  static const double _height = 140;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.topLg,
      child: CachedNetworkImage(
        imageUrl: banner.image,
        width: double.infinity,
        height: _height,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(height: _height, color: AppColors.grey100),
        errorWidget: (context, url, error) => Container(
          height: _height,
          color: AppColors.grey100,
          alignment: Alignment.center,
          child: Icon(AppIcons.empty, color: AppColors.grey400, size: AppDimensions.iconLg),
        ),
      ),
    );
  }
}

/// Large photo/initials avatar for the visitor — same
/// `CircleAvatar(backgroundImage: CachedNetworkImageProvider(...))` +
/// colored-initials-fallback convention `dashboard_header.dart` and
/// `ActivityCard`/`VisitorNotificationBanner` already use elsewhere. No real
/// photo asset/CDN exists in this project yet, so in practice this always
/// renders initials today.
class _VisitorPhotoAvatar extends StatelessWidget {
  const _VisitorPhotoAvatar({required this.details});

  final VisitorDetailsModel details;

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
    final photoUrl = details.photoUrl;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return CircleAvatar(
        radius: AppDimensions.avatarLg / 2,
        backgroundColor: AppColors.grey200,
        backgroundImage: CachedNetworkImageProvider(photoUrl),
        onBackgroundImageError: (_, _) {},
      );
    }

    final color = _brandColors[details.company] ?? AppColors.grey400;
    return CircleAvatar(
      radius: AppDimensions.avatarLg / 2,
      backgroundColor: color,
      child: Text(
        details.name.isNotEmpty ? details.name[0].toUpperCase() : '?',
        style: AppTextStyles.headlineSmall.copyWith(color: AppColors.white),
      ),
    );
  }
}

/// One "icon · label · value" row (Company/Entry Time/Exit Time/Approved
/// By). Callers hide the whole row (rather than passing an empty value) for
/// nullable fields — see `_DeliveryDetailsContent`.
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppDimensions.iconSm, color: AppColors.grey500),
          AppSpacing.gapWSm,
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// One circle-icon-with-label quick action (Call/SMS/Share). Disabled
/// (grey, no tap) when [onTap] is null — used when there's no phone number
/// to Call/SMS.
class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  bool get _enabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    final tint = _enabled ? color : AppColors.grey300;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.radiusMd,
      child: Padding(
        padding: AppSpacing.all(AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: AppDimensions.iconLg / 2,
              backgroundColor: tint.withValues(alpha: 0.12),
              child: Icon(icon, color: tint, size: AppDimensions.iconMd),
            ),
            AppSpacing.gapXs,
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: _enabled ? context.colorScheme.onSurface : AppColors.grey400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The sheet's main content once `VisitorDetailsProvider` has data: photo +
/// name + status; Company/Entry/Exit/Approved-by rows; Quick Actions; the
/// Approve/Reject row; the Leave at Gate button.
class _DeliveryDetailsContent extends StatelessWidget {
  const _DeliveryDetailsContent({
    required this.details,
    required this.onApprove,
    required this.onReject,
    required this.onLeaveAtGate,
    required this.isLeavingAtGate,
  });

  final VisitorDetailsModel details;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onLeaveAtGate;
  final bool isLeavingAtGate;

  /// Mirrors `ActivityCard._statusType`'s exact mapping.
  StatusChipType get _statusType {
    switch (details.status.toUpperCase()) {
      case 'INSIDE':
        return StatusChipType.approved;
      case 'DENIED':
        return StatusChipType.rejected;
      case 'LEFT':
      default:
        return StatusChipType.inactive;
    }
  }

  Future<void> _call() async {
    final phone = details.phoneNumber;
    if (phone == null || phone.isEmpty) return;
    await launchUrl(Uri.parse('tel:$phone'));
  }

  Future<void> _sms() async {
    final phone = details.phoneNumber;
    if (phone == null || phone.isEmpty) return;
    await launchUrl(Uri.parse('sms:$phone'));
  }

  Future<void> _share() async {
    await SharePlus.instance.share(
      ShareParams(text: '${details.name} from ${details.company} — entry ${details.entryTime}.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPhone = details.phoneNumber != null && details.phoneNumber!.isNotEmpty;

    return Consumer<VisitorNotificationProvider>(
      builder: (context, notificationProvider, _) {
        final isBusy = notificationProvider.isBusy;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _VisitorPhotoAvatar(details: details),
                AppSpacing.gapWMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        details.name,
                        style: AppTextStyles.titleLarge.copyWith(color: context.colorScheme.onSurface),
                      ),
                      AppSpacing.gapXs,
                      StatusChip(label: details.status, type: _statusType),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.gapMd,
            const CustomDivider(),
            _InfoRow(icon: Icons.storefront_outlined, label: 'Company', value: details.company),
            _InfoRow(icon: AppIcons.clock, label: 'Entry Time', value: details.entryTime),
            if (details.exitTime != null && details.exitTime!.isNotEmpty)
              _InfoRow(icon: AppIcons.clock, label: 'Exit Time', value: details.exitTime!),
            if (details.approvedBy != null && details.approvedBy!.isNotEmpty)
              _InfoRow(icon: AppIcons.checkCircle, label: 'Approved By', value: details.approvedBy!),
            AppSpacing.gapSm,
            const CustomDivider(),
            const SectionTitle(title: 'Quick Actions'),
            Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    icon: AppIcons.phone,
                    label: 'Call',
                    color: AppColors.success,
                    onTap: hasPhone ? _call : null,
                  ),
                ),
                Expanded(
                  child: _QuickActionButton(
                    icon: AppIcons.sms,
                    label: 'SMS',
                    color: AppColors.info,
                    onTap: hasPhone ? _sms : null,
                  ),
                ),
                Expanded(
                  child: _QuickActionButton(
                    icon: AppIcons.share,
                    label: 'Share',
                    color: AppColors.secondary,
                    onTap: _share,
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
                    isLoading: notificationProvider.isApproving,
                    backgroundColor: AppColors.success,
                    foregroundColor: AppColors.white,
                    onPressed: isBusy ? null : onApprove,
                  ),
                ),
                AppSpacing.gapWSm,
                Expanded(
                  child: CustomButton(
                    label: 'Reject Entry',
                    isLoading: notificationProvider.isRejecting,
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.white,
                    onPressed: isBusy ? null : onReject,
                  ),
                ),
              ],
            ),
            AppSpacing.gapSm,
            SecondaryButton(
              label: 'Leave at Gate',
              isLoading: isLeavingAtGate,
              onPressed: isLeavingAtGate ? null : onLeaveAtGate,
            ),
          ],
        );
      },
    );
  }
}
