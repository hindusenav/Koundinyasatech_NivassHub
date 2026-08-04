import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../provider/dashboard_provider.dart';
import '../banner/banner_card.dart';
import 'community_meeting_card.dart';
import 'notice_card.dart';

class CommunityPostsSection extends StatelessWidget {
  const CommunityPostsSection({
    super.key,
  });

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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Community Posts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Posting coming soon.')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.success,
                  side: BorderSide(color: AppColors.success),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                ),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('New Posts'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (meeting != null) ...[
          CommunityMeetingCard(meeting: meeting),
          const SizedBox(height: 16),
        ],
        for (var i = 0; i < notices.length; i++) ...[
          NoticeCard(notice: notices[i]),
          const SizedBox(height: 16),
          if (i == 0 && banners.isNotEmpty) ...[
            BannerCard(
              banner: banners.length > 1 ? banners[1] : banners.first,
            ),
            const SizedBox(height: 16),
          ],
        ],
      ],
    );
  }
}
