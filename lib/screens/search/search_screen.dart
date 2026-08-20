import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/utils/responsive.dart';
import 'package:flutter_nivasshub/models/shared/app_feature_model.dart';
import 'package:flutter_nivasshub/widgets/shared/common/section_title.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/loaders/shimmer_loader.dart';
import 'package:flutter_nivasshub/widgets/shared/states/custom_error_widget.dart';
import 'package:flutter_nivasshub/widgets/shared/states/empty_state.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';
import 'package:flutter_nivasshub/widgets/quick_actions/demo_notification_banner.dart';
import 'package:flutter_nivasshub/providers/search/search_provider.dart';
import 'package:flutter_nivasshub/widgets/search/search_results_list.dart';

/// Search across every app feature — Popular Searches when no query has
/// been typed, live filtered results otherwise. Pushed from the Quick
/// Actions screen's search bar and from the Home dashboard header's search
/// icon.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SearchProvider>().loadPopularSearches();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const DashboardBottomNavigation(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.infoLight,
      padding: AppSpacing.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
      child: Row(
        children: [
          IconButton(
            icon: Icon(AppIcons.back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: (value) => context.read<SearchProvider>().onQueryChanged(value),
              decoration: const InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<SearchProvider>(
      builder: (context, provider, _) {
        if (provider.hasError) {
          return CustomErrorWidget(
            message: provider.errorMessage ?? 'Something went wrong. Please try again.',
            onRetry: provider.retry,
          );
        }

        final padding = EdgeInsets.symmetric(
          horizontal: Responsive.horizontalPadding(context),
          vertical: 8,
        );

        if (!provider.hasQuery) {
          if (provider.isLoadingPopular) {
            return const ShimmerListPlaceholder(itemCount: 7);
          }
          return SingleChildScrollView(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(title: 'Popular Searches'),
                AppSpacing.gapSm,
                SearchResultsList(items: provider.popularSearches, onItemTap: _handleTap),
              ],
            ),
          );
        }

        if (provider.isSearching) {
          return const ShimmerListPlaceholder(itemCount: 4);
        }

        if (provider.isEmpty) {
          return const EmptyState(
            title: 'No results found',
            message: 'Try a different search term.',
          );
        }

        return SingleChildScrollView(
          padding: padding,
          child: SearchResultsList(items: provider.results, onItemTap: _handleTap),
        );
      },
    );
  }
}
