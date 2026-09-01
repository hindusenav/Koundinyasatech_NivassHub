import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter_nivasshub/services/core/connectivity_service.dart';

/// Tracks whether the app currently has real internet access, backing the
/// app-wide [NoInternetOverlay]. Never trusts the OS adapter/radio status
/// alone — every "back online" signal is confirmed with a genuine
/// reachability probe (see [ConnectivityService.hasInternetAccess]) before
/// [isOffline] flips back to `false`.
class ConnectivityProvider extends ChangeNotifier {
  ConnectivityProvider({required ConnectivityService connectivityService})
      : _connectivityService = connectivityService {
    _init();
  }

  final ConnectivityService _connectivityService;
  StreamSubscription<bool>? _subscription;

  // Start optimistic so a cold app launch never flashes the offline screen
  // before the first check resolves.
  bool _isOffline = false;
  bool get isOffline => _isOffline;

  bool _isChecking = false;
  bool get isChecking => _isChecking;

  void _init() {
    _subscription =
        _connectivityService.onConnectivityChanged.listen(_onAdapterChanged);
    unawaited(_verify());
  }

  Future<void> _onAdapterChanged(bool hasAdapterConnection) async {
    if (!hasAdapterConnection) {
      // No Wi-Fi/mobile radio at all — definitely offline, no need to probe.
      _setOffline(true);
      return;
    }
    // Radio is on, but that alone doesn't mean there's real internet access.
    await _verify();
  }

  Future<bool> _verify() async {
    final hasInternet = await _connectivityService.hasInternetAccess();
    _setOffline(!hasInternet);
    return hasInternet;
  }

  void _setOffline(bool value) {
    if (_isOffline == value) return;
    _isOffline = value;
    notifyListeners();
  }

  /// Runs a fresh reachability check, used by both the "Try Again" and
  /// "Check Connection" actions. Returns whether internet is available.
  Future<bool> checkConnection() async {
    _isChecking = true;
    notifyListeners();

    final hasInternet = await _verify();

    _isChecking = false;
    notifyListeners();

    return hasInternet;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
