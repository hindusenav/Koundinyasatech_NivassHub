import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/string_constants.dart';
import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../shared/widgets/cards/dashboard_card.dart';
import '../../../shared/widgets/loaders/shimmer_loader.dart';
import '../../../shared/widgets/states/custom_error_widget.dart';
import '../provider/dashboard_provider.dart';
import '../widgets/dashboard_welcome_header.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        showBackButton: false,
        actions: [
          IconButton(
            icon: Icon(AppIcons.notification),
            onPressed: () {},
          ),
          
        ],
      ),
      body: RefreshIndicator(
        onRefresh: dashboardProvider.refresh,
        child: _buildBody(context, dashboardProvider),
      ),
    );
  }

  Widget _buildBody(BuildContext context, DashboardProvider provider) {
    if (provider.isLoading && provider.summary == null) {
      return const ShimmerListPlaceholder();
    }

    if (provider.hasError && provider.summary == null) {
      return CustomErrorWidget(
        message: provider.errorMessage ?? StringConstants.somethingWentWrong,
        onRetry: provider.refresh,
      );
    }

    final summary = provider.summary;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardWelcomeHeader(),
          AppSpacing.gapLg,
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.4,
            children: [
              DashboardCard(
                title: 'Residents',
                value: '${summary?.totalResidents ?? 0}',
                icon: AppIcons.resident,
                color: AppColors.primary,
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.residentList),
              ),
              DashboardCard(
                title: 'Visitors Today',
                value: '${summary?.totalVisitorsToday ?? 0}',
                icon: AppIcons.visitor,
                color: AppColors.secondary,
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.visitorList),
              ),
              DashboardCard(
                title: 'Open Complaints',
                value: '${summary?.openComplaints ?? 0}',
                icon: AppIcons.complaint,
                color: AppColors.warning,
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.complaintList),
              ),
              DashboardCard(
                title: 'Active Notices',
                value: '${summary?.activeNotices ?? 0}',
                icon: AppIcons.notice,
                color: AppColors.info,
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.noticeList),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
