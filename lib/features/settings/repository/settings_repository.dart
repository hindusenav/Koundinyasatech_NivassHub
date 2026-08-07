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
}
