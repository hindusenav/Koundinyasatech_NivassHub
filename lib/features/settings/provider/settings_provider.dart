import 'package:flutter/foundation.dart';

import '../repository/settings_repository.dart';

/// Owns the Push Notifications preference. Seeded synchronously from
/// [SettingsRepository] at construction — `LocalStorageService` is already
/// initialized by the time providers are built in `app.dart`, so there's no
/// async gap to await here.
class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._repository)
      : _notificationsEnabled = _repository.getNotificationsEnabled();

  final SettingsRepository _repository;

  bool _notificationsEnabled;

  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    notifyListeners();
    await _repository.setNotificationsEnabled(value);
  }
}
