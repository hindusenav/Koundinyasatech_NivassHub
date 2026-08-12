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

    return Container(
      width: double.infinity,
      color: const Color(0xFFF7F8FC),

      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        padding: EdgeInsets.only(
          left: Responsive.horizontalPadding(context)
              .clamp(12.0, 14.0),
          right: Responsive.horizontalPadding(context)
              .clamp(12.0, 14.0),
          bottom: 20,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            const DashboardHeader(),

            const VisitorNotificationSection(),

            const SizedBox(height: 8),

            // ONLINE ADVERTISEMENT
            const BannerSlider(),

            const SizedBox(height: 9),

            // QUICK ACTIONS
            const QuickActionsGrid(),

            const SizedBox(height: 9),

            // MAINTENANCE
            const MaintenanceCard(),

            const SizedBox(height: 9),

            // APPROVAL QUEUE
            const ApprovalQueueSection(),

            const SizedBox(height: 9),

            // PANIC
            const PanicSosBanner(),

            const SizedBox(height: 7),

            // OTP
            const GenerateOtpBanner(),

            // ADVERTISEMENT
            if (banners.isNotEmpty) ...[
              const SizedBox(height: 9),

              BannerCard(
                banner: banners.first,
              ),
            ],

            const SizedBox(height: 9),

            // COMMUNITY
            const CommunityPostsSection(),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}