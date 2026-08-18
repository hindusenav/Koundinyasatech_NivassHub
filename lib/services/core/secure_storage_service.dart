import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_nivasshub/constants/storage_keys.dart';

/// Thin wrapper around [FlutterSecureStorage] for sensitive data — auth
/// tokens and credentials. Never store these via [LocalStorageService].
class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<void> deleteAll() => _storage.deleteAll();

  // ---------------------------------------------------------------------
  // Auth token convenience accessors — this is the callback shape
  // `ApiClient`/`AuthInterceptor` expect (`Future<String?> Function()`).
  // ---------------------------------------------------------------------
  Future<void> saveAccessToken(String token) =>
      write(StorageKeys.accessToken, token);

  Future<String?> getAccessToken() => read(StorageKeys.accessToken);

  Future<void> saveRefreshToken(String token) =>
      write(StorageKeys.refreshToken, token);

  Future<String?> getRefreshToken() => read(StorageKeys.refreshToken);

  Future<void> clearTokens() async {
    await delete(StorageKeys.accessToken);
    await delete(StorageKeys.refreshToken);
  }

  // ---------------------------------------------------------------------
  // Login session flag — set once at login/registration success, checked
  // once at splash startup to decide Dashboard vs. Login. Distinct from the
  // tokens above because the existing-user OTP-login flow doesn't currently
  // receive an access token from the backend, so this flag (rather than
  // token presence) is the single source of truth for "is logged in".
  // ---------------------------------------------------------------------
  Future<void> saveSession() => write(StorageKeys.isLoggedIn, 'true');

  Future<bool> hasValidSession() async =>
      (await read(StorageKeys.isLoggedIn)) == 'true';

  Future<void> clearSession() async {
    await clearTokens();
    await delete(StorageKeys.isLoggedIn);
    // Marks this device as having logged out at least once, so Splash
    // skips the first-run Welcome screen and goes straight to Onboarding
    // Step Two (Create Account / Login) on every future launch.
    await write(StorageKeys.hasLoggedOut, 'true');
  }

  Future<bool> hasLoggedOutBefore() async =>
      (await read(StorageKeys.hasLoggedOut)) == 'true';
}
