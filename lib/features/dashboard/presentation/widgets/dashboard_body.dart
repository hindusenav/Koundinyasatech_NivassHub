import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/responsive.dart';
import '../../../notifications/widgets/visitor_notification_section.dart';
import '../provider/dashboard_provider.dart';
import 'approval_queue/approval_queue_section.dart';
import 'banner/banner_card.dart';
import 'banner/banner_slider.dart';
import 'community/community_posts_section.dart';
import 'header/dashboard_header.dart';
import 'maintenance/maintenance_card.dart';
import 'otp/generate_otp_banner.dart';
import 'panic/panic_sos_banner.dart';
import 'quick_actions/quick_actions_grid.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final banners = provider.advertisementBanners;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.horizontalPadding(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardHeader(),
            const SizedBox(height: 18),

            const VisitorNotificationSection(),

            const BannerSlider(),
            const SizedBox(height: 24),

            const QuickActionsGrid(),
            const SizedBox(height: 24),

            const MaintenanceCard(),
            const SizedBox(height: 24),

            const ApprovalQueueSection(),
            const SizedBox(height: 24),

            const PanicSosBanner(),
            const SizedBox(height: 16),

            const GenerateOtpBanner(),
            const SizedBox(height: 24),

            if (banners.isNotEmpty) ...[
              BannerCard(banner: banners.first),
              const SizedBox(height: 28),
            ],

            const CommunityPostsSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
