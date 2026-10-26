import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';

import 'package:flutter_nivasshub/widgets/notifications/visitor_notification_section.dart';
import 'package:flutter_nivasshub/widgets/dashboard/approval_queue/approval_queue_section.dart';
import 'package:flutter_nivasshub/widgets/dashboard/resident/resident_summary_card.dart';
import 'package:flutter_nivasshub/widgets/dashboard/community/community_posts_section.dart';
import 'package:flutter_nivasshub/widgets/dashboard/header/dashboard_header.dart';
import 'package:flutter_nivasshub/widgets/dashboard/maintenance/maintenance_card.dart';
import 'package:flutter_nivasshub/widgets/dashboard/otp/generate_otp_banner.dart';
import 'package:flutter_nivasshub/widgets/dashboard/panic/panic_sos_banner.dart';
import 'package:flutter_nivasshub/widgets/dashboard/quick_actions/quick_actions_grid.dart';

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key, required this.showKycCard});

  /// Kept for call-site compatibility; the floating "KYC Update" card has
  /// been removed from Home, so this no longer affects rendering.
  final bool showKycCard;

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  static final LayerLink _headerAnchor = LayerLink();

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

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 16.0;

    return Container(
      width: double.infinity,
      color: FigmaColors.of(context).page,

      child: Stack(
        children: [
          // ========================================================
          // SCROLLABLE DASHBOARD
          // ========================================================
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            padding: const EdgeInsets.only(bottom: 24),

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
                // (the property name + "Add Flat/Villa/Office" now live in
                // the resident card below)

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
                      // RESIDENT CARD (tower, flat, add flat, stats)
                      // =================================================
                      ResidentSummaryCard(
                        isPropertyPanelExpanded: _showPropertyPanel,
                        onTogglePropertyPanel: _togglePropertyPanel,
                      ),

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
                      // OTP (Invite a guest)
                      // =================================================
                      const GenerateOtpBanner(),

                      const SizedBox(height: 16),

                      // =================================================
                      // PANIC SOS
                      // =================================================
                      const PanicSosBanner(),

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
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            link: _headerAnchor,
            showWhenUnlinked: false,
            child: const VisitorNotificationSection(
              horizontalPadding: horizontalPadding,
            ),
          ),
        ],
      ),
    );
  }
}
