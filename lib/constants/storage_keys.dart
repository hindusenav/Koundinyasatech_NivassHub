/// Centralized storage key constants — used by both [LocalStorageService]
/// and [SecureStorageService] so a key is never duplicated or typo'd across
/// call sites.
class StorageKeys {
  StorageKeys._();

  // ---------------------------------------------------------------------
  // Secure storage (tokens, credentials)
  // ---------------------------------------------------------------------
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String isLoggedIn = 'is_logged_in';
  static const String hasLoggedOut = 'has_logged_out';

  // ---------------------------------------------------------------------
  // Local storage (preferences, flags, cached JSON)
  // ---------------------------------------------------------------------
  static const String isFirstLaunch = 'is_first_launch';
  static const String themeMode = 'theme_mode';
  static const String languageCode = 'language_code';
  static const String cachedUserProfile = 'cached_user_profile';
  static const String rememberedEmail = 'remembered_email';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String familyCount = 'household_family_count';
  static const String dailyHelpCount = 'household_daily_help_count';
  static const String vehicleCount = 'household_vehicle_count';
  static const String petCount = 'household_pet_count';
}
