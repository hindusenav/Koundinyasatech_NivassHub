// import 'package:flutter/material.dart';
// import 'package:flutter_nivasshub/routes/app_routes.dart';

// /// Enables navigation from outside the widget tree — e.g. an [Interceptor]
// /// reacting to a 401 by returning to the login screen — via a global
// /// [navigatorKey] instead of a [BuildContext]. Register [navigatorKey] on
// /// the app's `MaterialApp`.
// class NavigationService {
//   NavigationService._();

//   static final GlobalKey<NavigatorState> navigatorKey =
//       GlobalKey<NavigatorState>();

//   static BuildContext? get context => navigatorKey.currentContext;

//   static Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
//     return navigatorKey.currentState!.pushNamed<T>(
//       routeName,
//       arguments: arguments,
//     );
//   }

//   static Future<T?> pushReplacementNamed<T, TO>(
//     String routeName, {
//     Object? arguments,
//   }) {
//     return navigatorKey.currentState!.pushReplacementNamed<T, TO>(
//       routeName,
//       arguments: arguments,
//     );
//   }

//   static Future<T?> pushNamedAndRemoveUntil<T>(
//     String routeName, {
//     Object? arguments,
//   }) {
//     return navigatorKey.currentState!.pushNamedAndRemoveUntil<T>(
//       routeName,
//       (route) => false,
//       arguments: arguments,
//     );
//   }

//   static void pop<T>([T? result]) {
//     if (navigatorKey.currentState?.canPop() ?? false) {
//       navigatorKey.currentState!.pop<T>(result);
//     }
//   }

//   /// Convenience for `AuthInterceptor`'s `onUnauthorized` callback — clears
//   /// the navigation stack and returns to the login screen.
//   static Future<void> logoutAndRedirectToLogin() {
//     return pushNamedAndRemoveUntil(AppRoutes.login);
//   }
// }

/////////////////////////////////////////////////////////

import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enables navigation from outside the widget tree — e.g. an [Interceptor]
/// reacting to a 401 by returning to the login screen — via a global
/// [navigatorKey] instead of a [BuildContext]. Register [navigatorKey] on
/// the app's `MaterialApp`.
class NavigationService {
  NavigationService._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  static Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> pushReplacementNamed<T, TO>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> pushNamedAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void pop<T>([T? result]) {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState!.pop<T>(result);
    }
  }

  /// Convenience for `AuthInterceptor`'s `onUnauthorized` callback — clears
  /// the navigation stack and returns to the login screen.
  static Future<void> logoutAndRedirectToLogin() {
    return pushNamedAndRemoveUntil(AppRoutes.login);
  }

  /// ✅ NEW: Check if user has valid token
  static Future<bool> hasValidToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      return token != null && token.isNotEmpty;
    } catch (e) {
      debugPrint('[Navigation] Error checking token: $e');
      return false;
    }
  }

  /// ✅ NEW: Check authentication and redirect to appropriate screen
  static Future<void> checkAuthenticationAndRedirect() async {
    final hasToken = await hasValidToken();
    if (hasToken) {
      await pushReplacementNamed(AppRoutes.dashboard);
    } else {
      await pushReplacementNamed(AppRoutes.login);
    }
  }
}
