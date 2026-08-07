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

  // ---------------------------------------------------------------------
  // Local storage (preferences, flags, cached JSON)
  // ---------------------------------------------------------------------
  static const String isFirstLaunch = 'is_first_launch';
  static const String themeMode = 'theme_mode';
  static const String languageCode = 'language_code';
  static const String cachedUserProfile = 'cached_user_profile';
  static const String rememberedEmail = 'remembered_email';
  static const String notificationsEnabled = 'notifications_enabled';
}
