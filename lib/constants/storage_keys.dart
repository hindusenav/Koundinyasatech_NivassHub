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
  static const String kycApproved = 'kyc_approved';

  /// Authorizes document upload and KYC submission for an in-flight
  /// registration, so it is a credential and belongs beside the tokens
  /// rather than with the non-sensitive flow state below.
  static const String kycToken = 'kyc_token';

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

  // ---------------------------------------------------------------------
  // Auth flow / KYC state (non-sensitive: ids, enums, metadata)
  //
  // Deliberately local rather than secure — matching the existing
  // `accessToken` (secure) vs `cachedUserProfile` (local) split. None of
  // these grant access on their own; the credentials they accompany live
  // in secure storage above.
  // ---------------------------------------------------------------------
  static const String authFlowState = 'auth_flow_state';
  static const String authFlowContext = 'auth_flow_context';
  static const String kycUploadedDocuments = 'kyc_uploaded_documents';

  /// Named `mock_*` so it is obvious these die with the mock services and
  /// have no counterpart once a real backend is wired up.
  static const String kycMockLedger = 'mock_kyc_ledger';
  static const String mockNotificationLog = 'mock_notification_log';
}
