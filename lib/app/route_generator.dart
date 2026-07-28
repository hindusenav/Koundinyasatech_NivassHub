import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import 'app_routes.dart';

/// Central `onGenerateRoute` for the app. As each feature's screens are
/// built, add its cases here — this stays the single place that maps a
/// route name to the screen that renders it. Unknown routes fall back to a
/// "page not found" screen instead of crashing.
class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );
      case AppRoutes.dashboard:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const DashboardScreen(),
        );
      // Additional feature route cases are added here as their screens land.
      default:
        return _unknownRoute(settings);
    }
  }

  static Route<dynamic> _unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Page not found')),
        body: Center(
          child: Text('No route defined for "${settings.name}"'),
        ),
      ),
    );
  }
}
