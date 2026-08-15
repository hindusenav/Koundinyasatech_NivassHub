import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/network/api_client.dart';

// ============================================================
// AUTH
// ============================================================

import '../features/auth/screens/create_profile_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/otp_verification_screen.dart';
import '../features/auth/screens/otp_verification_success_screen.dart';
import '../features/auth/screens/register_screen.dart';

// ============================================================
// DASHBOARD
// ============================================================

import '../features/dashboard/presentation/screens/home_dashboard_screen.dart';

// ============================================================
// NOTICES
// ============================================================

import '../features/notices/screens/notices_screen.dart';
import '../features/notifications/screens/delivery_details_screen.dart';

// ============================================================
// ONBOARDING
// ============================================================

import '../features/onboarding/screens/onboarding_screen_two.dart';

// ============================================================
// PROFILE - ✅ Make sure these are here
// ============================================================

import '../features/profile/models/address_model.dart';
import '../features/profile/screens/add_address_details_screen.dart';  // ✅ THIS IMPORT
import '../features/profile/screens/profile_screen.dart';

// ============================================================
// QUICK ACTIONS
// ============================================================

import '../features/quick_actions/screens/quick_actions_screen.dart';

// ============================================================
// SEARCH
// ============================================================

import '../features/search/screens/search_screen.dart';

// ============================================================
// SETTINGS
// ============================================================

import '../features/settings/screens/help_support_screen.dart';
import '../features/settings/screens/settings_screen.dart';

// ============================================================
// SPLASH
// ============================================================

import '../features/splash/screens/splash_screen.dart';

// ============================================================
// VISITOR
// ============================================================

import '../features/visitor/screens/activities_screen.dart';

// ============================================================
// WELCOME
// ============================================================

import '../features/welcome/screens/welcome_screen.dart';

import 'app_routes.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      // ========================================================
      // SPLASH
      // ========================================================

      case AppRoutes.splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );

      // ========================================================
      // WELCOME
      // ========================================================

      case AppRoutes.welcome:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const WelcomeScreen(),
        );

      // ========================================================
      // ONBOARDING
      // ========================================================

      case AppRoutes.onboardingStepTwo:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OnboardingScreenTwo(),
        );

      // ========================================================
      // LOGIN
      // ========================================================

      case AppRoutes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );

      // ========================================================
      // REGISTER
      // ========================================================

      case AppRoutes.register:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RegisterScreen(),
        );

      // ========================================================
      // OTP VERIFICATION
      // ========================================================

      case AppRoutes.otpVerification:
        final args = settings.arguments;

        if (args is! OtpVerificationScreenArgs) {
          return _unknownRoute(settings);
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => OtpVerificationScreen(
            mobileNumber: args.mobileNumber,
            otpExpirySeconds: args.otpExpirySeconds,
            isRegistrationFlow: args.isRegistrationFlow,
          ),
        );

      // ========================================================
      // OTP SUCCESS
      // ========================================================

      case AppRoutes.otpVerificationSuccess:
        final args = settings.arguments;

        if (args is! OtpVerificationSuccessScreenArgs) {
          return _unknownRoute(settings);
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => OtpVerificationSuccessScreen(
            userExists: args.userExists,
            registrationToken: args.registrationToken,
          ),
        );

      // ========================================================
      // CREATE PROFILE - AUTH
      // ========================================================

      case AppRoutes.createProfile:
        final args = settings.arguments;

        if (args is! CreateProfileScreenArgs) {
          return _unknownRoute(settings);
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CreateProfileScreen(
            registrationToken: args.registrationToken,
          ),
        );

      // ========================================================
      // DASHBOARD
      // ========================================================

      case AppRoutes.dashboard:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeDashboardScreen(),
        );

      // ========================================================
      // PROFILE
      // ========================================================

      case AppRoutes.profile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProfileScreen(),
        );

      // ========================================================
      // ADD ADDRESS DETAILS - ✅ FIXED
      // ========================================================

     case AppRoutes.addAddressDetails:
  final args = settings.arguments;
  
  // ✅ Simple and clean approach
  final address = args is AddressModel 
      ? args 
      : const AddressModel();

  return MaterialPageRoute(
    settings: settings,
    builder: (_) => const AddAddressDetailsScreen(
      address: null,  // Pass null, handle in screen
    ),
  );
      // ========================================================
      // SETTINGS
      // ========================================================

      case AppRoutes.settings:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SettingsScreen(),
        );

      // ========================================================
      // HELP SUPPORT
      // ========================================================

      case AppRoutes.helpSupport:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HelpSupportScreen(),
        );

      // ========================================================
      // SEARCH
      // ========================================================

      case AppRoutes.search:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SearchScreen(),
        );

      // ========================================================
      // QUICK ACTIONS
      // ========================================================

      case AppRoutes.quickActions:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const QuickActionsScreen(),
        );

      // ========================================================
      // ACTIVITIES
      // ========================================================

      case AppRoutes.activities:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ActivitiesScreen(),
        );
      case AppRoutes.visitorDetail:
        final args = settings.arguments;
        if (args is! DeliveryDetailsScreenArgs) return _unknownRoute(settings);
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => DeliveryDetailsScreen(
            visitorId: args.visitorId,
            notificationProvider: args.notificationProvider,
            onApprove: args.onApprove,
            onReject: args.onReject,
          ),
        );

      // ========================================================
      // NOTICES
      // ========================================================

      case AppRoutes.noticeList:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {

            ApiClient? apiClient;
            try {
              apiClient = context.read<ApiClient>();
            } catch (_) {}
            return NoticesScreen(apiClient: apiClient ?? ApiClient());
          },
        );

      // ========================================================
      // UNKNOWN ROUTE
      // ========================================================

      default:
        return _unknownRoute(settings);
    }
  }

  // ============================================================
  // UNKNOWN ROUTE
  // ============================================================

  static Route<dynamic> _unknownRoute(
    RouteSettings settings,
  ) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Page Not Found',
          ),
        ),
        body: Center(
          child: Text(
            'No route defined for "${settings.name}"',
          ),
        ),
      ),
    );
  }
}