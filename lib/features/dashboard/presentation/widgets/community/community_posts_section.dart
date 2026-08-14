import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../notices/screens/community_posts_selection_screen.dart';
import '../../../../notices/screens/notice_details_screen.dart';
import '../../../../notices/screens/notices_screen.dart';
import '../../provider/dashboard_provider.dart';
import '../banner/banner_card.dart';
import 'community_meeting_card.dart';
import 'notice_card.dart';

class CommunityPostsSection extends StatelessWidget {
  const CommunityPostsSection({
    super.key,
  });

  void _navigateToNewPostsSelection(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CommunityPostsSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    final meeting = provider.communityMeeting;
    final notices = provider.notices;
    final banners = provider.advertisementBanners;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================
        // 1. COMMUNITY POSTS HEADER ROW (Height: 24px, Justify: space-between)
        // =====================================================
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Community Posts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                    height: 1.0,
                    letterSpacing: 0,
                  ),
                ),
                InkWell(
                  onTap: () => _navigateToNewPostsSelection(context),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    height: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color(0xFF6EE7B7),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.edit_note,
                          size: 16,
                          color: Color(0xFF059669),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'New Posts',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF059669),
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            height: 1.0,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // =====================================================
        // 2. COMMUNITY MEETING CARD
        // =====================================================
        if (meeting != null) ...[
          CommunityMeetingCard(meeting: meeting),
          const SizedBox(height: 16),
        ],

        // =====================================================
        // 3. NOTICE BOARD HEADER ROW (Height: 23px, Justify: space-between)
        // =====================================================
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 23,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Notice Board',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                    height: 1.0,
                    letterSpacing: 0,
                  ),
                ),
                InkWell(
                  onTap: () {
                    ApiClient? apiClient;
                    try {
                      apiClient = context.read<ApiClient>();
                    } catch (_) {}
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NoticesScreen(apiClient: apiClient ?? ApiClient()),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 21,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'View All',
                          style: TextStyle(
                            color: Color(0xFF0284C7),
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                            height: 1.0,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: Color(0xFF0284C7),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // =====================================================
        // 4. NOTICE 1 (Tapping opens Notice 1 details screen)
        // =====================================================
        if (notices.isNotEmpty) ...[
          NoticeCard(
            notice: notices[0],
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NoticeDetailsScreen(notice: notices[0]),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],

        // =====================================================
        // 5. NOTICE 2 (Tapping opens Notice details screen)
        // =====================================================
        if (notices.length > 1) ...[
          NoticeCard(
            notice: notices[1],
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NoticeDetailsScreen(notice: notices[1]),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],

        // =====================================================
        // 6. AD CARD 1 (Century Bliss)
        // =====================================================
        if (banners.isNotEmpty) ...[
          BannerCard(banner: banners[0]),
          const SizedBox(height: 16),
        ],

        // =====================================================
        // 7. AD CARD 2 (Nikoo Homes)
        // =====================================================
        if (banners.length > 1) ...[
          BannerCard(banner: banners[1]),
          const SizedBox(height: 16),
        ],

        // =====================================================
        // 8. NOTICE 3 (Tapping opens Notice details screen)
        // =====================================================
        if (notices.length > 2) ...[
          NoticeCard(
            notice: notices[2],
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NoticeDetailsScreen(notice: notices[2]),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],

        // Any additional notices if present
        for (int i = 3; i < notices.length; i++) ...[
          NoticeCard(
            notice: notices[i],
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NoticeDetailsScreen(notice: notices[i]),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}