import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_state.dart';
import 'package:flutter_nivasshub/widgets/dashboard/dashboard_body.dart';
import 'package:flutter_nivasshub/widgets/dashboard/loading/dashboard_loading_widget.dart';
import 'package:flutter_nivasshub/widgets/dashboard/error/dashboard_error_widget.dart';
import 'package:flutter_nivasshub/widgets/dashboard/empty/dashboard_empty_widget.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({
    super.key,
  });

  @override
  State<HomeDashboardScreen> createState() =>
      _HomeDashboardScreenState();
}

class _HomeDashboardScreenState
    extends State<HomeDashboardScreen> {
  // ============================================================
  // KYC STATUS
  // ============================================================

  bool _kycCompleted = false;
  bool _kycStatusLoaded = false;

  // ============================================================
  // COLORS
  // ============================================================

  static const Color _headerBlueLight =
      AppColors.dashboardHeaderLight;

  static const Color _headerBlueDark =
      AppColors.dashboardHeaderDark;

  static const Color _backgroundColorLight =
      AppColors.dashboardBackgroundLight;

  static const Color _backgroundColorDark =
      AppColors.dashboardBackgroundDark;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadKycStatus();
  }

  // ============================================================
  // LOAD KYC STATUS
  // ============================================================

  Future<void> _loadKycStatus() async {
    final prefs = await SharedPreferences.getInstance();

    final completed =
        prefs.getBool('kyc_completed') ?? false;

    if (!mounted) return;

    setState(() {
      _kycCompleted = completed;
      _kycStatusLoaded = true;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        final isDark =
            Theme.of(context).brightness ==
                Brightness.dark;

        final headerBlue =
            isDark
                ? _headerBlueDark
                : _headerBlueLight;

        final backgroundColor =
            isDark
                ? _backgroundColorDark
                : _backgroundColorLight;

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: headerBlue,
            statusBarIconBrightness:
                isDark
                    ? Brightness.light
                    : Brightness.dark,
            statusBarBrightness:
                isDark
                    ? Brightness.dark
                    : Brightness.light,
            systemNavigationBarColor:
                backgroundColor,
            systemNavigationBarIconBrightness:
                isDark
                    ? Brightness.light
                    : Brightness.dark,
          ),
        );

        return Scaffold(
          backgroundColor: backgroundColor,

          body: Container(
            width: double.infinity,
            color: headerBlue,

            child: SafeArea(
              top: true,
              left: false,
              right: false,
              bottom: false,

              child: _buildBody(provider),
            ),
          ),

          bottomNavigationBar:
              const DashboardBottomNavigation(),
        );
      },
    );
  }

  // ============================================================
  // DASHBOARD STATE
  // ============================================================

  Widget _buildBody(
    DashboardProvider provider,
  ) {
    switch (provider.state) {
      case DashboardState.loading:
        return const DashboardLoadingWidget();

      case DashboardState.success:
        // Wait until KYC status is known.
        // This prevents the KYC card from appearing briefly
        // while SharedPreferences is being loaded.
        if (!_kycStatusLoaded) {
          return const DashboardLoadingWidget();
        }

return const DashboardBody();
      case DashboardState.empty:
        return const DashboardEmptyWidget();

      case DashboardState.error:
        return DashboardErrorWidget(
          message: provider.errorMessage,
          onRetry: provider.loadDashboard,
        );

      case DashboardState.initial:
        return const SizedBox.shrink();
    }
  }
}