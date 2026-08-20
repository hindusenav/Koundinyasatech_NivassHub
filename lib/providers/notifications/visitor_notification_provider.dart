import 'package:flutter/foundation.dart';

import 'package:flutter_nivasshub/models/notifications/visitor_notification_model.dart';
import 'package:flutter_nivasshub/services/notifications/visitor_notification_repository.dart';
import 'package:flutter_nivasshub/services/notifications/visitor_notification_service_base.dart';

enum VisitorNotificationState { initial, loading, success, empty, error }

/// Owns the Home screen's visitor-arrival banner: a single-shot fetch of
/// the one pending gate notification (if any), plus the Approve/Reject
/// in-flight/result state the banner's buttons read from.
///
/// [VisitorNotificationState.empty] (nobody waiting) and
/// [VisitorNotificationState.error] (fetch failed) intentionally render no
/// UI — this is a passive, best-effort banner, not a screen with its own
/// error/empty placeholder — [VisitorNotificationOverlay] only shows
/// anything once [state] is [VisitorNotificationState.success] and
/// [notification] is non-null.
class VisitorNotificationProvider extends ChangeNotifier {
  VisitorNotificationProvider(this._repository);

  final VisitorNotificationRepository _repository;

  VisitorNotificationState _state = VisitorNotificationState.initial;
  String? _errorMessage;
  VisitorNotificationModel? _notification;
  bool _isApproving = false;
  bool _isRejecting = false;
  bool _dismissed = false;

  VisitorNotificationState get state => _state;
  String? get errorMessage => _errorMessage;
  VisitorNotificationModel? get notification => _notification;
  bool get isApproving => _isApproving;
  bool get isRejecting => _isRejecting;
  bool get isBusy => _isApproving || _isRejecting;

  /// Whether the banner should currently be on-screen — the overlay widget
  /// drives its slide-in/out animation off this.
  bool get isVisible =>
      _state == VisitorNotificationState.success && _notification != null && !_dismissed;

  Future<void> loadPendingNotification() async {
    _state = VisitorNotificationState.loading;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.getPendingNotification();
    if (response.isSuccess) {
      _notification = response.data;
      _dismissed = false;
      _state = _notification == null ? VisitorNotificationState.empty : VisitorNotificationState.success;
    } else {
      _errorMessage = response.message ?? 'Unable to load the visitor notification right now.';
      _state = VisitorNotificationState.error;
    }

    notifyListeners();
  }

  Future<bool> approve() => _respond(VisitorAction.approve);

  Future<bool> reject() => _respond(VisitorAction.reject);

  Future<bool> _respond(VisitorAction action) async {
    final current = _notification;
    if (current == null || isBusy) return false;

    if (action == VisitorAction.approve) {
      _isApproving = true;
    } else {
      _isRejecting = true;
    }
    notifyListeners();

    final response = await _repository.respondToVisitor(
      visitorId: current.id,
      action: action,
      gate: current.gate,
    );

    _isApproving = false;
    _isRejecting = false;

    final succeeded = response.isSuccess;
    if (!succeeded) {
      _errorMessage = response.message ?? 'Something went wrong. Please try again.';
    }

    // Always dismiss once the call settles — approved, rejected, or
    // failed — so the banner never gets stuck on screen waiting on a
    // not-yet-working backend. `succeeded` still tells the caller which
    // snackbar to show and whether to sync the Approval Queue.
    dismiss();
    return succeeded;
  }

  /// Hides the banner — called on the close (X) tap, right after any
  /// Approve/Reject response (success or failure — see [_respond]), or by
  /// the overlay's 10s auto-dismiss timer.
  /// Deliberately leaves [_notification] in place (only flips [_dismissed])
  /// so the slide-out animation still has real content to show while it
  /// retracts.
  void dismiss() {
    if (_dismissed) return;
    _dismissed = true;
    notifyListeners();
  }
}
