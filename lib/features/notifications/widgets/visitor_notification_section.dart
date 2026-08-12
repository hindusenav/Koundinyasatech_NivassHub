import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/feedback/custom_snackbar.dart';
import '../../dashboard/presentation/provider/dashboard_provider.dart';
import '../provider/visitor_notification_provider.dart';
import '../repository/mock_visitor_notification_service.dart';
import '../repository/visitor_notification_repository.dart';
import 'delivery_details_sheet.dart';
import 'visitor_notification_banner.dart';

/// The Home screen's gate-arrival approval card — a normal, persistent
/// section of the dashboard body placed immediately below the header (see
/// `DashboardBody`), not a floating overlay. Renders nothing when there's
/// no pending notification (no leftover empty space) or once it's been
/// dismissed.
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

  /// Tapping the card body opens the "Delivery Details" bottom sheet.
  /// Reuses this exact `_provider` instance and the `_handleApprove`/
  /// `_handleReject` methods above — so Approve/Reject tapped from inside
  /// the sheet go through the identical, already-working flow (API call →
  /// dismiss → Approval Queue sync → snackbar), with no duplicate provider
  /// or logic.
  Future<void> _handleTap() async {
    final notification = _provider.notification;
    if (notification == null) return;
    await DeliveryDetailsSheet.show(
      context,
      visitorId: notification.id,
      notificationProvider: _provider,
      onApprove: _handleApprove,
      onReject: _handleReject,
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

          return Column(
            children: [
              VisitorNotificationBanner(
                notification: notification,
                isApproving: provider.isApproving,
                isRejecting: provider.isRejecting,
                onApprove: _handleApprove,
                onReject: _handleReject,
                onClose: provider.dismiss,
                onTap: _handleTap,
              ),
              const SizedBox(height: 18),
            ],
          );
        },
      ),
    );
  }
}
