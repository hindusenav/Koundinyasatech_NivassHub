import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/feedback/custom_snackbar.dart';
import '../../dashboard/presentation/provider/dashboard_provider.dart';
import '../provider/visitor_notification_provider.dart';
import '../repository/mock_visitor_notification_service.dart';
import '../repository/visitor_notification_repository.dart';
import 'visitor_notification_banner.dart';

/// Wraps [child] — the Home screen — with the gate-arrival notification
/// banner as a floating overlay, without touching a single line of `child`
/// itself. Dropped in at the route level
/// (`RouteGenerator`'s `AppRoutes.dashboard` case wraps
/// `HomeDashboardScreen` with this) rather than inside the Home screen's
/// own widget tree, so the Home screen, its provider, and its existing
/// widgets stay completely untouched.
///
/// Timeline: waits [initialDelay] after mounting, then loads the pending
/// notification; if one exists, slides it down over [slideDuration] and
/// auto-dismisses it after [autoDismissAfter] if the user takes no action.
class VisitorNotificationOverlay extends StatefulWidget {
  const VisitorNotificationOverlay({
    super.key,
    required this.child,
    this.initialDelay = const Duration(seconds: 3),
    this.slideDuration = const Duration(milliseconds: 300),
    this.autoDismissAfter = const Duration(seconds: 10),
  });

  final Widget child;
  final Duration initialDelay;
  final Duration slideDuration;
  final Duration autoDismissAfter;

  @override
  State<VisitorNotificationOverlay> createState() => _VisitorNotificationOverlayState();
}

class _VisitorNotificationOverlayState extends State<VisitorNotificationOverlay>
    with SingleTickerProviderStateMixin {
  /// Approximate height of the Home screen's own (untouched) greeting/
  /// search header, so the banner sits just below it rather than under the
  /// status bar — tuned to the Figma, not measured live, since this widget
  /// deliberately never reaches into that header's implementation.
  static const double _bannerTopOffset = 92;

  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final VisitorNotificationProvider _provider;

  Timer? _initialDelayTimer;
  Timer? _autoDismissTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.slideDuration);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, -1.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _provider = VisitorNotificationProvider(
      VisitorNotificationRepository(MockVisitorNotificationService()),
    )..addListener(_handleProviderChanged);

    // `SlideTransition`'s offset is a fraction of the banner's *own*
    // height, not the distance to the top of the screen — so once a real
    // device/notification-text height pushes that math off, `-1.2` alone
    // can leave a sliver of the card parked on screen forever after
    // Approve/Reject instead of just mid-animation. Rebuilding once the
    // reverse animation fully settles lets `build` stop mounting the
    // banner outright at that point, so there's no distance to get wrong.
    _controller.addStatusListener(_handleAnimationStatusChanged);

    _initialDelayTimer = Timer(widget.initialDelay, () {
      if (mounted) _provider.loadPendingNotification();
    });
  }

  @override
  void dispose() {
    _initialDelayTimer?.cancel();
    _autoDismissTimer?.cancel();
    _provider.removeListener(_handleProviderChanged);
    _controller.removeStatusListener(_handleAnimationStatusChanged);
    _provider.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleProviderChanged() {
    if (_provider.isVisible) {
      _controller.forward();
      _autoDismissTimer?.cancel();
      _autoDismissTimer = Timer(widget.autoDismissAfter, _provider.dismiss);
    } else {
      _controller.reverse();
      _autoDismissTimer?.cancel();
    }
  }

  /// Rebuilds when the slide animation settles into `forward`/`dismissed`
  /// so [build] can key the banner's presence off [AnimationStatus]
  /// directly, instead of trusting the slide distance alone to have fully
  /// cleared it off-screen.
  void _handleAnimationStatusChanged(AnimationStatus status) {
    if (mounted) setState(() {});
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
      // Best-effort: the card has already dismissed by this point (see
      // `VisitorNotificationProvider._respond`), so a lookup failure here
      // must never suppress the success snackbar below.
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

  @override
  Widget build(BuildContext context) {
    // Once the reverse animation fully settles, the banner is gone for
    // good regardless of its own height vs. the slide distance — stop
    // mounting it entirely rather than leaving it positioned off (but not
    // necessarily off-screen).
    final showBanner = _controller.status != AnimationStatus.dismissed;

    return Stack(
      children: [
        widget.child,
        if (showBanner)
          Positioned(
            top: MediaQuery.of(context).padding.top + _bannerTopOffset,
            left: AppSpacing.screenHorizontal,
            right: AppSpacing.screenHorizontal,
            child: SlideTransition(
              position: _slideAnimation,
              child: ChangeNotifierProvider<VisitorNotificationProvider>.value(
                value: _provider,
                child: Consumer<VisitorNotificationProvider>(
                  builder: (context, provider, _) {
                    final notification = provider.notification;
                    if (notification == null) return const SizedBox.shrink();

                    return VisitorNotificationBanner(
                      notification: notification,
                      isApproving: provider.isApproving,
                      isRejecting: provider.isRejecting,
                      onApprove: _handleApprove,
                      onReject: _handleReject,
                      onClose: provider.dismiss,
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
