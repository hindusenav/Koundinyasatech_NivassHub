import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
  });

  // ============================================================
  // COLORS
  // ============================================================

  static const Color _headerBlueLight = AppColors.dashboardHeaderLight;
  static const Color _headerBlueDark = AppColors.dashboardHeaderDark;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerBlue = isDark ? _headerBlueDark : _headerBlueLight;
    final headerTextColor =
        isDark ? AppColors.textPrimaryDark : const Color(0xFF1F1F1F);

    final user = provider.home?.data.user;
    final addresses = provider.addresses;

    // ============================================================
    // FLAT NUMBER
    // ============================================================

    final flatLabel = addresses.isNotEmpty
        ? addresses.firstWhere(
            (e) => e.isDefault,
            orElse: () => addresses.first,
          ).flatNumber
        : (user?.flatNumber ?? 'B - 402');

    // ============================================================
    // HEADER
    // ============================================================

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: headerBlue,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),

      child: Container(
        // ========================================================
        // FULL AVAILABLE WIDTH
        // ========================================================

        width: double.infinity,

        // ========================================================
        // HEADER HEIGHT
        //
        // No fixed height here — the header sizes itself from its
        // content (SafeArea inset + padding + the two-line greeting
        // block). A hard-coded height risked the content overflowing
        // past this box on devices with a taller status bar, and
        // since Container defaults to Clip.none, that overflow would
        // paint straight through into the section below instead of
        // being cropped.
        // ========================================================

        clipBehavior: Clip.antiAlias,

        decoration: BoxDecoration(
          color: headerBlue,

          // ======================================================
          // FIGMA BOTTOM ROUNDED CORNERS
          // ======================================================

          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),

          // ======================================================
          // HEADER SHADOW
          // ======================================================

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.32 : 0.12),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        // ========================================================
        // SAFE AREA
        // ========================================================

        child: SafeArea(
          top: true,
          left: false,
          right: false,
          bottom: false,

          child: Padding(
            padding: const EdgeInsets.only(
              left: 18,
              right: 14,
              top: 12,
              bottom: 11,
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // ==================================================
                // USER INFORMATION
                // ==================================================

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // =============================================
                      // HELLO USER
                      // =============================================

                      Text(
                        'Hello! ${user?.name ?? 'User name'} 👋',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: headerTextColor,
                          height: 1.15,
                          letterSpacing: 0.05,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // =============================================
                      // FLAT NUMBER
                      // =============================================

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // -----------------------------------------
                          // CHAT IMAGE
                          // -----------------------------------------
                          // Changed ONLY this image:
                          // profile.png -> chat.png
                          // -----------------------------------------

                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.profile,
                              );
                            },

                            child: SizedBox(
                              width: 20,
                              height: 20,

                              child: Image.asset(
                                'assets/icons/chat.png',
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,

                                errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                                  return Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 18,
                                    color: headerTextColor,
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(width: 7),

                          // -----------------------------------------
                          // FLAT NUMBER
                          // -----------------------------------------

                          Text(
                            flatLabel.isNotEmpty
                                ? flatLabel
                                : 'B - 402',

                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: headerTextColor,
                              height: 1.1,
                            ),
                          ),

                          const SizedBox(width: 2),

                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 14,
                            color: headerTextColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ==================================================
                // RIGHT SIDE ICONS
                // ==================================================

                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ==============================================
                    // SEARCH
                    // ==============================================

                    GestureDetector(
                      behavior: HitTestBehavior.opaque,

                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.search,
                        );
                      },

                      child: SizedBox(
                        width: 30,
                        height: 30,

                        child: Center(
                          child: Image.asset(
                            'assets/icons/search.png',

                            width: 19,
                            height: 19,

                            fit: BoxFit.contain,

                            // Dark line-art PNG with a transparent
                            // background — invisible on a dark header
                            // unless tinted.
                            color: isDark ? headerTextColor : null,

                            errorBuilder: (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return Icon(
                                Icons.search_rounded,
                                size: 19,
                                color: headerTextColor,
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 2),

                    // ==============================================
                    // NOTIFICATION
                    // ==============================================

                    GestureDetector(
                      behavior: HitTestBehavior.opaque,

                      onTap: () {
                        CustomSnackbar.info(
                          context,
                          'Notifications coming soon.',
                        );
                      },

                      child: SizedBox(
                        width: 30,
                        height: 30,

                        child: Center(
                          child: Image.asset(
                            'assets/icons/notification.png',

                            width: 20,
                            height: 20,

                            fit: BoxFit.contain,

                            // Dark line-art PNG with a transparent
                            // background — invisible on a dark header
                            // unless tinted.
                            color: isDark ? headerTextColor : null,

                            errorBuilder: (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 19,
                                color: headerTextColor,
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    // ==============================================
                    // RIGHT SIDE ORANGE PROFILE A
                    // KEEPING THIS UNCHANGED
                    // ==============================================

                    GestureDetector(
                      behavior: HitTestBehavior.opaque,

                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.profile,
                        );
                      },

                      child: Container(
                        width: 22,
                        height: 22,

                        alignment: Alignment.center,

                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFA000),
                        ),

                        child: const Text(
                          'A',

                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(255, 5, 5, 5),
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}