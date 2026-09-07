import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/widgets/notifications/visitor_notification_section.dart';
import 'package:flutter_nivasshub/widgets/dashboard/approval_queue/approval_queue_section.dart';
import 'package:flutter_nivasshub/widgets/dashboard/banner/banner_slider.dart';
import 'package:flutter_nivasshub/widgets/dashboard/community/community_posts_section.dart';
import 'package:flutter_nivasshub/widgets/dashboard/header/dashboard_header.dart';
import 'package:flutter_nivasshub/widgets/dashboard/maintenance/maintenance_card.dart';
import 'package:flutter_nivasshub/widgets/dashboard/otp/generate_otp_banner.dart';
import 'package:flutter_nivasshub/widgets/dashboard/panic/panic_sos_banner.dart';
import 'package:flutter_nivasshub/widgets/dashboard/quick_actions/quick_actions_grid.dart';
import 'package:flutter_nivasshub/widgets/dashboard/add_property/add_proper_section.dart';

// KYC Update Card
import 'package:flutter_nivasshub/widgets/dashboard/kyc_update_card/kyc_update_card_section.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({
    super.key,
  });

  static final LayerLink _headerAnchor = LayerLink();

  // ============================================================
  // KYC CARD HEIGHT
  //
  // Space reserved at the bottom of the scrollable dashboard
  // so the floating KYC card does not cover the last content.
  // ============================================================

  static const double _kycCardAreaHeight = 150.0;

  // ============================================================
  // KYC UPDATE ACTION
  // ============================================================

  void _openKycFlow(BuildContext context) {
    // ------------------------------------------------------------
    // Your KYC navigation will be added here.
    //
    // Example when SelectCountryScreen is available:
    //
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => const SelectCountryScreen(),
    //   ),
    // );
    // ------------------------------------------------------------

    debugPrint('KYC Update Now clicked');
  }

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 16.0;

    return Container(
      width: double.infinity,
      color: const Color(0xFFF7F8FC),

      child: Stack(
        children: [
          // ========================================================
          // SCROLLABLE DASHBOARD
          // ========================================================

          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            // Extra space at bottom for the floating KYC card
            padding: const EdgeInsets.only(
              bottom: _kycCardAreaHeight + 20,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // HEADER
                // ==================================================

                CompositedTransformTarget(
                  link: _headerAnchor,
                  child: const DashboardHeader(),
                ),

                // ==================================================
                // ADD PROPERTY
                // ==================================================

                const AddPropertySection(),

                // ==================================================
                // DASHBOARD CONTENT
                // ==================================================

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    horizontalPadding,
                    16,
                    horizontalPadding,
                    0,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =================================================
                      // ONLINE ADVERTISEMENT
                      // =================================================

                      const BannerSlider(),

                      const SizedBox(height: 16),

                      // =================================================
                      // QUICK ACTIONS
                      // =================================================

                      const QuickActionsGrid(),

                      const SizedBox(height: 16),

                      // =================================================
                      // MAINTENANCE
                      // =================================================

                      const MaintenanceCard(),

                      const SizedBox(height: 16),

                      // =================================================
                      // APPROVAL QUEUE
                      // =================================================

                      const ApprovalQueueSection(),

                      const SizedBox(height: 16),

                      // =================================================
                      // PANIC SOS
                      // =================================================

                      const PanicSosBanner(),

                      const SizedBox(height: 16),

                      // =================================================
                      // OTP
                      // =================================================

                      const GenerateOtpBanner(),

                      const SizedBox(height: 16),

                      // =================================================
                      // COMMUNITY
                      // =================================================

                      const CommunityPostsSection(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ========================================================
          // VISITOR APPROVAL POPUP
          // ========================================================

          CompositedTransformFollower(
            link: _headerAnchor,
            showWhenUnlinked: false,
            child: const VisitorNotificationSection(
              horizontalPadding: horizontalPadding,
            ),
          ),

          // ========================================================
          // KYC UPDATE POPUP / FLOATING CARD
          // ========================================================
          //
          // This is outside SingleChildScrollView.
          //
          // Therefore it:
          //   - stays at the bottom of Home
          //   - floats over the dashboard
          //   - does not scroll with dashboard content
          //   - does not push the dashboard content down
          //
          // This matches Scenario 2 in your flow.
          // ========================================================

          Positioned(
            left: 12,
            right: 12,
            bottom: 8,

            child: SafeArea(
              top: false,
              child: _buildKycUpdateCard(context),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KYC UPDATE CARD
  // ============================================================

  Widget _buildKycUpdateCard(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: KycUpdateCardSection(
        onUpdatePressed: () {
          _openKycFlow(context);
        },
      ),
    );
  }
}