import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../notices/screens/advertisement_details_screen.dart';
import '../../../../notices/screens/community_posts_selection_screen.dart';
import '../../../../notices/screens/notices_screen.dart';
import '../../provider/dashboard_provider.dart';
import '../banner/banner_card.dart';
import 'community_meeting_card.dart';
import 'notice_card.dart';

class CommunityPostsSection extends StatelessWidget {
  const CommunityPostsSection({super.key});

  void _navigateToNoticeBoard(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoticesScreen(apiClient: context.read<ApiClient>()),
      ),
    );
  }

  void _navigateToNewPostsSelection(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CommunityPostsSelectionScreen(),
      ),
    );
  }

  void _navigateToAdDetails(BuildContext context, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AdvertisementDetailsScreen(projectName: title),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Community Posts',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => _navigateToNewPostsSelection(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF059669),
                  side: const BorderSide(color: Color(0xFF6EE7B7)),
                  backgroundColor: const Color(0xFFECFDF5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                ),
                icon: const Icon(Icons.edit_note, size: 16),
                label: const Text(
                  'New Posts',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (meeting != null) ...[
          CommunityMeetingCard(meeting: meeting),
          const SizedBox(height: 20),
        ],

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Notice Board',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              InkWell(
                onTap: () => _navigateToNoticeBoard(context),
                borderRadius: BorderRadius.circular(8),
                child: const Text(
                  'View All >',
                  style: TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        for (var i = 0; i < notices.length; i++) ...[
          NoticeCard(
            notice: notices[i],
            onTap: () => _navigateToAdDetails(context, notices[i].title),
          ),
          const SizedBox(height: 14),
          if (i < banners.length) ...[
            BannerCard(banner: banners[i]),
            const SizedBox(height: 14),
          ],
        ],
      ],
    );
  }
}
