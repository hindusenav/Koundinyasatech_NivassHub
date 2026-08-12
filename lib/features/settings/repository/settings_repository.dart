import '../models/settings_model.dart';

class SettingsRepository {
  // Simulates fetching initial settings from JSON or backend API
  Future<SettingsModel> fetchSettings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return SettingsModel.initial();
  }
}