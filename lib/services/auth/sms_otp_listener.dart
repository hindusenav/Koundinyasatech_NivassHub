import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:smart_auth/smart_auth.dart';

/// Android SMS OTP auto-fill for the *mobile* OTP only (email OTPs are
/// always typed by hand).
///
/// Uses Google's SMS User Consent API: Play services shows a one-tap
/// "Allow this app to read the message?" sheet when an SMS arrives and hands
/// back only that single message. It needs no `READ_SMS`/`RECEIVE_SMS`
/// permission and no app-hash in the SMS body, so it works the same in
/// debug and release builds and with any backend SMS template.
///
/// One listener per instance: [start] is a no-op while already listening, so
/// widget rebuilds can never stack listeners. Call [stop] from `dispose`.
class SmsOtpListener {
  SmsOtpListener({required this.length, required this.onCode});

  final int length;
  final ValueChanged<String> onCode;

  bool _listening = false;
  int _generation = 0;

  bool get _supported => !kIsWeb && Platform.isAndroid;

  /// Starts listening if not already. Safe to call repeatedly.
  void start() {
    if (!_supported || _listening) return;
    _listening = true;
    _listen(++_generation);
  }

  /// Drops any pending listener and listens afresh (e.g. after Resend OTP).
  void restart() {
    if (!_supported) return;
    stop();
    start();
  }

  void stop() {
    if (!_listening) return;
    _listening = false;
    _generation++; // invalidates any in-flight result
    SmartAuth.instance.removeUserConsentApiListener();
  }

  Future<void> _listen(int generation) async {
    try {
      final result = await SmartAuth.instance.getSmsWithUserConsentApi(
        matcher: '(?<!\\d)\\d{$length}(?!\\d)',
      );
      // Stopped/restarted while waiting: this result belongs to a dead listener.
      if (generation != _generation) return;
      _listening = false;
      final code = result.data?.code;
      if (code != null && code.length == length) onCode(code);
    } catch (e) {
      if (generation != _generation) return;
      _listening = false;
      debugPrint('[SmsOtpListener] listen failed: $e');
    }
  }
}
