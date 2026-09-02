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
        width: double.infinity,
        clipBehavior: Clip.antiAlias,

        decoration: BoxDecoration(
          color: headerBlue,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.32 : 0.12),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: SafeArea(
          top: true,
          left: false,
          right: false,
          bottom: false,

          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 16,
              top: 20,
              bottom: 18,
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ==================================================
                // USER INFORMATION
                // ==================================================

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // =============================================
                      // HELLO USER WITH WAVE EMOJI
                      // =============================================

                      Text(
                        'Hello! ${user?.name ?? 'User name'} 👋',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: headerTextColor,
                          height: 1.2,
                          letterSpacing: 0.1,
                        ),
                      ),

                      const SizedBox(height: 8),

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

                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.profile,
                              );
                            },

                            child: SizedBox(
                              width: 24,
                              height: 24,

                              child: Image.asset(
                                'assets/icons/chat.png',
                                width: 24,
                                height: 24,
                                fit: BoxFit.contain,

                                errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                                  return Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 20,
                                    color: headerTextColor,
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // -----------------------------------------
                          // FLAT NUMBER
                          // -----------------------------------------

                          Text(
                            flatLabel.isNotEmpty
                                ? flatLabel
                                : 'B - 402',

                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: headerTextColor,
                              height: 1.2,
                              letterSpacing: 0.3,
                            ),
                          ),

                          const SizedBox(width: 4),

                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: headerTextColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ==================================================
                // RIGHT SIDE ICONS - ALL EQUAL GAPS
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
                        width: 34,
                        height: 34,

                        child: Center(
                          child: Image.asset(
                            'assets/icons/search.png',

                            width: 22,
                            height: 22,

                            fit: BoxFit.contain,

                            color: isDark ? headerTextColor : null,

                            errorBuilder: (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return Icon(
                                Icons.search_rounded,
                                size: 22,
                                color: headerTextColor,
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8), // Gap 1

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
                        width: 34,
                        height: 34,

                        child: Center(
                          child: Image.asset(
                            'assets/icons/notification.png',

                            width: 22,
                            height: 22,

                            fit: BoxFit.contain,

                            color: isDark ? headerTextColor : null,

                            errorBuilder: (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return Icon(
                                Icons.notifications_none_rounded,
                                size: 22,
                                color: headerTextColor,
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8), // Gap 2 - SAME GAP as between search and notification

                    // ==============================================
                    // RIGHT SIDE ORANGE PROFILE A
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
                        width: 28,
                        height: 28,

                        alignment: Alignment.center,

                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFA000),
                        ),

                        child: const Text(
                          'A',

                          style: TextStyle(
                            fontSize: 14,
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