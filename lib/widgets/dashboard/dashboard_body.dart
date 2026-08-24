import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/widgets/notifications/visitor_notification_section.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/widgets/dashboard/approval_queue/approval_queue_section.dart';
import 'package:flutter_nivasshub/widgets/dashboard/banner/banner_card.dart';
=======
import 'package:flutter_nivasshub/widgets/notifications/visitor_notification_section.dart';
import 'package:flutter_nivasshub/widgets/dashboard/approval_queue/approval_queue_section.dart';
>>>>>>> f48df002e16cc94f3c12ba1e2f58d88dad4cc4bf
import 'package:flutter_nivasshub/widgets/dashboard/banner/banner_slider.dart';
import 'package:flutter_nivasshub/widgets/dashboard/community/community_posts_section.dart';
import 'package:flutter_nivasshub/widgets/dashboard/header/dashboard_header.dart';
import 'package:flutter_nivasshub/widgets/dashboard/maintenance/maintenance_card.dart';
import 'package:flutter_nivasshub/widgets/dashboard/otp/generate_otp_banner.dart';
import 'package:flutter_nivasshub/widgets/dashboard/panic/panic_sos_banner.dart';
import 'package:flutter_nivasshub/widgets/dashboard/quick_actions/quick_actions_grid.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({
    super.key,
  });

  // ============================================================
  // HEADER HEIGHT ESTIMATE
  //
  // DashboardHeader no longer has a fixed height (it sizes itself
  // to its content — see DashboardHeader), so the popup below can't
  // just anchor to a known constant. Layered via a CompositedTransform
  // pair instead (see `_headerAnchor` below), which tracks the
  // header's actual on-screen position/size regardless of how tall
  // it renders — no hard-coded offset to keep in sync.
  // ============================================================

  static final LayerLink _headerAnchor = LayerLink();

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final provider = context.watch<DashboardProvider>();

    final banners = provider.advertisementBanners;

=======
>>>>>>> f48df002e16cc94f3c12ba1e2f58d88dad4cc4bf
    // ============================================================
    // RESPONSIVE CONTENT PADDING
    // ============================================================

    final horizontalPadding = 16.0;

    return Container(
      width: double.infinity,
      color: const Color(0xFFF7F8FC),

      // ==========================================================
      // POPUP LAYER
      //
      // The visitor-approval "toast" is stacked ON TOP of the
      // scrolling dashboard content — a Stack sibling, not a Column
      // child — so it floats over the page and never reserves or
      // consumes the space between the header and the promo banner,
      // whether it's showing or not. See `VisitorNotificationSection`.
      // ==========================================================

      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            // ========================================================
            // IMPORTANT:
            // NO LEFT / RIGHT PADDING HERE
            //
            // This allows DashboardHeader to reach both screen edges.
            // ========================================================

            padding: const EdgeInsets.only(
              bottom: 20,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // HEADER
                //
                // FULL SCREEN WIDTH
                // NO SIDE GAP
                //
                // Wrapped in a CompositedTransformTarget so the
                // floating popup below can anchor to its bottom edge
                // without needing to know its height up front.
                // ==================================================

                CompositedTransformTarget(
                  link: _headerAnchor,
                  child: const DashboardHeader(),
                ),

                // ==================================================
                // REST OF DASHBOARD
                //
                // SIDE PADDING STARTS FROM HERE
                // ==================================================

                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    16,
                    horizontalPadding,
                    0,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==============================================
                      // ONLINE ADVERTISEMENT
                      // ==============================================

                      const BannerSlider(),

                      const SizedBox(height: 16),

                      // ==============================================
                      // QUICK ACTIONS
                      // ==============================================

                      const QuickActionsGrid(),

                      const SizedBox(height: 16),

                      // ==============================================
                      // MAINTENANCE
                      // ==============================================

                      const MaintenanceCard(),

                      const SizedBox(height: 16),

                      // ==============================================
                      // APPROVAL QUEUE
                      // ==============================================

                      const ApprovalQueueSection(),

                      const SizedBox(height: 16),

                      // ==============================================
                      // PANIC
                      // ==============================================

                      const PanicSosBanner(),

                      const SizedBox(height: 16),

                      // ==============================================
                      // OTP
                      // ==============================================

                      const GenerateOtpBanner(),

<<<<<<< HEAD
                      // ==============================================
                      // ADVERTISEMENT
                      // ==============================================

                      if (banners.isNotEmpty) ...[
                        const SizedBox(height: 16),

                        BannerCard(
                          banner: banners.first,
                        ),
                      ],

=======
>>>>>>> f48df002e16cc94f3c12ba1e2f58d88dad4cc4bf
                      const SizedBox(height: 16),

                      // ==============================================
                      // COMMUNITY
                      // ==============================================

                      const CommunityPostsSection(),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ========================================================
          // VISITOR APPROVAL POPUP
          //
          // Floats over the scrollable content, anchored to the
          // header's bottom-left corner via `_headerAnchor` — a
          // genuine popup/toast: it does not push the promo banner
          // down while visible, and leaves no gap behind once
          // dismissed or when there's nothing pending. See
          // `VisitorNotificationSection`.
          // ========================================================

          CompositedTransformFollower(
            link: _headerAnchor,
            showWhenUnlinked: false,
            child: VisitorNotificationSection(
              horizontalPadding: horizontalPadding,
            ),
          ),
        ],
      ),
    );
  }
}
