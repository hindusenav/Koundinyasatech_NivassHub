import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_state.dart';
import 'package:flutter_nivasshub/widgets/dashboard/dashboard_body.dart';
import 'package:flutter_nivasshub/widgets/dashboard/loading/dashboard_loading_widget.dart';
import 'package:flutter_nivasshub/widgets/dashboard/error/dashboard_error_widget.dart';
import 'package:flutter_nivasshub/widgets/dashboard/empty/dashboard_empty_widget.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({
    super.key,
  });

  // ============================================================
  // COLORS
  // ============================================================

  static const Color _headerBlueLight = AppColors.dashboardHeaderLight;
  static const Color _headerBlueDark = AppColors.dashboardHeaderDark;
  static const Color _backgroundColorLight = AppColors.dashboardBackgroundLight;
  static const Color _backgroundColorDark = AppColors.dashboardBackgroundDark;

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final headerBlue = isDark ? _headerBlueDark : _headerBlueLight;
        final backgroundColor =
            isDark ? _backgroundColorDark : _backgroundColorLight;

        // ========================================================
        // SYSTEM UI
        // ========================================================

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: headerBlue,
            statusBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,

            systemNavigationBarColor: backgroundColor,
            systemNavigationBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
          ),
        );

        return Scaffold(
          backgroundColor: backgroundColor,

          // ======================================================
          // MAIN BODY
          // ======================================================

          body: Container(
            width: double.infinity,
            color: headerBlue,

            child: SafeArea(
              // ==================================================
              // IMPORTANT
              //
              // TOP SafeArea = YES
              // LEFT SafeArea = NO
              // RIGHT SafeArea = NO
              // BOTTOM SafeArea = NO
              //
              // This removes the white/cream gaps on both sides.
              // ==================================================

              top: true,
              left: false,
              right: false,
              bottom: false,

              child: RefreshIndicator(
                color: isDark ? AppColors.primaryLight : const Color(0xFF1976D2),
                backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
                onRefresh: provider.refresh,
                child: _buildBody(provider),
              ),
            ),
          ),

          // ======================================================
          // BOTTOM NAVIGATION
          // ======================================================

          bottomNavigationBar: const DashboardBottomNavigation(),
        );
      },
    );
  }

  // ==============================================================
  // DASHBOARD STATE
  // ==============================================================

  Widget _buildBody(DashboardProvider provider) {
    switch (provider.state) {
      case DashboardState.loading:
        return const DashboardLoadingWidget();

      case DashboardState.success:
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