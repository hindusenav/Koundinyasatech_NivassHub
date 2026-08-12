import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/network/api_client.dart';
import '../../../shared/widgets/loaders/loader.dart';
import '../../../shared/widgets/states/custom_error_widget.dart';
import '../../../shared/widgets/states/empty_state.dart';
import '../../dashboard/presentation/widgets/navigation/dashboard_bottom_navigation.dart';
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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoticesProvider>();
    final feedItems = provider.feedItems;
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
              // APP BAR HEADER MATCHING FIGMA HIGHLIGHTED BOX
              // =====================================================
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: statusBarHeight > 0 ? statusBarHeight + 4 : 12,
                  left: 8,
                  right: 16,
                  bottom: 12,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFC7E1F8),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 6,
                      spreadRadius: 0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF0F172A),
                        size: 22,
                      ),
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Notice Board',
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              // =====================================================
              // MAIN SCROLLABLE CONTENT BODY
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
                                          ? const Color(0xFFE57C00)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFFE57C00)
                                            : const Color(0xFFCBD5E1),
                                      ),
                                    ),
                                    child: Text(
                                      filter,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
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

                        if (provider.isLoading && feedItems.isEmpty) ...[
                          const SizedBox(height: 60),
                          const Loader(message: 'Loading feed...'),
                        ] else if (provider.hasError && feedItems.isEmpty) ...[
                          const SizedBox(height: 40),
                          CustomErrorWidget(
                            message:
                                provider.errorMessage ?? 'Something went wrong.',
                            onRetry: provider.retry,
                          ),
                        ] else if (feedItems.isEmpty) ...[
                          const SizedBox(height: 40),
                          const EmptyState(
                            title: 'No posts yet',
                            message: 'No notices or posts available.',
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
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: const Color(0xFFFECACA)),
                            ),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.circle,
                                  color: Color(0xFFEF4444),
                                  size: 8,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '1 Unread Notice',
                                  style: TextStyle(
                                    color: Color(0xFFDC2626),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          FeedList(
                            feedItems: feedItems,
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
