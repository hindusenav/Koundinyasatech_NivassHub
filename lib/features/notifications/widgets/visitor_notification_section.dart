import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/app_routes.dart';
import '../../../shared/widgets/feedback/custom_snackbar.dart';
import '../../dashboard/presentation/provider/dashboard_provider.dart';
import '../provider/visitor_notification_provider.dart';
import '../repository/mock_visitor_notification_service.dart';
import '../repository/visitor_notification_repository.dart';
import '../screens/delivery_details_screen.dart';
import 'visitor_notification_banner.dart';

/// The Home screen's gate-arrival approval card — a normal, persistent
/// section of the dashboard body placed immediately below the header (see
/// `DashboardBody`), not a floating overlay. Pulled up by [_overlap] so it
/// visually overlaps the header's rounded bottom edge and reads as part of
/// the top section instead of separate content floating below it. Renders
/// nothing when there's no pending notification (no leftover empty space,
/// no dangling overlap) or once it's been dismissed.
///
/// Owns its own `VisitorNotificationProvider` — same construction the old
/// `VisitorNotificationOverlay` used — so the provider/repository/service/
/// model are untouched; only *where* this card is mounted changed. Loads
/// immediately (no delay) and stays until Approve/Reject/Close, since it's
/// now permanent page content rather than a transient overlay, so the
/// previous 3s appear-delay and 10s auto-dismiss timer no longer apply.
class VisitorNotificationSection extends StatefulWidget {
  const VisitorNotificationSection({super.key});

  @override
  State<VisitorNotificationSection> createState() => _VisitorNotificationSectionState();
}

class _VisitorNotificationSectionState extends State<VisitorNotificationSection> {
  /// How far up the card is pulled so it visibly overlaps the header's
  /// rounded bottom edge — the card's top portion sits on the header's
  /// blue background before transitioning to the white page background,
  /// rather than merely touching the header with no gap.
  static const double _overlap = 80;

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

          // Transform.translate is returned directly here — NOT wrapped in
          // an extra Column/SizedBox — so it becomes DashboardBody's
          // Column's direct child. That matters for hit-testing: Transform
          // is paint-only (it shifts where the card *renders* without
          // changing the layout box reserved for it, so the card visually
          // overlaps the header above), and `RenderTransform.hitTest`
          // deliberately skips bounds-checking itself against that
          // untranslated box before delegating to its child. An extra
          // wrapping Column here would reintroduce a bounds-checked
          // RenderBox between DashboardBody's Column and this Transform,
          // which silently swallows every tap that lands on the visually
          // overlapping (translated) portion of the card — i.e. most of
          // it — before it ever reaches the banner's Approve/Reject/Close/
          // tap handlers. See `DashboardBody`'s trailing `SizedBox` for
          // the spacing this card used to reserve for itself.
          return Transform.translate(
            offset: const Offset(0, -_overlap),
            child: VisitorNotificationBanner(
              notification: notification,
              isApproving: provider.isApproving,
              isRejecting: provider.isRejecting,
              onApprove: _handleApprove,
              onReject: _handleReject,
              onClose: provider.dismiss,
              onTap: _handleTap,
            ),
          );
        },
      ),
    );
  }
}
