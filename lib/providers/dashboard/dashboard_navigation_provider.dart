import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/routes/app_routes.dart';

class DashboardNavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  String? _currentRoute;

  int get selectedIndex => _selectedIndex;

  /// Name of the page route currently on top of the Navigator.
  String? get currentRoute => _currentRoute;

  /// Whether the persistent bottom bar should be shown: only on the main tab
  /// screens. Sub-pages and flows (settings, auth, KYC, ...) hide it.
  bool get showBottomBar => tabRoutes.contains(_currentRoute);

  /// Top-level screens that live under the persistent bottom bar.
  static const Set<String> tabRoutes = {
    AppRoutes.dashboard,
    AppRoutes.activities,
    AppRoutes.visitorList,
    AppRoutes.noticeList,
    AppRoutes.payments,
    AppRoutes.quickActions,
    AppRoutes.search,
  };

  void changeIndex(int index) {
    if (_selectedIndex == index) return;

    _selectedIndex = index;
    notifyListeners();
  }

  void setCurrentRoute(String? name) {
    if (_currentRoute == name) return;
    _currentRoute = name;
    notifyListeners();
  }
}

/// Keeps [DashboardNavigationProvider.selectedIndex] in sync with whatever
/// route the Navigator is actually showing, instead of relying on the
/// bottom nav's tap handler alone. This is what makes the highlighted tab
/// correct after system/emulator Back (e.g. Community -> Back -> Home
/// re-highlights Home because Home's route becomes current again — not
/// because a tap told it to).
class DashboardNavObserver extends NavigatorObserver {
  DashboardNavObserver(this._navigationProvider);

  final DashboardNavigationProvider _navigationProvider;

  void _syncWith(Route<dynamic>? route) {
    // Dialogs and bottom sheets are routes too; they must not hide the bar
    // or change the selected tab.
    if (route != null && route is! PageRoute) return;

    _navigationProvider.setCurrentRoute(route?.settings.name);
    switch (route?.settings.name) {
      case AppRoutes.dashboard:
        _navigationProvider.changeIndex(0);
        break;
      case AppRoutes.activities:
      case AppRoutes.visitorList:
        _navigationProvider.changeIndex(1);
        break;
      case AppRoutes.noticeList:
        _navigationProvider.changeIndex(2);
        break;
      case AppRoutes.payments:
        _navigationProvider.changeIndex(3);
        break;
      case AppRoutes.quickActions:
      case AppRoutes.settings:
      case AppRoutes.helpSupport:
        _navigationProvider.changeIndex(4);
        break;
      default:
        // Don't change for other routes (like auth, onboarding, etc.)
        break;
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _syncWith(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _syncWith(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _syncWith(newRoute);
  }
}
