import 'package:flutter/material.dart';

import '../../../../core/utils/responsive.dart';
import '../../../notifications/widgets/visitor_notification_section.dart';
import 'approval_queue/approval_queue_section.dart';
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
    return Container(
      width: double.infinity,
      color: const Color(0xFFF7F8FC),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          left: Responsive.horizontalPadding(context).clamp(12.0, 14.0),
          right: Responsive.horizontalPadding(context).clamp(12.0, 14.0),
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            const DashboardHeader(),

            const VisitorNotificationSection(),

            const SizedBox(height: 8),

            // ONLINE ADVERTISEMENT SLIDER
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

            // PANIC / SOS
            const PanicSosBanner(),

            const SizedBox(height: 7),

            // OTP / QR CODE GATE ENTRY
            const GenerateOtpBanner(),

            const SizedBox(height: 16),

            // COMMUNITY POSTS & NOTICE BOARD SECTION (Matching Figma order 100%)
            const CommunityPostsSection(),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}