import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xffF5F7FA),

          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: provider.refresh,
              child: _buildBody(provider),
            ),
          ),

          // ✅ Step 7.10.4
          bottomNavigationBar: const DashboardBottomNavigation(),
        );
      },
    );
  }

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