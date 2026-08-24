import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/services/core/api_client.dart';
import 'package:flutter_nivasshub/widgets/shared/loaders/loader.dart';
import 'package:flutter_nivasshub/widgets/shared/states/custom_error_widget.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';
import 'package:flutter_nivasshub/models/notices/advertisement_model.dart';
import 'package:flutter_nivasshub/models/notices/feed_item_model.dart';
import 'package:flutter_nivasshub/models/notices/feed_notice_model.dart';
import 'package:flutter_nivasshub/providers/notices/notices_provider.dart';
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

  final List<String> _filters = ['All', 'Unread', 'Promotions', 'Community'];

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
    final headerBlue =
        isDark ? AppColors.dashboardHeaderDark : AppColors.dashboardHeaderLight;
    final headingColor =
        isDark ? AppColors.noticesHeadingDark : AppColors.noticesHeadingLight;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.noticesBackgroundDark
          : AppColors.noticesBackgroundLight,
      bottomNavigationBar: const DashboardBottomNavigation(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // =====================================================
              // APP BAR HEADER MATCHING FIGMA DESIGN (16px PADDING)
              // =====================================================
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: statusBarHeight > 0 ? statusBarHeight + 6 : 14,
                  left: 16,
                  right: 16,
                  bottom: 14,
                ),
                decoration: BoxDecoration(
                  color: headerBlue,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.24 : 0.06),
                      blurRadius: 6,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Notice Board is the parent/root screen of this flow,
                    // so it intentionally has no back arrow (see sub-category
                    // and detail screens for the back navigation entry point).
                    Text(
                      'Notice Board',
                      style: TextStyle(
                        color: headingColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
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
                        // Filter Chips Bar matching Figma ['All', 'Unread', 'Promotions', 'Community']
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: _filters.map((filter) {
                              final isSelected = _selectedFilter == filter;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: InkWell(
                                  onTap: () => setState(() => _selectedFilter = filter),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? (isDark
                                              ? AppColors.noticesAmberDark
                                              : AppColors.noticesAmberLight)
                                          : (isDark
                                              ? AppColors.surfaceDark
                                              : Colors.white),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? (isDark
                                                ? AppColors.noticesAmberDark
                                                : AppColors.noticesAmberLight)
                                            : (isDark
                                                ? AppColors.noticesBorderDark
                                                : AppColors.noticesBorderLight),
                                      ),
                                    ),
                                    child: Text(
                                      filter,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : headingColor,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 14),

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
                          // Unread Notice Alert Banner matching Figma
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.noticesDangerBgDark
                                  : AppColors.noticesDangerBgLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.noticesDangerBorderDark
                                    : AppColors.noticesDangerBorderLight,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: isDark
                                      ? AppColors.noticesDangerDotDark
                                      : AppColors.noticesDangerDotLight,
                                  size: 8,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '1 Unread Notice',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.noticesDangerTextDark
                                        : AppColors.noticesDangerTextLight,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

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
