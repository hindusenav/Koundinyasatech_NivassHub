import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/storage/local_storage_service.dart';
import 'package:flutter_nivasshub/constants/storage_keys.dart';

/// Owns the app's live `ThemeMode`, persisted via `LocalStorageService`.
/// Lives in `lib/app/` (not `core/theme/`) — every file in `core/theme/` is
/// a stateless constant/builder registry, while this is a stateful
/// `ChangeNotifier` with storage side effects, the same category as
/// `NavigationService`.
class ThemeModeProvider extends ChangeNotifier {
  ThemeModeProvider(this._storage);

  final LocalStorageService _storage;

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Synchronous — `LocalStorageService.getString` is an instant in-memory
  /// read once `.init()` has already completed, so calling this inline at
  /// `create:` time (`ThemeModeProvider(storage)..init()`) sets the correct
  /// theme before the first frame, avoiding a flash of the wrong theme on
  /// cold start.
  void init() {
    final saved = _storage.getString(StorageKeys.themeMode);
    _themeMode = ThemeMode.values.firstWhere(
      (mode) => mode.name == saved,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await _storage.setString(StorageKeys.themeMode, mode.name);
  }
}
