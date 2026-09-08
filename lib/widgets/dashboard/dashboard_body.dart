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
import 'package:flutter_nivasshub/routes/app_routes.dart';

// KYC Update Card
import 'package:flutter_nivasshub/widgets/dashboard/kyc_update_card/kyc_update_card_section.dart';

class DashboardBody extends StatefulWidget {
  const DashboardBody({
    super.key,
    required this.showKycCard,
  });

  /// Whether the floating "KYC Update" card should be shown. `false` once
  /// the user's KYC has been approved (Scenario 1); `true` while it's
  /// still incomplete (Scenario 2).
  final bool showKycCard;

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  static final LayerLink _headerAnchor = LayerLink();

  // ============================================================
  // KYC CARD HEIGHT
  //
  // Space reserved at the bottom of the scrollable dashboard
  // so the floating KYC card does not cover the last content.
  // ============================================================

  static const double _kycCardAreaHeight = 150.0;

  // ============================================================
  // ADD PROPERTY PANEL
  //
  // Hidden by default; toggled open/closed by tapping the header's
  // "B-402 ▾" row.
  // ============================================================

  bool _showPropertyPanel = false;

  void _togglePropertyPanel() {
    setState(() {
      _showPropertyPanel = !_showPropertyPanel;
    });
  }

  // ============================================================
  // KYC UPDATE ACTION
  // ============================================================

  void _openKycFlow(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.selectCountry);
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
                  child: DashboardHeader(
                    isPropertyPanelExpanded: _showPropertyPanel,
                    onTogglePropertyPanel: _togglePropertyPanel,
                  ),
                ),

                // ==================================================
                // ADD PROPERTY — hidden until the header's "B-402 ▾"
                // row is tapped.
                // ==================================================

                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: _showPropertyPanel
                      ? const AddPropertySection()
                      : const SizedBox(width: double.infinity),
                ),

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

          if (widget.showKycCard)
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