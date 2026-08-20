import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/models/settings/settings_model.dart';
import 'package:flutter_nivasshub/services/settings/settings_repository.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsRepository _settingsRepository;

  SettingsProvider({required SettingsRepository settingsRepository})
      : _settingsRepository = settingsRepository {
    loadUserSettings();
  }

  int _selectedBottomNavIndex = 4;
  SettingsModel _userSettings = SettingsModel(
    notificationPreferences: true,
    securityAlerts: true,
    feedSettings: true,
    activePlan: 'Ad-Supported',
  );
  bool _isLoading = false;

  // --- NEW USER PROFILE FIELDS ---
  String _userName = 'User Name';
  String _phone = '';
  String _email = '';

  // Getters
  int get selectedBottomNavIndex => _selectedBottomNavIndex;
  SettingsModel get userSettings => _userSettings;
  bool get isLoading => _isLoading;

  // --- NEW PROFILE GETTERS ---
  String get userName => _userName;
  String get phone => _phone;
  String get email => _email;
  
  // Getter for avatar initials (e.g., fixes userInitial error)
  String get userInitial =>
      _userName.trim().isNotEmpty ? _userName.trim()[0].toUpperCase() : 'U';

  void setBottomNavIndex(int index) {
    _selectedBottomNavIndex = index;
    notifyListeners();
  }

  // --- NEW PROFILE METHODS ---
  /// Hydrates or updates user details from DashboardProvider or API
  void setUserDetails({String? name, String? phone, String? email}) {
    if (name != null && name.trim().isNotEmpty) _userName = name.trim();
    if (phone != null && phone.trim().isNotEmpty) _phone = phone.trim();
    if (email != null && email.trim().isNotEmpty) _email = email.trim();
    notifyListeners();
  }

  /// Updates profile values
  Future<void> updateProfile({
    required String name,
    required String phone,
    required String email,
  }) async {
    _userName = name;
    _phone = phone;
    _email = email;

    notifyListeners();

    // Optionally save via repository if your backend handles it:
    // await _settingsRepository.saveUserProfile(name, phone, email);
  }

  // --- YOUR EXISTING METHODS (UNTOUCHED) ---
  Future<void> loadUserSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      _userSettings = await _settingsRepository.fetchUserSettings();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleNotificationPreference(bool value) async {
    _userSettings = _userSettings.copyWith(notificationPreferences: value);
    notifyListeners();
    await _settingsRepository.saveUserSettings(_userSettings);
  }

  Future<void> toggleSecurityAlerts(bool value) async {
    _userSettings = _userSettings.copyWith(securityAlerts: value);
    notifyListeners();
    await _settingsRepository.saveUserSettings(_userSettings);
  }

  Future<void> toggleFeedSettings(bool value) async {
    _userSettings = _userSettings.copyWith(feedSettings: value);
    notifyListeners();
    await _settingsRepository.saveUserSettings(_userSettings);
  }

  Future<void> updateActivePlan(String newPlan) async {
    _userSettings = _userSettings.copyWith(activePlan: newPlan);
    notifyListeners();
    await _settingsRepository.saveUserSettings(_userSettings);
  }
}