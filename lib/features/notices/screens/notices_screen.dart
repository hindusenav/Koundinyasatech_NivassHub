import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/network/api_client.dart';
import '../../../shared/widgets/loaders/loader.dart';
import '../../../shared/widgets/states/custom_error_widget.dart';
import '../../dashboard/presentation/widgets/navigation/dashboard_bottom_navigation.dart';
import '../models/advertisement_model.dart';
import '../models/feed_item_model.dart';
import '../models/feed_notice_model.dart';
import '../provider/notices_provider.dart';
import '../widgets/feed_list.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: const DashboardBottomNavigation(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // =====================================================
              // HEADER CONTAINER (Height: 66px Hug, Color: #C7E3FF, Padding: Top 12px, Right 20px, Bottom 16px, Left 20px)
              // =====================================================
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: statusBarHeight > 0 ? statusBarHeight + 12 : 12,
                  left: 20,
                  right: 20,
                  bottom: 16,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFC7E3FF),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 6,
                      spreadRadius: 0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 38,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// NAVIGATION & GREETING CONTAINER (352px x 38px, Radius: 40px, Border: 1px #CCDFF2, Padding: Left 16px, Right 12px, Gap: 10px)
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                }
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Color(0xFF0F172A),
                                  size: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 38,
                                padding: const EdgeInsets.only(left: 16, right: 12),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(
                                    color: const Color(0xFFCCDFF2),
                                    width: 1.0,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    /// GREETING TEXT ("Notice Board", DM Sans 600 SemiBold, 18px, Line height: 100%)
                                    SizedBox(
                                      height: 23,
                                      child: Text(
                                        'Notice Board',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Color(0xFF0F172A),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          height: 1.0,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                        // Filter Chips Bar matching Figma Tabs Container (Height: 33px, Gap: 28px)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: _filters.map((filter) {
                              final isSelected = _selectedFilter == filter;
                              return Padding(
                                padding: const EdgeInsets.only(right: 28),
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
                                          ? const Color(0xFFEC9211)
                                          : const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFFEC9211)
                                            : const Color(0xFFCBD5E1),
                                      ),
                                    ),
                                    child: Text(
                                      filter,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        height: 1.0,
                                        letterSpacing: 0,
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
                          /// UNREAD-BANNER (Height: 50px Hug, Radius: 12px, Border: 1px #EE3B30, Padding: 16px, BG: #FFF1ED)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1ED),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFEE3B30),
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                /// BANNER-LEFT (Height: 18px, Gap: 8px)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.circle,
                                      color: Color(0xFFEE3B30),
                                      size: 8,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '1 Unread Notice',
                                      style: TextStyle(
                                        color: Color(0xFFEE3B30),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        height: 1.0,
                                      ),
                                    ),
                                  ],
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
