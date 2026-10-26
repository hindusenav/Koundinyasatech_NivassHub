import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/core/api/base_api.dart';
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
    final t = FigmaColors.of(context);
    final accent = t.accent;
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
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1.0,
                color: t.heading,
              ),
            ),
            InkWell(
              onTap: () => _navigateToNewPostsSelection(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: t.iconBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: accent,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_note,
                      size: 16,
                      color: accent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'New Posts',
                      style: GoogleFonts.inter(
                        color: accent,
                        fontWeight: FontWeight.w600,
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
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: t.heading,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All',
                    style: GoogleFonts.inter(
                      color: accent,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: accent,
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