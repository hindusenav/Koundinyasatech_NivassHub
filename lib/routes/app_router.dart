import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/core/api/base_api.dart';

import 'package:flutter_nivasshub/screens/dashboard/home_dashboard_screen.dart';
import 'package:flutter_nivasshub/screens/notices/notices_screen.dart';
import 'package:flutter_nivasshub/screens/notifications/delivery_details_screen.dart';
import 'package:flutter_nivasshub/screens/profile/add_address_details_screen.dart';
import 'package:flutter_nivasshub/screens/profile/profile_screen.dart';
import 'package:flutter_nivasshub/screens/quick_actions/quick_actions_screen.dart';
import 'package:flutter_nivasshub/screens/search/search_screen.dart';
import 'package:flutter_nivasshub/screens/settings/help_support_screen.dart';
import 'package:flutter_nivasshub/screens/settings/settings_screen.dart';
import 'package:flutter_nivasshub/screens/visitor/activities_screen.dart';

import 'package:flutter_nivasshub/routes/app_routes.dart';

/// Post-authentication navigation: dashboard and everything reachable from
/// it. Tried after [AuthRouter] by [MaterialApp.onGenerateRoute] — since
/// it's the last stop, an unmatched route here renders the "not found" page
/// instead of falling through further.
class AppRouter {
  AppRouter._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
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
      // ADD ADDRESS DETAILS
      // ========================================================

      case AppRoutes.addAddressDetails:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AddAddressDetailsScreen(address: null),
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
      // VISITOR LIST ✅ ADD THIS
      // ========================================================

      case AppRoutes.visitorList:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ActivitiesScreen(),
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
