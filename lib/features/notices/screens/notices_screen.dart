import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/network/api_client.dart';
import '../../dashboard/data/models/banner_model.dart';
import '../../dashboard/data/models/notice_model.dart';
import '../../dashboard/presentation/widgets/banner/banner_card.dart';
import '../../dashboard/presentation/widgets/community/notice_card.dart';
import '../../dashboard/presentation/widgets/navigation/dashboard_bottom_navigation.dart';
import '../provider/notices_provider.dart';

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
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Unread', 'Promotions', 'Community'];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoticesProvider>();

    final List<NoticeModel> notices = provider.notices.isNotEmpty
        ? provider.notices
            .map((n) => NoticeModel(
                  noticeId: n.id,
                  title: n.title,
                  postedBy: n.author.isNotEmpty ? n.author : 'Admin',
                  society: n.date.isNotEmpty ? n.date : 'Society 25 Jun',
                  date: n.timestamp.isNotEmpty ? n.timestamp : 'Society 25 Jun',
                  body: n.description,
                  downloadLabel: n.action.isNotEmpty ? n.action : 'Download',
                ))
            .toList()
        : _fallbackNotices();

    final List<BannerModel> banners = provider.banners.isNotEmpty
        ? provider.banners
            .map((ad) => BannerModel(
                  bannerId: ad.bannerId,
                  title: ad.title,
                  image: ad.image,
                  redirectUrl: ad.redirectUrl,
                ))
            .toList()
        : _fallbackBanners();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F2FE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text(
          'Notice Board',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      bottomNavigationBar: const DashboardBottomNavigation(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: provider.refreshFeed,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter Chips Bar
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
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFE57C00) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? const Color(0xFFE57C00) : const Color(0xFFCBD5E1),
                              ),
                            ),
                            child: Text(
                              filter,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),

                // Unread Notice Alert Banner
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFECACA)),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.circle, color: Color(0xFFEF4444), size: 8),
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

                // Notice 1
                if (notices.isNotEmpty) ...[
                  NoticeCard(notice: notices[0]),
                  const SizedBox(height: 14),
                ],

                // Notice 2
                if (notices.length > 1) ...[
                  NoticeCard(notice: notices[1]),
                  const SizedBox(height: 14),
                ],

                // Ad Card 1 (Century Bliss)
                if (banners.isNotEmpty) ...[
                  BannerCard(banner: banners[0]),
                  const SizedBox(height: 14),
                ],

                // Ad Card 2 (Nikoo Homes)
                if (banners.length > 1) ...[
                  BannerCard(banner: banners[1]),
                  const SizedBox(height: 14),
                ],

                // Notice 3
                if (notices.length > 2) ...[
                  NoticeCard(notice: notices[2]),
                  const SizedBox(height: 14),
                ],

                // Any remaining notices
                for (var i = 3; i < notices.length; i++) ...[
                  NoticeCard(notice: notices[i]),
                  const SizedBox(height: 14),
                ],

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static List<NoticeModel> _fallbackNotices() {
    return const [
      NoticeModel(
        noticeId: 'not_1',
        title: 'Expense report for quarter ending on June 2026',
        postedBy: 'Admin',
        society: 'Society 25 Jun',
        date: 'Society 25 Jun',
        body:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        downloadLabel: 'Download',
      ),
      NoticeModel(
        noticeId: 'not_2',
        title: 'Swimming Pool under maintenance',
        postedBy: 'Admin',
        society: 'Society 25 Jun',
        date: 'Society 25 Jun',
        body:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        downloadLabel: 'Download',
      ),
      NoticeModel(
        noticeId: 'not_3',
        title: 'B- Building parking under restoration',
        postedBy: 'Admin',
        society: 'Society 25 Jun',
        date: 'Society 25 Jun',
        body:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        downloadLabel: 'Download',
      ),
    ];
  }

  static List<BannerModel> _fallbackBanners() {
    return const [
      BannerModel(
        bannerId: 'ad_century',
        title: 'Century Bliss',
        image: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750',
        redirectUrl: '',
      ),
      BannerModel(
        bannerId: 'ad_nikoo',
        title: 'Enjoy Luxury Living @ Nikoo Homes',
        image: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00',
        redirectUrl: '',
      ),
    ];
  }
}
