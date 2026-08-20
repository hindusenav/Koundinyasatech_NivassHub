import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/services/core/api_client.dart';

// ============================================================
// AUTH
// ============================================================

import 'package:flutter_nivasshub/screens/auth/create_profile_screen.dart';
import 'package:flutter_nivasshub/screens/auth/login_screen.dart';
import 'package:flutter_nivasshub/screens/auth/otp_verification_screen.dart';
import 'package:flutter_nivasshub/screens/auth/otp_verification_success_screen.dart';
import 'package:flutter_nivasshub/screens/auth/register_screen.dart';

// ============================================================
// DASHBOARD
// ============================================================

import 'package:flutter_nivasshub/screens/dashboard/home_dashboard_screen.dart';

// ============================================================
// NOTICES
// ============================================================

import 'package:flutter_nivasshub/screens/notices/notices_screen.dart';
import 'package:flutter_nivasshub/screens/notifications/delivery_details_screen.dart';

// ============================================================
// ONBOARDING
// ============================================================

import 'package:flutter_nivasshub/screens/onboarding/onboarding_screen_two.dart';

// ============================================================
// PROFILE - ✅ Make sure these are here
// ============================================================

import 'package:flutter_nivasshub/screens/profile/add_address_details_screen.dart';  // ✅ THIS IMPORT
import 'package:flutter_nivasshub/screens/profile/profile_screen.dart';

// ============================================================
// QUICK ACTIONS
// ============================================================

import 'package:flutter_nivasshub/screens/quick_actions/quick_actions_screen.dart';

// ============================================================
// SEARCH
// ============================================================

import 'package:flutter_nivasshub/screens/search/search_screen.dart';

// ============================================================
// SETTINGS
// ============================================================

import 'package:flutter_nivasshub/screens/settings/help_support_screen.dart';
import 'package:flutter_nivasshub/screens/settings/settings_screen.dart';

// ============================================================
// SPLASH
// ============================================================

import 'package:flutter_nivasshub/screens/splash/splash_screen.dart';

// ============================================================
// VISITOR
// ============================================================

import 'package:flutter_nivasshub/screens/visitor/activities_screen.dart';

// ============================================================
// WELCOME
// ============================================================

import 'package:flutter_nivasshub/screens/welcome/welcome_screen.dart';

import 'package:flutter_nivasshub/routes/app_routes.dart';

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
            isRegistrationFlow: args.isRegistrationFlow,
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
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AddAddressDetailsScreen(
            address: null, // Pass null, handle in screen
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