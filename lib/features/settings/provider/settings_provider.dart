import 'package:flutter/foundation.dart';

import '../repository/settings_repository.dart';

/// Owns the Push Notifications preference. Seeded synchronously from
/// [SettingsRepository] at construction — `LocalStorageService` is already
/// initialized by the time providers are built in `app.dart`, so there's no
/// async gap to await here.
class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._repository)
      : _notificationsEnabled = _repository.getNotificationsEnabled(),
        _familyCount = _repository.getFamilyCount(),
        _dailyHelpCount = _repository.getDailyHelpCount(),
        _vehicleCount = _repository.getVehicleCount(),
        _petCount = _repository.getPetCount();

  final SettingsRepository _repository;

  bool _notificationsEnabled;
  int _familyCount;
  int _dailyHelpCount;
  int _vehicleCount;
  int _petCount;

  bool get notificationsEnabled => _notificationsEnabled;
  int get familyCount => _familyCount;
  int get dailyHelpCount => _dailyHelpCount;
  int get vehicleCount => _vehicleCount;
  int get petCount => _petCount;

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    notifyListeners();
    await _repository.setNotificationsEnabled(value);
  }

  Future<void> addFamilyMember() async {
    _familyCount++;
    notifyListeners();
    await _repository.setFamilyCount(_familyCount);
  }

  Future<void> addDailyHelp() async {
    _dailyHelpCount++;
    notifyListeners();
    await _repository.setDailyHelpCount(_dailyHelpCount);
  }

  Future<void> addVehicle() async {
    _vehicleCount++;
    notifyListeners();
    await _repository.setVehicleCount(_vehicleCount);
  }

  Future<void> addPet() async {
    _petCount++;
    notifyListeners();
    await _repository.setPetCount(_petCount);
  }
}
