import 'package:flutter/material.dart';

import '../../../../core/utils/responsive.dart';
import 'advertisement/advertisement_section.dart';
import 'announcement/announcement_section.dart';
import 'approval_queue/approval_queue_section.dart';
import 'banner/banner_slider.dart';
import 'header/dashboard_header.dart';
import 'maintenance/maintenance_card.dart';
import 'quick_actions/quick_actions_grid.dart';
import 'welcome/welcome_card.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.horizontalPadding(context),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(),
            SizedBox(height: 18),

            WelcomeCard(),
            SizedBox(height: 20),

            BannerSlider(),
            SizedBox(height: 24),

            MaintenanceCard(),
            SizedBox(height: 24),

            QuickActionsGrid(),
            SizedBox(height: 28),

            ApprovalQueueSection(),
            SizedBox(height: 28),

            AdvertisementSection(),
            SizedBox(height: 28),

            AnnouncementSection(),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}