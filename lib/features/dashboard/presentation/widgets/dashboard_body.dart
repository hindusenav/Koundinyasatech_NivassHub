import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // TOP HEADER
            DashboardHeader(),

            VisitorNotificationSection(),

            SizedBox(height: 20),

            // ONLINE ADVERTISEMENT SLIDER BANNER
            BannerSlider(),

            SizedBox(height: 20),

            // QUICK ACTIONS GRID
            QuickActionsGrid(),

            SizedBox(height: 20),

            // MAINTENANCE ALERT BANNER
            MaintenanceCard(),

            SizedBox(height: 20),

            // APPROVAL QUEUE CAROUSEL
            ApprovalQueueSection(),

            SizedBox(height: 20),

            // PANIC / SOS SLIDER BANNER
            PanicSosBanner(),

            SizedBox(height: 16),

            // OTP / QR CODE GATE ENTRY BANNER
            GenerateOtpBanner(),

            SizedBox(height: 20),

            // COMMUNITY POSTS & NOTICE BOARD SECTION
            CommunityPostsSection(),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}