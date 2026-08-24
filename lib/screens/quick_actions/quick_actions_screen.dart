import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/utils/responsive.dart';
import 'package:flutter_nivasshub/models/shared/app_feature_model.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/app_search_bar.dart';
import 'package:flutter_nivasshub/widgets/shared/states/custom_error_widget.dart';
import 'package:flutter_nivasshub/widgets/shared/states/empty_state.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';
import 'package:flutter_nivasshub/models/quick_actions/quick_action_section_model.dart';
import 'package:flutter_nivasshub/providers/quick_actions/quick_actions_provider.dart';
import 'package:flutter_nivasshub/widgets/quick_actions/demo_notification_banner.dart';
import 'package:flutter_nivasshub/widgets/quick_actions/quick_action_card.dart';
import 'package:flutter_nivasshub/widgets/quick_actions/quick_action_section.dart';
import 'package:flutter_nivasshub/widgets/quick_actions/quick_actions_shimmer.dart';
import 'package:flutter_nivasshub/widgets/quick_actions/raise_alert_button.dart';

/// The full-screen Quick Actions catalog — pushed both from the bottom nav's
/// "More" tab and from Home's "View More" quick-actions tile. Closes with an
/// explicit X (not a back arrow), per the Figma design. The search bar at
/// the top filters the grid locally and instantly — no navigation, no API.
class QuickActionsScreen extends StatefulWidget {
  const QuickActionsScreen({super.key});

  @override
  State<QuickActionsScreen> createState() => _QuickActionsScreenState();
}

class _QuickActionsScreenState extends State<QuickActionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // `QuickActionsProvider` is an app-wide singleton, not screen-scoped —
      // clear any query left over from a previous visit before loading, so
      // reopening this screen always starts from the full, unfiltered grid.
      final provider = context.read<QuickActionsProvider>();
      provider.clearSearch();
      provider.loadQuickActions();
    });
  }

  void _handleTap(AppFeatureModel item) {
    if (item.id == 'test_notifications') {
      DemoNotificationBanner.show(context);
    } else if (item.routeName != null) {
      Navigator.pushNamed(context, item.routeName!);
    } else {
      CustomSnackbar.info(context, '${item.title} coming soon.');
    }
  }

  void _handleSectionAction(QuickActionSectionModel section) {
    CustomSnackbar.info(context, '${section.title} coming soon.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.infoLight,
      appBar: AppBar(
        backgroundColor: AppColors.infoLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(AppIcons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Quick Actions'),
        centerTitle: true,
      ),
      bottomNavigationBar: const DashboardBottomNavigation(),
      body: SafeArea(
        child: Consumer<QuickActionsProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) return const QuickActionsShimmer();
            if (provider.hasError) {
              return CustomErrorWidget(
                message: provider.errorMessage ?? 'Something went wrong. Please try again.',
                onRetry: provider.retry,
              );
            }
            if (provider.isEmpty) {
              return const EmptyState(
                title: 'No quick actions available',
                message: 'Quick actions will appear here once available.',
              );
            }
            return _buildBody(provider);
          },
        ),
      ),
    );
  }

  Widget _buildBody(QuickActionsProvider provider) {
    final filtered = provider.filteredSections;

    if (provider.isSearching && filtered.isEmpty) {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Responsive.horizontalPadding(context), vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(provider),
            const EmptyState(
              title: 'No matching quick action found',
              message: 'Try a different search term.',
            ),
          ],
        ),
      );
    }

    final shortcuts = filtered.firstWhere(
      (s) => s.id == 'shortcuts',
      orElse: () => const QuickActionSectionModel(id: 'shortcuts', items: []),
    );
    final headeredSections = filtered.where((s) => s.id != 'shortcuts').toList();

    return SingleChildScrollView(
<<<<<<< HEAD
      physics: const ClampingScrollPhysics(),
=======
      physics: const BouncingScrollPhysics(),
>>>>>>> f48df002e16cc94f3c12ba1e2f58d88dad4cc4bf
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(provider),
          if (shortcuts.items.isNotEmpty) ...[
            const SizedBox(height: 20),
            Row(
              children: shortcuts.items
                  .map(
                    (item) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: QuickActionCard(item: item, onTap: () => _handleTap(item)),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 24),
          for (final section in headeredSections) ...[
            _buildSection(section),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar(QuickActionsProvider provider) {
    return AppSearchBar(
      hint: 'Search all features',
      onChanged: provider.setSearchQuery,
    );
  }

  Widget _buildSection(QuickActionSectionModel section) {
    if (section.id == 'visitors_security') {
      return QuickActionSection(
        section: section,
        onItemTap: _handleTap,
        columns: Responsive.quickActionColumns(context),
        headerTrailing: RaiseAlertButton(onPressed: () => _handleSectionAction(section)),
      );
    }
    if (section.id == 'marketplace') {
      return QuickActionSection(
        section: section,
        onItemTap: _handleTap,
        columns: 3,
        itemBuilder: (item, onTap) => QuickActionCard(item: item, onTap: onTap, iconSize: AppDimensions.iconMd),
        onActionTap: () => _handleSectionAction(section),
      );
    }
    return QuickActionSection(
      section: section,
      onItemTap: _handleTap,
      columns: Responsive.quickActionColumns(context),
      onActionTap: () => _handleSectionAction(section),
    );
  }
}
