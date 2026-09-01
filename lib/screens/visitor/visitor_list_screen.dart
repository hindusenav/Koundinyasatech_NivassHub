import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/widgets/shared/app_bar/custom_app_bar.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/app_search_bar.dart';
import 'package:flutter_nivasshub/widgets/shared/loaders/shimmer_loader.dart';
import 'package:flutter_nivasshub/widgets/shared/states/custom_error_widget.dart';
import 'package:flutter_nivasshub/widgets/shared/states/empty_state.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';
import 'package:flutter_nivasshub/models/visitor/approval_activity_model.dart';
import 'package:flutter_nivasshub/providers/visitor/visitor_activity_provider.dart';
import 'package:flutter_nivasshub/services/visitor/mock_visitor_activity_service.dart';
import 'package:flutter_nivasshub/services/visitor/visitor_activity_repository.dart';
import 'package:flutter_nivasshub/widgets/visitor/activity_card.dart';
import 'package:flutter_nivasshub/widgets/visitor/activity_filter_chip.dart';
import 'package:flutter_nivasshub/widgets/visitor/activity_type_filter_sheet.dart';
import 'package:flutter_nivasshub/widgets/visitor/date_header.dart';

/// Pushed from the Home screen's Approval Queue "View all" link — a full
/// gate/delivery activity log with filter chips, date-grouped cards, and an
/// "Add Visitor" FAB. Screen-scoped `ChangeNotifierProvider` (like
/// `NoticesScreen`), so this feature is entirely self-contained: no changes
/// to `app.dart`'s app-wide provider list or `main.dart`'s wiring were
/// needed to add it.
class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VisitorActivityProvider(
        VisitorActivityRepository(MockVisitorActivityService()),
      )..loadActivities(),
      child: const _ActivitiesView(),
    );
  }
}

class _ActivitiesView extends StatefulWidget {
  const _ActivitiesView();

  @override
  State<_ActivitiesView> createState() => _ActivitiesViewState();
}

class _ActivitiesViewState extends State<_ActivitiesView> {
  bool _showSearch = false;

  /// IDs picked in the "Filter Activity by Type" sheet (Cab/Delivery/Guest/
  /// Daily Help/Parcel/Vehicle/Kid/Others) — layered on top of
  /// `VisitorActivityProvider`'s own filter-chip/search state in
  /// `_applyTypeFilter` below, since that categorization isn't part of
  /// `ApprovalActivityModel`'s API-contract fields and has no backend of
  /// its own yet (see `ActivityTypeFilterSheet`).
  Set<String> _selectedTypeFilterIds = {};

  void _toggleSearch() {
    final provider = context.read<VisitorActivityProvider>();
    setState(() => _showSearch = !_showSearch);
    if (!_showSearch) provider.clearSearch();
  }

  Future<void> _handleFilterTap() async {
    final result = await ActivityTypeFilterSheet.show(
      context,
      initialSelectedIds: _selectedTypeFilterIds,
    );
    if (result == null || !mounted) return; // dismissed without applying
    setState(() => _selectedTypeFilterIds = result.toSet());
  }

  void _handleAddVisitor() {
    CustomSnackbar.info(context, 'Add Visitor coming soon.');
  }

  void _handleCall(ApprovalActivityModel activity) {
    CustomSnackbar.info(context, 'Calling ${activity.name}…');
  }

  void _handleWrongEntry(
    VisitorActivityProvider provider,
    ApprovalActivityModel activity,
  ) {
    final wasWrong = activity.isWrongEntry;
    provider.toggleWrongEntry(activity.id);
    CustomSnackbar.warning(
      context,
      wasWrong ? 'Entry unmarked.' : 'Marked as a wrong entry.',
    );
  }

