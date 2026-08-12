import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../app/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../notices/screens/community_posts_selection_screen.dart';
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
        Row(
          children: [
            const Expanded(
              child: Text(
                'Community Posts',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.noticeList),
              child: const Text(
                'View all',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => _navigateToNewPostsSelection(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.success,
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: AppColors.success.withValues(alpha: .5),
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Icon(
                Icons.edit_outlined,
                size: 18,
              ),
              label: const Text(
                'New Posts',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        if (meeting != null) ...[
          CommunityMeetingCard(meeting: meeting),
          const SizedBox(height: 20),
        ],

        for (int i = 0; i < notices.length; i++) ...[
          NoticeCard(notice: notices[i]),
          const SizedBox(height: 20),

          if (i == 0 && banners.isNotEmpty) ...[
            BannerCard(
              banner: banners.length > 1
                  ? banners[1]
                  : banners.first,
            ),
            const SizedBox(height: 20),
          ],
        ],
      ],
    );
  }
}