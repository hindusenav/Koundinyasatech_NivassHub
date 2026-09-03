// import 'package:flutter/material.dart';
// import 'package:flutter_nivasshub/widgets/notifications/visitor_notification_section.dart';
// import 'package:flutter_nivasshub/widgets/dashboard/approval_queue/approval_queue_section.dart';
// import 'package:flutter_nivasshub/widgets/dashboard/banner/banner_slider.dart';
// import 'package:flutter_nivasshub/widgets/dashboard/community/community_posts_section.dart';
// import 'package:flutter_nivasshub/widgets/dashboard/header/dashboard_header.dart';
// import 'package:flutter_nivasshub/widgets/dashboard/maintenance/maintenance_card.dart';
// import 'package:flutter_nivasshub/widgets/dashboard/otp/generate_otp_banner.dart';
// import 'package:flutter_nivasshub/widgets/dashboard/panic/panic_sos_banner.dart';
// import 'package:flutter_nivasshub/widgets/dashboard/quick_actions/quick_actions_grid.dart';
// import '../../widgets//dashboard//add_property/add_proper_section.dart';
// class DashboardBody extends StatelessWidget {
//   const DashboardBody({
//     super.key,
//   });

//   // ============================================================
//   // HEADER HEIGHT ESTIMATE
//   //
//   // DashboardHeader no longer has a fixed height (it sizes itself
//   // to its content — see DashboardHeader), so the popup below can't
//   // just anchor to a known constant. Layered via a CompositedTransform
//   // pair instead (see `_headerAnchor` below), which tracks the
//   // header's actual on-screen position/size regardless of how tall
//   // it renders — no hard-coded offset to keep in sync.
//   // ============================================================

//   static final LayerLink _headerAnchor = LayerLink();

//   @override
//   Widget build(BuildContext context) {
//     // ============================================================
//     // RESPONSIVE CONTENT PADDING
//     // ============================================================

//     final horizontalPadding = 16.0;

//     return Container(
//       width: double.infinity,
//       color: const Color(0xFFF7F8FC),

//       // ==========================================================
//       // POPUP LAYER
//       //
//       // The visitor-approval "toast" is stacked ON TOP of the
//       // scrolling dashboard content — a Stack sibling, not a Column
//       // child — so it floats over the page and never reserves or
//       // consumes the space between the header and the promo banner,
//       // whether it's showing or not. See `VisitorNotificationSection`.
//       // ==========================================================

//       child: Stack(
//         children: [
//           SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),

//             // ========================================================
//             // IMPORTANT:
//             // NO LEFT / RIGHT PADDING HERE
//             //
//             // This allows DashboardHeader to reach both screen edges.
//             // ========================================================

//             padding: const EdgeInsets.only(
//               bottom: 20,
//             ),

//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ==================================================
//                 // HEADER
//                 //
//                 // FULL SCREEN WIDTH
//                 // NO SIDE GAP
//                 //
//                 // Wrapped in a CompositedTransformTarget so the
//                 // floating popup below can anchor to its bottom edge
//                 // without needing to know its height up front.
//                 // ==================================================

//                 CompositedTransformTarget(
//                   link: _headerAnchor,
//                   child: const DashboardHeader(),
//                 ),

//                 // ==================================================
//                 // REST OF DASHBOARD
//                 //
//                 // SIDE PADDING STARTS FROM HERE
//                 // ==================================================

//                 Padding(
//                   padding: EdgeInsets.fromLTRB(
//                     horizontalPadding,
//                     16,
//                     horizontalPadding,
//                     0,
//                   ),

//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // ==============================================
//                       // ONLINE ADVERTISEMENT
//                       // ==============================================

//                       const BannerSlider(),

//                       const SizedBox(height: 16),

//                       // ==============================================
//                       // QUICK ACTIONS
//                       // ==============================================

//                       const QuickActionsGrid(),

//                       const SizedBox(height: 16),

