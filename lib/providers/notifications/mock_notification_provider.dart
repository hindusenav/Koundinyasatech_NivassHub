import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/notifications/mock_notification_model.dart';
import 'package:flutter_nivasshub/services/notifications/notification_service_base.dart';

enum NotificationLogState { initial, loading, success, empty, error }

/// Backs the mock email inbox.
///
/// Global and lazy: the log is written from inside the KYC flow and read
/// by a screen reachable from Settings, and the unread badge needs
/// something listenable across both.
class MockNotificationProvider extends ChangeNotifier {
  MockNotificationProvider(NotificationServiceBase service)
    : _service = service;

  final NotificationServiceBase _service;

  NotificationLogState _state = NotificationLogState.initial;
  List<MockNotificationModel> _notifications = const [];
  String? _errorMessage;

  NotificationLogState get state => _state;
  List<MockNotificationModel> get notifications => _notifications;
  String? get errorMessage => _errorMessage;

  int get unreadCount => _notifications.where((n) => !n.read).length;

  Future<void> load() async {
    _state = NotificationLogState.loading;
    _errorMessage = null;
    notifyListeners();

    final response = await _service.getNotifications();

    if (response.isSuccess && response.data != null) {
      _notifications = response.data!;
      _state = _notifications.isEmpty
          ? NotificationLogState.empty
          : NotificationLogState.success;
    } else {
      _notifications = const [];
      _errorMessage = response.message ?? KycStrings.genericError;
      _state = NotificationLogState.error;
    }

    notifyListeners();
  }

  Future<void> markAllRead() async {
    if (unreadCount == 0) return;
    await _service.markAllRead();
    _notifications = _notifications
        .map((n) => n.copyWith(read: true))
        .toList(growable: false);
    notifyListeners();
  }

  Future<void> clear() async {
    await _service.clearNotifications();
    _notifications = const [];
    _state = NotificationLogState.empty;
    notifyListeners();
  }
}
