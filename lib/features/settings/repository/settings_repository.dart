import '../../../core/storage/local_storage_service.dart';
import '../../../core/storage/storage_keys.dart';

/// Wraps `LocalStorageService` for Settings' on-device preferences. No
/// mock/real split here — there's no server concept for a device-local
/// toggle; `LocalStorageService` already *is* the one real implementation.
class SettingsRepository {
  SettingsRepository(this._storage);

  final LocalStorageService _storage;

  bool getNotificationsEnabled() =>
      _storage.getBool(StorageKeys.notificationsEnabled) ?? true;

  Future<void> setNotificationsEnabled(bool value) =>
      _storage.setBool(StorageKeys.notificationsEnabled, value);

  // ---------------------------------------------------------------------
  // Household — device-local counters (no backend concept for these yet).
  // ---------------------------------------------------------------------
  int getFamilyCount() => _storage.getInt(StorageKeys.familyCount) ?? 0;

  Future<void> setFamilyCount(int value) =>
      _storage.setInt(StorageKeys.familyCount, value);

  int getDailyHelpCount() => _storage.getInt(StorageKeys.dailyHelpCount) ?? 0;

  Future<void> setDailyHelpCount(int value) =>
      _storage.setInt(StorageKeys.dailyHelpCount, value);

  int getVehicleCount() => _storage.getInt(StorageKeys.vehicleCount) ?? 0;

  Future<void> setVehicleCount(int value) =>
      _storage.setInt(StorageKeys.vehicleCount, value);

  int getPetCount() => _storage.getInt(StorageKeys.petCount) ?? 0;

  Future<void> setPetCount(int value) =>
      _storage.setInt(StorageKeys.petCount, value);
}
