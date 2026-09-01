import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:flutter_nivasshub/routes/app_routes.dart';
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

  // Tracks the currently active route (kept in sync by
  // [ConnectivityRouteObserver]) purely so the splash screen's own
  // entrance/exit animation is never interrupted — `null` means "not
  // observed yet" (the very first frame), which is treated the same as
  // splash so there's never a false flash before the first `didPush` fires.
  String? _currentRouteName;
  bool get isSplashActive =>
      _currentRouteName == null || _currentRouteName == AppRoutes.splash;

  /// Whether [NoInternetOverlay] should currently render the offline
  /// screen — offline, and past the splash screen's own animation.
  bool get shouldShowNoInternetScreen => _isOffline && !isSplashActive;

  void _setCurrentRoute(String? routeName) {
    if (_currentRouteName == routeName) return;
    _currentRouteName = routeName;
    notifyListeners();
  }

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

/// Keeps [ConnectivityProvider] aware of the currently active route, purely
/// so the splash screen's own entrance/exit animation is never interrupted
/// by the offline overlay — mirrors [DashboardNavObserver]'s existing
/// `route.settings.name`-driven pattern (see
/// `providers/dashboard/dashboard_navigation_provider.dart`), which already
/// correctly observes these exact splash → dashboard/login/welcome
/// transitions.
class ConnectivityRouteObserver extends NavigatorObserver {
  ConnectivityRouteObserver(this._connectivityProvider);

  final ConnectivityProvider _connectivityProvider;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _connectivityProvider._setCurrentRoute(route.settings.name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _connectivityProvider._setCurrentRoute(previousRoute?.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _connectivityProvider._setCurrentRoute(newRoute?.settings.name);
  }
}
