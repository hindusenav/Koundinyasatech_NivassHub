import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/services/core/api_client.dart';
import 'package:flutter_nivasshub/screens/notices/community_posts_selection_screen.dart';
import 'package:flutter_nivasshub/screens/notices/notice_details_screen.dart';
import 'package:flutter_nivasshub/screens/notices/notices_screen.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/widgets/dashboard/banner/banner_card.dart';
import 'package:flutter_nivasshub/widgets/dashboard/community/community_meeting_card.dart';
import 'package:flutter_nivasshub/widgets/dashboard/community/notice_card.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<DashboardProvider>();

    final meeting = provider.communityMeeting;
    final notices = provider.notices;
    final banners = provider.advertisementBanners;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================
        // 1. COMMUNITY POSTS HEADER ROW
        // =====================================================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Community Posts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
              ),
            ),
            InkWell(
              onTap: () => _navigateToNewPostsSelection(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF123B2E) : const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? const Color(0xFF10B981) : const Color(0xFF6EE7B7),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_note,
                      size: 16,
                      color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'New Posts',
                      style: TextStyle(
                        color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
        // 3. NOTICE BOARD HEADER ROW
        // =====================================================
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
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Notice Board',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      color: isDark ? AppColors.info : const Color(0xFF0284C7),
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: isDark ? AppColors.info : const Color(0xFF0284C7),
                  ),
                ],
              ),
            ],
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
          const SizedBox(height: 14),
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
          const SizedBox(height: 14),
        ],

        // =====================================================
        // 7. AD CARD 2 (Nikoo Homes)
        // =====================================================
        if (banners.length > 1) ...[
          BannerCard(banner: banners[1]),
          const SizedBox(height: 14),
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
          const SizedBox(height: 14),
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
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}