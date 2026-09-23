import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/models/location/location_level.dart';
import 'package:flutter_nivasshub/providers/auth/auth_entry_provider.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/providers/auth/enter_password_provider.dart';
import 'package:flutter_nivasshub/providers/auth/otp_mobile_email_verification_provider.dart';
import 'package:flutter_nivasshub/providers/auth/user_details_provider.dart';
import 'package:flutter_nivasshub/providers/kyc/kyc_status_provider.dart';
import 'package:flutter_nivasshub/providers/location/location_provider.dart';
import 'package:flutter_nivasshub/providers/registration/registration_master_data_provider.dart';
import 'package:flutter_nivasshub/providers/society/society_details_provider.dart';
import 'package:flutter_nivasshub/screens/auth/auth_entry_screen.dart';
import 'package:flutter_nivasshub/screens/auth/enter_password_screen.dart';
import 'package:flutter_nivasshub/screens/auth/otp_mobile_email_verification_screen.dart';
import 'package:flutter_nivasshub/screens/auth/user_details_screen.dart';
import 'package:flutter_nivasshub/screens/kyc/kyc_documents_screen.dart';
import 'package:flutter_nivasshub/screens/kyc/kyc_verification_status_screen.dart';
import 'package:flutter_nivasshub/screens/notifications/mock_notification_log_screen.dart';
import 'package:flutter_nivasshub/services/auth/auth_entry_service_base.dart';
import 'package:flutter_nivasshub/services/auth/otp_verification_service_base.dart';
import 'package:flutter_nivasshub/services/country/country_service_base.dart';
import 'package:flutter_nivasshub/services/kyc/kyc_service_base.dart';
import 'package:flutter_nivasshub/services/location/location_service_base.dart';
import 'package:flutter_nivasshub/services/registration/registration_service_base.dart';
import 'package:flutter_nivasshub/services/society/society_service_base.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';

import 'package:flutter_nivasshub/screens/auth/forgot_password_email_screen.dart';
import 'package:flutter_nivasshub/screens/auth/forgot_password_mobile_screen.dart';
import 'package:flutter_nivasshub/screens/auth/forgot_password_options_screen.dart';
import 'package:flutter_nivasshub/screens/auth/forgot_password_verify_otp_screen.dart';
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
      // AUTHENTICATION ENTRY (identifier-first)
      // ========================================================

      case AppRoutes.authEntry:
        final args = settings.arguments;

        // Unlike the other routes here, entry is reachable with no
        // arguments — from splash, onboarding and logout — so a missing
        // argument is the norm rather than a caller bug.
        if (args != null && args is! AuthEntryScreenArgs) {
          return _unknownRoute(settings);
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            final entryArgs =
                args as AuthEntryScreenArgs? ?? const AuthEntryScreenArgs();
            return ChangeNotifierProvider(
              // The dial-code fetch starts here rather than in the
              // screen's `initState`: it notifies before its first
              // `await`, and at creation time the provider has no
              // listeners yet, so nothing can be marked dirty mid-build.
              create: (_) => AuthEntryProvider(
                authService: context.read<AuthEntryServiceBase>(),
                countryService: context.read<CountryServiceBase>(),
                initialChannel: entryArgs.prefillChannel ?? AuthChannel.mobile,
              )..loadCountryCodes(),
              child: AuthEntryScreen(args: entryArgs),
            );
          },
        );

      // ========================================================
      // ENTER PASSWORD (existing user)
      // ========================================================

      case AppRoutes.enterPassword:
        final args = settings.arguments;

        if (args is! EnterPasswordScreenArgs) {
          return _unknownRoute(settings);
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (context) => ChangeNotifierProvider(
            create: (_) => EnterPasswordProvider(
              authService: context.read<AuthEntryServiceBase>(),
              authState: context.read<AuthStateProvider>(),
            ),
            child: EnterPasswordScreen(args: args),
          ),
        );

      // ========================================================
      // USER DETAILS (new user registration)
      // ========================================================

      case AppRoutes.userDetails:
        final args = settings.arguments;

        if (args is! UserDetailsScreenArgs) {
          return _unknownRoute(settings);
        }

        return MaterialPageRoute(
          settings: settings,
          // The cascade and the form are separate providers so a future
          // "add another flat" screen can reuse `LocationProvider` alone.
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                // Fetch starts at creation, before anything is listening —
                // starting it from a descendant's `initState` instead
                // notified listeners mid-build. Country now sources from
                // the registration master-data endpoint, not the
                // dial-code-only `/country-codes`.
                create: (_) => LocationProvider(
                  context.read<LocationServiceBase>(),
                  countryService: context.read<RegistrationServiceBase>(),
                )..load(LocationLevel.country),
              ),
              ChangeNotifierProvider(
                create: (_) => RegistrationMasterDataProvider(
                  context.read<RegistrationServiceBase>(),
                )..load(),
              ),
              ChangeNotifierProvider(
                create: (_) =>
                    SocietyDetailsProvider(context.read<SocietyServiceBase>()),
              ),
              ChangeNotifierProvider(
                create: (_) => UserDetailsProvider(
                  registrationService: context.read<RegistrationServiceBase>(),
                ),
              ),
            ],
            child: UserDetailsScreen(args: args),
          ),
        );

      // ========================================================
      // OTP VERIFICATION (mobile + email, post-registration)
      // ========================================================

      case AppRoutes.otpMobileEmailVerification:
        final args = settings.arguments;

        if (args is! OtpMobileEmailVerificationScreenArgs) {
          return _unknownRoute(settings);
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (context) => ChangeNotifierProvider(
            create: (_) => OtpMobileEmailVerificationProvider(
              service: context.read<OtpVerificationServiceBase>(),
              userId: args.userId,
              mobileNumber: args.mobileNumber,
              email: args.email,
            ),
            child: OtpMobileEmailVerificationScreen(args: args),
          ),
        );

      // ========================================================
      // KYC — role-based documents
      //
      // Registered here rather than in AppRouter because KYC now gates
      // the Dashboard; these screens run before authentication, not
      // after it.
      // ========================================================

      case AppRoutes.kycDocuments:
        final args = settings.arguments;

        if (args is! KycDocumentsScreenArgs) {
          return _unknownRoute(settings);
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => KycDocumentsScreen(args: args),
        );

      case AppRoutes.kycVerificationStatus:
        final args = settings.arguments;

        if (args is! KycVerificationStatusScreenArgs) {
          return _unknownRoute(settings);
        }

        return MaterialPageRoute(
          settings: settings,
          // Scoped here so its polling timer is cancelled by the route's
          // dispose rather than running on behind the Dashboard.
          builder: (context) => ChangeNotifierProvider(
            create: (_) => KycStatusProvider(
              kycService: context.read<KycServiceBase>(),
              authService: context.read<AuthEntryServiceBase>(),
              authState: context.read<AuthStateProvider>(),
              secureStorage: context.read<SecureStorageService>(),
            ),
            child: KycVerificationStatusScreen(args: args),
          ),
        );

      // ========================================================
      // MOCK NOTIFICATION LOG
      //
      // Reachable both pre-auth (from KYC) and post-auth (from
      // Settings); AuthRouter is tried first, so registering it here
      // covers both.
      // ========================================================

      case AppRoutes.mockNotificationLog:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MockNotificationLogScreen(),
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