//                       // ==============================================
//                       // MAINTENANCE
//                       // ==============================================

//                       const MaintenanceCard(),

//                       const SizedBox(height: 16),

//                       // ==============================================
//                       // APPROVAL QUEUE
//                       // ==============================================

//                       const ApprovalQueueSection(),

//                       const SizedBox(height: 16),

//                       // ==============================================
//                       // PANIC
//                       // ==============================================

//                       const PanicSosBanner(),

//                       const SizedBox(height: 16),

//                       // ==============================================
//                       // OTP
//                       // ==============================================

//                       const GenerateOtpBanner(),

//                       const SizedBox(height: 16),

//                       // ==============================================
//                       // COMMUNITY
//                       // ==============================================

//                       const CommunityPostsSection(),

//                       const SizedBox(height: 16),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // ========================================================
//           // VISITOR APPROVAL POPUP
//           //
//           // Floats over the scrollable content, anchored to the
//           // header's bottom-left corner via `_headerAnchor` — a
//           // genuine popup/toast: it does not push the promo banner
//           // down while visible, and leaves no gap behind once
//           // dismissed or when there's nothing pending. See
//           // `VisitorNotificationSection`.
//           // ========================================================

//           CompositedTransformFollower(
//             link: _headerAnchor,
//             showWhenUnlinked: false,
//             child: VisitorNotificationSection(
//               horizontalPadding: horizontalPadding,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

////////////////////////////


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

// KYC UPDATE CARD
import "../../widgets/dashboard/kyc_update_card/kyc_update_card_section.dart";

// KYC NAVIGATION
import 'package:flutter_nivasshub/screens/kyc/select_country_screen.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({
    super.key,
  });

  // ============================================================
  // HEADER ANCHOR
  // ============================================================

  static final LayerLink _headerAnchor = LayerLink();

  // ============================================================
  // KYC CARD HEIGHT
  //
  // This is reserved at the bottom of the dashboard so that
  // scrolling content does not get hidden behind the fixed card.
  // ============================================================

  static const double _kycCardAreaHeight = 122.0;

  // ============================================================
  // OPEN KYC FLOW
  // ============================================================

  void _openKycFlow(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SelectCountryScreen(),
      ),
    );
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

            // Extra bottom space so the last dashboard content
            // remains visible above the fixed KYC card.
            padding: const EdgeInsets.only(
              bottom: _kycCardAreaHeight + 20,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

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
                // REST OF DASHBOARD
                // ==================================================

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    horizontalPadding,
                    16,
                    horizontalPadding,
                    0,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

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

                      // Some additional space before bottom overlay.
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
              horizontalPadding:
                  horizontalPadding,
            ),
          ),

          // ========================================================
          // FIXED KYC UPDATE CARD
          //
          // IMPORTANT:
          // This is OUTSIDE SingleChildScrollView.
          //
          // Therefore it stays fixed at the bottom of the
          // dashboard body and does NOT move into the middle.
          //
          // The actual Scaffold bottomNavigationBar appears
          // underneath this area automatically.
          // ========================================================

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,

            child: _buildFixedKycCard(
              context,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FIXED KYC CARD
  // ============================================================

  Widget _buildFixedKycCard(
    BuildContext context,
  ) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF181818)
        : Colors.white;

    return SafeArea(
      top: false,

      child: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          color: backgroundColor,

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(
                alpha: 0.10,
              ),
              blurRadius: 10,
              spreadRadius: 1,
              offset:
                  const Offset(0, -3),
            ),
          ],

          border: Border(
            top: BorderSide(
              color: isDark
                  ? Colors.white12
                  : const Color(
                      0xFFE6EAF0,
                    ),
              width: 1,
            ),
          ),
        ),

        padding:
            const EdgeInsets.fromLTRB(
          12,
          8,
          12,
          8,
        ),

        child: KycUpdateCardSection(
          onUpdatePressed: () {
            _openKycFlow(context);
          },
        ),
      ),
    );
  }
}