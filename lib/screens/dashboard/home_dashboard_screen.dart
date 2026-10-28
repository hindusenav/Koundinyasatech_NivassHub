import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_state.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';
import 'package:flutter_nivasshub/widgets/dashboard/dashboard_body.dart';
import 'package:flutter_nivasshub/widgets/dashboard/loading/dashboard_loading_widget.dart';
import 'package:flutter_nivasshub/widgets/dashboard/error/dashboard_error_widget.dart';
import 'package:flutter_nivasshub/widgets/dashboard/empty/dashboard_empty_widget.dart';

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

  bool _kycStatusLoaded = false;
  bool _kycApproved = false;

  // ============================================================
  // COLORS
  // ============================================================


  static final Color _backgroundColorLight =
      FigmaTheme.light.page;

  static final Color _backgroundColorDark =
      FigmaTheme.dark.page;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadKycStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final dashboard = context.read<DashboardProvider>();
      if (dashboard.state == DashboardState.initial) {
        dashboard.loadDashboard();
      }
    });
  }

  // ============================================================
  // LOAD KYC STATUS
  // ============================================================

  Future<void> _loadKycStatus() async {
    final approved =
        await context.read<SecureStorageService>().isKycApproved();

    if (!mounted) return;

    setState(() {
      _kycApproved = approved;
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


        final backgroundColor =
            isDark
                ? _backgroundColorDark
                : _backgroundColorLight;

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            // Sage header in light mode (dark icons), navy in dark mode.
            statusBarIconBrightness:
                Brightness.light,
            statusBarBrightness:
                Brightness.dark,
            systemNavigationBarColor:
                isDark ? backgroundColor : AppColors.navDark,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
        );

        return Scaffold(
          backgroundColor: backgroundColor,

          body: Container(
            width: double.infinity,
            color: backgroundColor,

            child: SafeArea(
              top: false,
              left: false,
              right: false,
              bottom: false,

              child: _buildBody(provider),
            ),
          ),

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

return DashboardBody(showKycCard: !_kycApproved);
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