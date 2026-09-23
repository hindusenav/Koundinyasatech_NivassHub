import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around [SharedPreferences] for small, non-sensitive local
/// data (flags, preferences, cached JSON). For tokens/credentials use
/// [SecureStorageService] instead.
///
/// [init] must be awaited once during app startup, before any other method
/// is called — construct one instance and hand it down via `Provider`
/// rather than reading `SharedPreferences.getInstance()` from multiple
/// places.
class LocalStorageService {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _prefsOrThrow {
    final prefs = _prefs;
    if (prefs == null) {
      throw StateError(
        'LocalStorageService.init() must be called before use.',
      );
    }
    return prefs;
  }

  Future<bool> setString(String key, String value) =>
      _prefsOrThrow.setString(key, value);
  String? getString(String key) => _prefsOrThrow.getString(key);

  Future<bool> setBool(String key, bool value) =>
      _prefsOrThrow.setBool(key, value);
  bool? getBool(String key) => _prefsOrThrow.getBool(key);

  Future<bool> setInt(String key, int value) =>
      _prefsOrThrow.setInt(key, value);
  int? getInt(String key) => _prefsOrThrow.getInt(key);

  Future<bool> setDouble(String key, double value) =>
      _prefsOrThrow.setDouble(key, value);
  double? getDouble(String key) => _prefsOrThrow.getDouble(key);

  Future<bool> setStringList(String key, List<String> value) =>
      _prefsOrThrow.setStringList(key, value);
  List<String>? getStringList(String key) => _prefsOrThrow.getStringList(key);

  /// Stores [value] as JSON — [value] must be JSON-encodable (a Map/List of
  /// primitives), e.g. the result of a model's `toJson()`.
  Future<bool> setJson(String key, Object value) =>
      setString(key, jsonEncode(value));

  /// Decodes the JSON previously stored under [key], or `null` if absent.
  dynamic getJson(String key) {
    final raw = getString(key);
    if (raw == null) return null;
    return jsonDecode(raw);
  }

  Future<bool> remove(String key) => _prefsOrThrow.remove(key);
  Future<bool> clear() => _prefsOrThrow.clear();
  bool containsKey(String key) => _prefsOrThrow.containsKey(key);
}
