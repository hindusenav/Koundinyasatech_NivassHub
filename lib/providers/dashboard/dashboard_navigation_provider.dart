// import 'package:flutter/material.dart';

// import 'package:flutter_nivasshub/routes/app_routes.dart';

// class DashboardNavigationProvider extends ChangeNotifier {
//   int _selectedIndex = 0;

//   int get selectedIndex => _selectedIndex;

//   void changeIndex(int index) {
//     if (_selectedIndex == index) return;

//     _selectedIndex = index;
//     notifyListeners();
//   }
// }

// /// Keeps [DashboardNavigationProvider.selectedIndex] in sync with whatever
// /// route the Navigator is actually showing, instead of relying on the
// /// bottom nav's tap handler alone. This is what makes the highlighted tab
// /// correct after system/emulator Back (e.g. Community -> Back -> Home
// /// re-highlights Home because Home's route becomes current again — not
// /// because a tap told it to).
// class DashboardNavObserver extends NavigatorObserver {
//   DashboardNavObserver(this._navigationProvider);

//   final DashboardNavigationProvider _navigationProvider;

//   void _syncWith(Route<dynamic>? route) {
//     switch (route?.settings.name) {
//       case AppRoutes.dashboard:
//         _navigationProvider.changeIndex(0);
//         break;
//       case AppRoutes.noticeList:
//         _navigationProvider.changeIndex(2);
//         break;
//     }
//   }

//   @override
//   void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     _syncWith(route);
//   }

//   @override
//   void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     _syncWith(previousRoute);
//   }

//   @override
//   void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
//     _syncWith(newRoute);
//   }
// }

///////////////////////

import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/routes/app_routes.dart';

class DashboardNavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void changeIndex(int index) {
    if (_selectedIndex == index) return;

    _selectedIndex = index;
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
      case AppRoutes.settings:
      case AppRoutes.profile:
      case AppRoutes.editProfile:
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
