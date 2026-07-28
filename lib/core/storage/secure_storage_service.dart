import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage_keys.dart';

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
}
