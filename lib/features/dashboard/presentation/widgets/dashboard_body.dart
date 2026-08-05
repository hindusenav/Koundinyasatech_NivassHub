import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/responsive.dart';
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
      color: const Color(0xFFF7F8FC), // Figma background
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            Responsive.horizontalPadding(context),
            8,
            Responsive.horizontalPadding(context),
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardHeader(),

              const SizedBox(height: 14),

              const BannerSlider(),

              const SizedBox(height: 22),

              const QuickActionsGrid(),

              const SizedBox(height: 22),

              const MaintenanceCard(),

              const SizedBox(height: 22),

              const ApprovalQueueSection(),

              const SizedBox(height: 22),

              const PanicSosBanner(),

              const SizedBox(height: 16),

              const GenerateOtpBanner(),

              const SizedBox(height: 22),

              if (banners.isNotEmpty) ...[
                BannerCard(
                  banner: banners.first,
                ),
                const SizedBox(height: 22),
              ],

              const CommunityPostsSection(),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}