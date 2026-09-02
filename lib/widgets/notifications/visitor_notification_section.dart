import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/providers/notifications/visitor_notification_provider.dart';
import 'package:flutter_nivasshub/services/notifications/mock_visitor_notification_service.dart';
import 'package:flutter_nivasshub/repositories/notifications/visitor_notification_repository.dart';
import 'package:flutter_nivasshub/screens/notifications/delivery_details_screen.dart';
import 'package:flutter_nivasshub/widgets/notifications/visitor_notification_banner.dart';

/// The Home screen's gate-arrival "Approval Requests" popup — a floating
/// toast anchored just below the header (see `DashboardBody`, which stacks
/// this on top of the scrollable dashboard content via
/// `CompositedTransformFollower`, not as a child of its content `Column`).
/// Because it's a popup rather than in-flow content, it never reserves or
/// pushes down the space between the header and the advertising/banner
/// section — whether it's showing or not. Renders nothing when there's no
/// pending notification, or once it's been dismissed.
///
/// Owns its own `VisitorNotificationProvider` — same construction the old
/// `VisitorNotificationOverlay` used — so the provider/repository/service/
/// model are untouched; only *where* this card is mounted changed. Loads
/// immediately (no delay) and stays until Approve/Reject/Close, since it's
/// permanent-until-dismissed popup content rather than a timed toast, so
/// the previous 3s appear-delay and 10s auto-dismiss timer don't apply.
class VisitorNotificationSection extends StatefulWidget {
  const VisitorNotificationSection({super.key, this.horizontalPadding = 0});

  /// Left/right margin applied around the popup so it lines up with the
  /// rest of `DashboardBody`'s padded content, even though this widget
  /// itself now lives outside that padded `Column` (it's a `Stack`
  /// sibling, floating above it — see `DashboardBody`).
  final double horizontalPadding;

  @override
  State<VisitorNotificationSection> createState() => _VisitorNotificationSectionState();
}

class _VisitorNotificationSectionState extends State<VisitorNotificationSection> {
  /// Small breathing gap below the header's bottom edge so the popup sits
  /// just under it rather than touching it — it must NOT overlap the
  /// header (unlike the old `Transform.translate(-80)` design).
  static const double _topGap = 10;

  late final VisitorNotificationProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = VisitorNotificationProvider(
      VisitorNotificationRepository(MockVisitorNotificationService()),
    )..loadPendingNotification();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  Future<void> _handleApprove() async {
    final company = _provider.notification?.company;
    final succeeded = await _provider.approve();
    if (!mounted) return;
    if (succeeded) {
      // Removes the matching entry from the Home screen's "Approval Queue"
      // card immediately — no manual refresh needed. See
      // `DashboardProvider.removeVisitorByCompany` for why this matches by
      // company/name rather than a shared visitor ID (mock-mode-only).
      // Best-effort: the card has already dismissed by this point, so a
      // lookup failure here must never suppress the success snackbar below.
      try {
        context.read<DashboardProvider>().removeVisitorByCompany(company);
      } catch (_) {}
      CustomSnackbar.success(context, 'Visitor approved successfully.');
    } else {
      CustomSnackbar.error(context, _provider.errorMessage ?? 'Something went wrong. Please try again.');
    }
  }

  Future<void> _handleReject() async {
    final company = _provider.notification?.company;
    final succeeded = await _provider.reject();
    if (!mounted) return;
    if (succeeded) {
      // Best-effort sync — see the matching comment in `_handleApprove`.
      try {
        context.read<DashboardProvider>().removeVisitorByCompany(company);
      } catch (_) {}
      CustomSnackbar.error(context, 'Visitor entry rejected successfully.');
    } else {
      CustomSnackbar.error(context, _provider.errorMessage ?? 'Something went wrong. Please try again.');
    }
  }

  /// Tapping the card body opens the "Delivery Details" screen. Reuses this
  /// exact `_provider` instance and the `_handleApprove`/`_handleReject`
  /// methods above — so Approve/Reject tapped from that screen go through
  /// the identical, already-working flow (API call → dismiss → Approval
  /// Queue sync → snackbar), with no duplicate provider or logic.
  Future<void> _handleTap() async {
    final notification = _provider.notification;
    if (notification == null) return;
    await Navigator.of(context).pushNamed(
      AppRoutes.visitorDetail,
      arguments: DeliveryDetailsScreenArgs(
        visitorId: notification.id,
        notificationProvider: _provider,
        onApprove: _handleApprove,
        onReject: _handleReject,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VisitorNotificationProvider>.value(
      value: _provider,
      child: Consumer<VisitorNotificationProvider>(
        builder: (context, provider, _) {
          final notification = provider.notification;
          if (!provider.isVisible || notification == null) return const SizedBox.shrink();

          // A `CompositedTransformFollower` (see `DashboardBody`) gives its
          // child unbounded width constraints, but `VisitorNotificationBanner`
          // sizes itself with `width: double.infinity` — so this needs an
          // explicit, bounded width of its own here, computed from the
          // screen width minus the same horizontal padding the rest of the
          // dashboard content uses, so the popup lines up with it visually.
          final screenWidth = MediaQuery.of(context).size.width;
          final cardWidth = screenWidth - (widget.horizontalPadding * 2);

          return Padding(
            padding: EdgeInsets.only(
              top: _topGap,
              left: widget.horizontalPadding,
            ),
            child: SizedBox(
              width: cardWidth,
              child: VisitorNotificationBanner(
                notification: notification,
                isApproving: provider.isApproving,
                isRejecting: provider.isRejecting,
                onApprove: _handleApprove,
                onReject: _handleReject,
                onClose: provider.dismiss,
                onTap: _handleTap,
              ),
            ),
          );
        },
      ),
    );
  }
}
