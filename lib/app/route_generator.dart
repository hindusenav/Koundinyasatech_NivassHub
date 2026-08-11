import 'package:flutter/material.dart';
import '../features/auth/screens/create_profile_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/otp_verification_screen.dart';
import '../features/auth/screens/otp_verification_success_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/dashboard/presentation/screens/home_dashboard_screen.dart';
import '../features/onboarding/screens/onboarding_screen_two.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/quick_actions/screens/quick_actions_screen.dart';
import '../features/search/screens/search_screen.dart';
import '../features/settings/screens/help_support_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import '../features/visitor/screens/activities_screen.dart';
import '../features/welcome/screens/welcome_screen.dart';
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
      case AppRoutes.welcome:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const WelcomeScreen(),
        );
      case AppRoutes.onboardingStepTwo:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OnboardingScreenTwo(),
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );
      case AppRoutes.register:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RegisterScreen(),
        );
      case AppRoutes.otpVerification:
        final args = settings.arguments;
        if (args is! OtpVerificationScreenArgs) return _unknownRoute(settings);
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => OtpVerificationScreen(
            mobileNumber: args.mobileNumber,
            otpExpirySeconds: args.otpExpirySeconds,
            isRegistrationFlow: args.isRegistrationFlow,
          ),
        );
      case AppRoutes.otpVerificationSuccess:
        final args = settings.arguments;
        if (args is! OtpVerificationSuccessScreenArgs) return _unknownRoute(settings);
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => OtpVerificationSuccessScreen(
            userExists: args.userExists,
            registrationToken: args.registrationToken,
          ),
        );
      case AppRoutes.createProfile:
        final args = settings.arguments;
        if (args is! CreateProfileScreenArgs) return _unknownRoute(settings);
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CreateProfileScreen(registrationToken: args.registrationToken),
        );
      case AppRoutes.dashboard:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeDashboardScreen(),
        );
      case AppRoutes.quickActions:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const QuickActionsScreen(),
        );
      case AppRoutes.search:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SearchScreen(),
        );
      case AppRoutes.profile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProfileScreen(),
        );
      case AppRoutes.settings:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SettingsScreen(),
        );
      case AppRoutes.helpSupport:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HelpSupportScreen(),
        );
      case AppRoutes.activities:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ActivitiesScreen(),
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
