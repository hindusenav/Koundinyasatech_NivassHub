import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/core/api/base_api.dart';
import 'package:flutter_nivasshub/widgets/shared/loaders/loader.dart';
import 'package:flutter_nivasshub/widgets/shared/states/custom_error_widget.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';
import 'package:flutter_nivasshub/models/notices/advertisement_model.dart';
import 'package:flutter_nivasshub/models/notices/feed_item_model.dart';
import 'package:flutter_nivasshub/models/notices/feed_notice_model.dart';
import 'package:flutter_nivasshub/providers/notices/notices_provider.dart';
import 'package:flutter_nivasshub/screens/notices/community_posts_selection_screen.dart';
import 'package:flutter_nivasshub/widgets/notices/feed_list.dart';

class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key, required this.apiClient});

  final ApiClient apiClient;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoticesProvider(apiClient: apiClient)..loadFeed(),
      child: const _NoticeBoardView(),
    );
  }
}

class _NoticeBoardView extends StatefulWidget {
  const _NoticeBoardView();

  @override
  State<_NoticeBoardView> createState() => _NoticeBoardViewState();
}

class _NoticeBoardViewState extends State<_NoticeBoardView> {
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Unread',
    'Promotions',
    'Community',
  ];

  static const List<FeedItemModel> _figmaDefaultFeed = [
    FeedItemModel.notice(
      FeedNoticeModel(
        id: 'not_1',
        title: 'Expense report for quarter ending on June 2026',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        date: 'Society 25 Jun',
        attachment: '',
        author: 'Admin',
        category: 'Society 25 Jun',
        action: 'Download',
      ),
    ),
    FeedItemModel.notice(
      FeedNoticeModel(
        id: 'not_2',
        title: 'Swimming Pool under maintenance',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        date: 'Society 25 Jun',
        attachment: '',
        author: 'Admin',
        category: 'Society 25 Jun',
        action: 'Download',
      ),
    ),
    FeedItemModel.advertisement(
      AdvertisementModel(
        bannerId: 'ad_1',
        title: 'Century Bliss',
        subtitle: 'Yelahanka–Doddaballapura Main Road',
        price: '₹1.30 Crore Onwards',
        image:
            'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=600&q=80',
        redirectUrl: '',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      ),
    ),
    FeedItemModel.advertisement(
      AdvertisementModel(
        bannerId: 'ad_2',
        title: 'Enjoy Luxury Living @ Nikoo Homes',
        subtitle: 'by Bhartiya City',
        price: '₹93 Lakhs Onwards',
        image:
            'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600&q=80',
        redirectUrl: '',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      ),
    ),
    FeedItemModel.notice(
      FeedNoticeModel(
        id: 'not_3',
        title: 'B- Building parking under restoration',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        date: 'Society 25 Jun',
        attachment: '',
        author: 'Admin',
        category: 'Society 25 Jun',
        action: 'Download',
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final nearBottom = _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200;
    if (!nearBottom) return;

    final provider = context.read<NoticesProvider>();
    if (provider.hasMorePosts && !provider.isLoadingMore && !provider.isLoading) {
      provider.loadMore();
    }
  }

  List<FeedItemModel> _getFilteredItems(List<FeedItemModel> rawItems) {
    final baseItems = rawItems.isEmpty ? _figmaDefaultFeed : rawItems;

    if (_selectedFilter == 'Unread') {
      return baseItems
          .where(
            (item) =>
                item.type == FeedType.notice &&
                (item.notice?.id == 'not_1' ||
                    item.notice?.title.contains('Expense') == true),
          )
          .toList();
    } else if (_selectedFilter == 'Promotions') {
      return baseItems
          .where((item) => item.type == FeedType.advertisement)
          .toList();
    } else if (_selectedFilter == 'Community') {
      return baseItems
          .where(
            (item) =>
                item.type == FeedType.community || item.type == FeedType.notice,
          )
          .toList();
    }
    return baseItems;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoticesProvider>();
    final rawFeedItems = provider.feedItems;
    final displayItems = _getFilteredItems(rawFeedItems);
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.noticesBackgroundDark
          : AppColors.noticesBackgroundLight,
      bottomNavigationBar: const DashboardBottomNavigation(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // =====================================================
              // APP BAR HEADER CONTAINER MATCHING FIGMA (20px/12px/16px)
              // =====================================================
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: statusBarHeight + 12,
                  left: 18,
                  right: 18,
                  bottom: 20,
                ),
                decoration: const BoxDecoration(
                  gradient: AppColors.headerGradient,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Community Feed',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _HeaderButton(
                          icon: Icons.add_rounded,
                          label: 'Add New Post',
                          filled: true,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const CommunityPostsSelectionScreen(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Shows notices alongside community posts using the
                        // existing 'Community' filter.
                        _HeaderButton(
                          icon: Icons.campaign_outlined,
                          label: 'Notice',
                          filled: false,
                          onTap: () =>
                              setState(() => _selectedFilter = 'Community'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // =====================================================
              // MAIN SCROLLABLE CONTENT BODY (16px UNIFIED PADDING)
              // =====================================================
              Expanded(
                child: RefreshIndicator(
                  onRefresh: provider.refreshFeed,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filter Chips Bar (Tabs Container) matching Figma properties exactly
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 19),
                          child: SizedBox(
                            height: 33,
                            child: Row(
                              children: _filters.asMap().entries.map((entry) {
                                final index = entry.key;
                                final filter = entry.value;
                                final isSelected = _selectedFilter == filter;
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: index == _filters.length - 1 ? 0 : 28,
                                  ),
                                  child: InkWell(
                                    onTap: () => setState(() => _selectedFilter = filter),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      height: 33,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primaryOrange
                                            : (isDark
                                                ? AppColors.surfaceDark
                                                : AppColors.cardBg),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primaryOrange
                                              : (isDark
                                                  ? AppColors.noticesBorderDark
                                                  : AppColors.border),
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          filter,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : (isDark
                                                    ? AppColors.noticesHeadingDark
                                                    : AppColors.textPrimary),
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                            fontSize: 13,
                                            height: 1.0,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        if (provider.isLoading && rawFeedItems.isEmpty) ...[
                          const SizedBox(height: 60),
                          const Loader(message: 'Loading feed...'),
                        ] else if (provider.hasError && rawFeedItems.isEmpty) ...[
                          const SizedBox(height: 40),
                          CustomErrorWidget(
                            message:
                                provider.errorMessage ?? 'Something went wrong.',
                            onRetry: provider.retry,
                          ),
                        ] else ...[
                          // Unread Notice Alert Banner matching Figma properties exactly
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.noticesDangerBgDark
                                  : AppColors.accentTint,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.noticesDangerBorderDark
                                    : AppColors.primaryOrange,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.noticesDangerDotDark
                                        : AppColors.primaryOrange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '1 Unread Notice',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.noticesDangerTextDark
                                        : AppColors.textDark,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    height: 1.0,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          FeedList(
                            feedItems: displayItems,
                            isLoadingMore: provider.isLoadingMore,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                        ],

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pill button in the Community Feed header.
class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: filled
              ? AppColors.primaryOrange
              : AppColors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
