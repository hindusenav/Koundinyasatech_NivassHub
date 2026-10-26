import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/services/connectivity/connectivity_service.dart';

/// Tracks whether the app currently has real internet access, backing the
/// app-wide [NoInternetOverlay]. Never trusts the OS adapter/radio status
/// alone — every "back online" signal is confirmed with a genuine
/// reachability probe (see [ConnectivityService.hasInternetAccess]) before
/// [isOffline] flips back to `false`.
class ConnectivityProvider extends ChangeNotifier {
  ConnectivityProvider({
    required ConnectivityService connectivityService,
    this.failureRetryDelay = const Duration(seconds: 2),
    this.offlineRecheckInterval = const Duration(seconds: 6),
  }) : _connectivityService = connectivityService {
    _init();
  }

  /// Pause before the confirming second probe. A single failed probe (a
  /// Wi-Fi/mobile handoff, one slow DNS answer) must not flash the overlay.
  final Duration failureRetryDelay;

  /// While offline, how often to re-probe so the overlay clears by itself.
  final Duration offlineRecheckInterval;

  final ConnectivityService _connectivityService;
  StreamSubscription<bool>? _subscription;
  Timer? _recheckTimer;
  bool _disposed = false;

  // Each verification takes a ticket; only the newest one may apply its
  // result, so a slow stale probe can never overwrite a fresher answer.
  int _verifyTicket = 0;

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
  if (_currentRouteName == routeName) {
    return;
  }

  _currentRouteName = routeName;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (hasListeners) {
      notifyListeners();
    }
  });
}

  void _init() {
    _subscription =
        _connectivityService.onConnectivityChanged.listen(_onAdapterChanged);
    unawaited(_verify());
  }

  Future<void> _onAdapterChanged(bool hasAdapterConnection) async {
    // Adapter events flap during network handoffs, so even "no radio" is
    // confirmed by the debounced probe rather than flipping offline at once.
    await _verify();
  }

  /// Probes reachability. A failure is only believed after a second probe
  /// (after [failureRetryDelay]) also fails, unless [confirmFailure] is
  /// false (a user-initiated check, which should answer immediately).
  Future<bool> _verify({bool confirmFailure = true}) async {
    final ticket = ++_verifyTicket;

    var hasInternet = await _connectivityService.hasInternetAccess();
    if (!hasInternet && confirmFailure) {
      if (ticket != _verifyTicket || _disposed) return hasInternet;
      await Future<void>.delayed(failureRetryDelay);
      if (ticket != _verifyTicket || _disposed) return hasInternet;
      hasInternet = await _connectivityService.hasInternetAccess();
    }

    // A newer check superseded this one; let it decide.
    if (ticket != _verifyTicket || _disposed) return hasInternet;
    _setOffline(!hasInternet);
    return hasInternet;
  }

  void _setOffline(bool value) {
    if (_isOffline == value) return;
    _isOffline = value;
    if (value) {
      _recheckTimer?.cancel();
      _recheckTimer = Timer.periodic(offlineRecheckInterval, (_) {
        if (!_isChecking) unawaited(_verify(confirmFailure: false));
      });
    } else {
      _recheckTimer?.cancel();
      _recheckTimer = null;
    }
    notifyListeners();
  }

  /// Runs a fresh reachability check, used by both the "Try Again" and
  /// "Check Connection" actions. Returns whether internet is available.
  Future<bool> checkConnection() async {
    _isChecking = true;
    notifyListeners();

    final hasInternet = await _verify(confirmFailure: false);

    _isChecking = false;
    if (!_disposed) notifyListeners();

    return hasInternet;
  }

  @override
  void dispose() {
    _disposed = true;
    _recheckTimer?.cancel();
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
