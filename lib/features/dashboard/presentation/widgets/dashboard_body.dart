import 'package:flutter/material.dart';

import 'approval_queue/approval_queue_section.dart';
import 'banner/online_advertising_hero_card.dart';
import 'community/community_posts_section.dart';
import 'header/dashboard_header.dart';
import 'maintenance/maintenance_card.dart';
import 'otp/generate_otp_banner.dart';
import 'panic/panic_sos_banner.dart';
import 'quick_actions/quick_actions_grid.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardHeader(),
          SizedBox(height: 16),

          OnlineAdvertisingHeroCard(),
          SizedBox(height: 20),

          QuickActionsGrid(),
          SizedBox(height: 20),

          MaintenanceCard(),
          SizedBox(height: 20),

          ApprovalQueueSection(),
          SizedBox(height: 20),

          PanicSosBanner(),
          SizedBox(height: 14),

          GenerateOtpBanner(),
          SizedBox(height: 24),

          CommunityPostsSection(),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
