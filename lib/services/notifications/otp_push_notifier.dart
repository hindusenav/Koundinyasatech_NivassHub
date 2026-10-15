import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';

/// Shows a push-notification style banner that slides in from the top of
/// the screen whenever the backend hands back an OTP (registration, or a
/// resend through registration-check). Tapping Copy puts the code on the
/// clipboard; the banner dismisses itself, or by swiping up.
///
/// Purely additive: services call [showFromRegistration] /
/// [showFromOtpList] after a response and nothing else changes.
class OtpPushNotifier {
  OtpPushNotifier._();

  static OverlayEntry? _entry;
  static Timer? _timer;
  static final List<_Pending> _queue = [];

  /// `POST /country-codes/user-registration` -> `data.{mobileOtp,emailOtp}`.
  static void showFromRegistration(dynamic json) {
    final data = json is Map ? (json['data'] ?? json) : null;
    if (data is! Map) return;
    final mobile = data['mobileOtp']?.toString();
    final email = data['emailOtp']?.toString();
    if (mobile != null && mobile.isNotEmpty) {
      showOtp(otp: mobile, isMobile: true);
    }
    if (email != null && email.isNotEmpty) {
      showOtp(otp: email, isMobile: false);
    }
  }

  /// registration-check resume -> `data.otps: [{identifier: M|E, otp}]`.
  static void showFromOtpList(dynamic otps) {
    if (otps is! List) return;
    for (final item in otps) {
      if (item is! Map) continue;
      final otp = item['otp']?.toString();
      if (otp == null || otp.isEmpty) continue;
      showOtp(otp: otp, isMobile: item['identifier'] != 'E');
    }
  }

  // ---------------------------------------------------------------------
  // System (notification shade) delivery — in addition to the banner.
  // ---------------------------------------------------------------------

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static Future<bool>? _systemReady;
  static int _notificationId = 0;

  static Future<bool> _initSystem() async {
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
      );
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await android?.requestNotificationsPermission();
      return true;
    } catch (e) {
      debugPrint('[OtpPush] system notifications unavailable: $e');
      return false;
    }
  }

  static Future<void> _notifySystem(String otp, bool isMobile) async {
    final ready = await (_systemReady ??= _initSystem());
    if (!ready) return;
    try {
      await _plugin.show(
        id: _notificationId++,
        title: isMobile ? 'Mobile verification code' : 'Email verification code',
        body: 'Your NivaasHub OTP is $otp',
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'otp_channel',
            'Verification codes',
            channelDescription: 'One-time passwords for NivaasHub sign-up',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'OTP',
          ),
        ),
      );
    } catch (e) {
      debugPrint('[OtpPush] could not show system notification: $e');
    }
  }

  /// Queued one after another so two OTPs never overlap.
  static void showOtp({required String otp, required bool isMobile}) {
    unawaited(_notifySystem(otp, isMobile));
    _queue.add(_Pending(otp, isMobile));
    if (_entry == null) _next();
  }

  static void _next() {
    if (_queue.isEmpty) return;
    final overlay = NavigationService.navigatorKey.currentState?.overlay;
    if (overlay == null) {
      _queue.clear();
      return;
    }
    final item = _queue.removeAt(0);
    late final OverlayEntry entry;
    void close() {
      _timer?.cancel();
      if (_entry == entry) {
        entry.remove();
        _entry = null;
        _next();
      }
    }

    entry = OverlayEntry(builder: (_) => _OtpBanner(item: item, onClose: close));
    _entry = entry;
    overlay.insert(entry);
    _timer = Timer(const Duration(seconds: 9), close);
  }
}

class _Pending {
  _Pending(this.otp, this.isMobile);
  final String otp;
  final bool isMobile;
}

class _OtpBanner extends StatefulWidget {
  const _OtpBanner({required this.item, required this.onClose});

  final _Pending item;
  final VoidCallback onClose;

  @override
  State<_OtpBanner> createState() => _OtpBannerState();
}

class _OtpBannerState extends State<_OtpBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 380),
  )..forward();
  final Key _dismissKey = UniqueKey();
  bool _copied = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.item.otp));
    if (mounted) setState(() => _copied = true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final item = widget.item;
    final title =
        item.isMobile ? 'Mobile verification code' : 'Email verification code';
    final icon = item.isMobile ? Icons.sms_rounded : Icons.mail_rounded;
    final accent =
        item.isMobile ? const Color(0xFF2E5AAC) : const Color(0xFF6A4CD0);
    final accentLight =
        item.isMobile ? const Color(0xFF5B7FD6) : const Color(0xFF9A7BF0);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1.4),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
          ),
          child: FadeTransition(
            opacity: _controller,
            child: Dismissible(
              key: _dismissKey,
              direction: DismissDirection.up,
              onDismissed: (_) => widget.onClose(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2230) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? Colors.white12 : Colors.black12,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.5 : 0.18,
                          ),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [accent, accentLight],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(icon, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'NivaasHub',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.6,
                                      color: isDark
                                          ? Colors.white54
                                          : Colors.black45,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'now',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark
                                          ? Colors.white38
                                          : Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.otp.split('').join(' '),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2,
                                  color: accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _copy,
                          icon: Icon(
                            _copied ? Icons.check_rounded : Icons.copy_rounded,
                            size: 16,
                          ),
                          label: Text(_copied ? 'Copied' : 'Copy'),
                          style: TextButton.styleFrom(
                            foregroundColor: accent,
                            backgroundColor: accent.withValues(alpha: 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
