import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/screens/auth/create_profile_screen.dart';
import 'package:flutter_nivasshub/screens/auth/forgot_password_email_screen.dart';
import 'package:flutter_nivasshub/screens/auth/forgot_password_mobile_screen.dart';
import 'package:flutter_nivasshub/screens/auth/forgot_password_options_screen.dart';
import 'package:flutter_nivasshub/screens/auth/forgot_password_verify_otp_screen.dart';
import 'package:flutter_nivasshub/screens/auth/login_screen.dart';
import 'package:flutter_nivasshub/screens/auth/otp_verification_screen.dart';
import 'package:flutter_nivasshub/screens/auth/otp_verification_success_screen.dart';
import 'package:flutter_nivasshub/screens/auth/register_screen.dart';
import 'package:flutter_nivasshub/screens/auth/update_password_screen.dart';
import 'package:flutter_nivasshub/screens/onboarding/onboarding_screen_two.dart';
import 'package:flutter_nivasshub/screens/splash/splash_screen.dart';
import 'package:flutter_nivasshub/screens/welcome/welcome_screen.dart';

import 'package:flutter_nivasshub/routes/app_routes.dart';

/// Pre-authentication navigation: splash → welcome/onboarding → login →
/// OTP → create profile. Tried first by [MaterialApp.onGenerateRoute]; falls
/// through (returns `null`) to [AppRouter] for anything it doesn't handle.
class AuthRouter {
  AuthRouter._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
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
            mobileNumber: args.mobileNumber,
            otpExpirySeconds: args.otpExpirySeconds,
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
          builder: (_) =>
              CreateProfileScreen(registrationToken: args.registrationToken),
        );

      // ========================================================
      // FORGOT PASSWORD
      // ========================================================

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ForgotPasswordOptionsScreen(),
        );

      case AppRoutes.forgotPasswordMobile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ForgotPasswordMobileScreen(),
        );

      case AppRoutes.forgotPasswordEmail:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ForgotPasswordEmailScreen(),
        );

      case AppRoutes.forgotPasswordVerifyOtp:
        final args = settings.arguments;

        if (args is! ForgotPasswordVerifyOtpScreenArgs) {
          return _unknownRoute(settings);
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ForgotPasswordVerifyOtpScreen(
            identifier: args.identifier,
            channel: args.channel,
          ),
        );

      case AppRoutes.updatePassword:
        final args = settings.arguments;

        if (args is! UpdatePasswordScreenArgs) {
          return _unknownRoute(settings);
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => UpdatePasswordScreen(fpToken: args.fpToken),
        );

      default:
        return null;
    }
  }

  // ============================================================
  // UNKNOWN ROUTE
  // ============================================================

  static Route<dynamic> _unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(child: Text('No route defined for "${settings.name}"')),
      ),
    );
  }
}
