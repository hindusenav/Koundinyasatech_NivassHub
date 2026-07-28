import 'package:flutter/foundation.dart';

/// Minimal app-wide logger, silent in release builds. For HTTP
/// request/response logs specifically, see
/// `core/network/interceptors/logging_interceptor.dart`.
class AppLogger {
  AppLogger._();

  static void info(String message, {String tag = 'APP'}) =>
      _log('INFO', tag, message);

  static void warning(String message, {String tag = 'APP'}) =>
      _log('WARNING', tag, message);

  static void error(
    String message, {
    String tag = 'APP',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log('ERROR', tag, message);
    if (kDebugMode) {
      if (error != null) debugPrint('    error: $error');
      if (stackTrace != null) debugPrint('$stackTrace');
    }
  }

  static void _log(String level, String tag, String message) {
    if (!kDebugMode) return;
    debugPrint('[$level][$tag] $message');
  }
}
