import 'package:flutter_nivasshub/services/core/local_storage_service.dart';
import 'package:flutter_nivasshub/models/settings/settings_model.dart';

class SettingsRepository {
  final LocalStorageService localStorageService;

  SettingsRepository(this.localStorageService);

  Future<SettingsModel> fetchUserSettings() async {
    try {
      final savedNotifs = localStorageService.getBool('settings_notifs') ?? true;
      final savedSecurity = localStorageService.getBool('settings_security') ?? true;
      final savedFeed = localStorageService.getBool('settings_feed') ?? true;
      final savedPlan = localStorageService.getString('settings_plan') ?? 'Ad-Supported';

      return SettingsModel(
        notificationPreferences: savedNotifs,
        securityAlerts: savedSecurity,
        feedSettings: savedFeed,
        activePlan: savedPlan,
      );
    } catch (e) {
      return SettingsModel(
        notificationPreferences: true,
        securityAlerts: true,
        feedSettings: true,
        activePlan: 'Ad-Supported',
      );
    }
  }

  Future<bool> saveUserSettings(SettingsModel settings) async {
    try {
      await localStorageService.setBool('settings_notifs', settings.notificationPreferences);
      await localStorageService.setBool('settings_security', settings.securityAlerts);
      await localStorageService.setBool('settings_feed', settings.feedSettings);
      await localStorageService.setString('settings_plan', settings.activePlan);
      return true;
    } catch (e) {
      return false;
    }
  }
}