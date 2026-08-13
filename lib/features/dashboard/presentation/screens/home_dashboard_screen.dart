import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/dashboard_provider.dart';
import '../provider/dashboard_state.dart';
import '../widgets/dashboard_body.dart';
import '../widgets/loading/dashboard_loading_widget.dart';
import '../widgets/error/dashboard_error_widget.dart';
import '../widgets/empty/dashboard_empty_widget.dart';
import '../widgets/navigation/dashboard_bottom_navigation.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({
    super.key,
  });

  // ============================================================
  // COLORS
  // ============================================================

  static const Color _headerBlue = Color(0xFFC7E1F8);
  static const Color _backgroundColor = Color(0xFFF8F3E9);

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        // ========================================================
        // SYSTEM UI
        // ========================================================

        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: _headerBlue,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,

            systemNavigationBarColor: _backgroundColor,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        );

        return Scaffold(
          backgroundColor: _backgroundColor,

          // ======================================================
          // MAIN BODY
          // ======================================================

          body: Container(
            width: double.infinity,
            color: _headerBlue,

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
                color: const Color(0xFF1976D2),
                backgroundColor: Colors.white,
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