  /// The filter icon with a small dot badge — matching the selected-option
  /// indicator dot in `ActivityTypeFilterSheet` — when a type filter is
  /// currently applied, so it's visible without reopening the sheet.
  Widget _buildFilterIcon() {
    if (_selectedTypeFilterIds.isEmpty) return Icon(AppIcons.filter);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(AppIcons.filter),
        Positioned(
          top: -2,
          right: -2,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.info,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  /// Matches [activity] against one "Filter Activity by Type" chip ID. This
  /// categorization (Cab/Delivery/Guest/Daily Help/Parcel/Vehicle/Kid) has
  /// no dedicated field on `ApprovalActivityModel` yet — the backend hasn't
  /// published one — so it's derived here from the existing `type`/`company`
  /// fields as a best-effort mapping for the mock data. `'others'` is a
  /// catch-all for anything the other six don't match.
  bool _matchesTypeFilterId(String filterId, ApprovalActivityModel activity) {
    switch (filterId) {
      case 'cab':
        return activity.company == 'Cab';
      case 'delivery':
        return activity.type == 'delivery';
      case 'guest':
        return activity.company == 'Guest' || activity.company == 'Visitor';
      case 'daily_help':
        return activity.company == 'House Help';
      case 'parcel':
        return activity.company == 'Courier';
      case 'vehicle':
        return activity.company == 'Vehicle';
      case 'kid':
        return activity.company == 'Kid Pickup';
      case 'others':
        const knownIds = [
          'cab',
          'delivery',
          'guest',
          'daily_help',
          'parcel',
          'vehicle',
          'kid',
        ];
        return !knownIds.any((id) => _matchesTypeFilterId(id, activity));
      default:
        return false;
    }
  }

  /// Narrows [grouped] (already filtered by the AppBar filter-chip/search
  /// state) to activities matching at least one selected type-filter chip.
  /// Date sections left with no matches are dropped entirely, same as
  /// `VisitorActivityProvider.groupedActivities` already does.
  Map<String, List<ApprovalActivityModel>> _applyTypeFilter(
    Map<String, List<ApprovalActivityModel>> grouped,
  ) {
    if (_selectedTypeFilterIds.isEmpty) return grouped;

    final result = <String, List<ApprovalActivityModel>>{};
    for (final entry in grouped.entries) {
      final matches = entry.value
          .where(
            (a) =>
                _selectedTypeFilterIds.any((id) => _matchesTypeFilterId(id, a)),
          )
          .toList();
      if (matches.isNotEmpty) result[entry.key] = matches;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VisitorActivityProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Activities',
            actions: [
              IconButton(icon: _buildFilterIcon(), onPressed: _handleFilterTap),
              IconButton(
                icon: Icon(_showSearch ? AppIcons.close : AppIcons.search),
                onPressed: _toggleSearch,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _handleAddVisitor,
            tooltip: 'Add Visitor',
            child: Icon(AppIcons.add),
          ),
          bottomNavigationBar: const DashboardBottomNavigation(),
          body: SafeArea(child: _buildBody(provider)),
        );
      },
    );
  }

  Widget _buildBody(VisitorActivityProvider provider) {
    switch (provider.state) {
      case VisitorActivityState.initial:
      case VisitorActivityState.loading:
        return const ShimmerListPlaceholder();

      case VisitorActivityState.error:
        return CustomErrorWidget(
          message:
              provider.errorMessage ??
              'Something went wrong. Please try again.',
          onRetry: provider.retry,
        );

      case VisitorActivityState.empty:
        return const EmptyState(
          title: 'No activity yet',
          message: 'Visitor and delivery entries will show up here.',
        );

      case VisitorActivityState.success:
        return _buildContent(provider);
    }
  }

  Widget _buildContent(VisitorActivityProvider provider) {
    final grouped = _applyTypeFilter(provider.groupedActivities);

    return Column(
      children: [
        if (_showSearch)
          Padding(
            padding: AppSpacing.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: AppSearchBar(
              hint: 'Search by name or company',
              autofocus: true,
              onChanged: provider.setSearchQuery,
            ),
          ),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.symmetric(horizontal: AppSpacing.md),
            itemCount: ActivityFilter.values.length,
            separatorBuilder: (_, _) => AppSpacing.gapWSm,
            itemBuilder: (_, index) {
              final filter = ActivityFilter.values[index];
              return ActivityFilterChip(
                label: filter.label,
                selected: provider.selectedFilter == filter,
                onTap: () => provider.selectFilter(filter),
              );
            },
          ),
        ),
        AppSpacing.gapSm,
        Expanded(
          child: provider.hasNoResultsForFilter || grouped.isEmpty
              ? const EmptyState(
                  title: 'No matching activity',
                  message: 'Try a different filter or search term.',
                )
              : RefreshIndicator(
                  onRefresh: provider.loadActivities,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: AppSpacing.symmetric(
                      horizontal: AppSpacing.md,
                    ).copyWith(bottom: AppSpacing.xxl),
                    children: [
                      for (final entry in grouped.entries) ...[
                        DateHeader(label: entry.key),
                        for (final activity in entry.value) ...[
                          ActivityCard(
                            activity: activity,
                            onCall: () => _handleCall(activity),
                            onWrongEntry: () =>
                                _handleWrongEntry(provider, activity),
                          ),
                          AppSpacing.gapSm,
                        ],
                      ],
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
