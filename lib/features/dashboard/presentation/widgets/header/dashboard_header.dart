import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../app/app_routes.dart';
import '../../../../../shared/widgets/feedback/custom_snackbar.dart';
import '../../provider/dashboard_provider.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
  });

  // ============================================================
  // COLORS
  // ============================================================

  static const Color _headerBlue = Color(0xFFC7E1F8);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

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
      value: const SystemUiOverlayStyle(
        statusBarColor: _headerBlue,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),

      child: Container(
        // ========================================================
        // FULL AVAILABLE WIDTH
        // ========================================================

        width: double.infinity,

        // ========================================================
        // HEADER HEIGHT
        // ========================================================

        height: 70,

        decoration: BoxDecoration(
          color: _headerBlue,

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
              color: Colors.black.withOpacity(0.12),
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
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F1F1F),
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
                                  return const Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 18,
                                    color: Color.fromARGB(255, 9, 9, 9),
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

                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 9, 9, 9),
                              height: 1.1,
                            ),
                          ),

                          const SizedBox(width: 2),

                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 14,
                            color: Color(0xFF222222),
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

                            errorBuilder: (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return const Icon(
                                Icons.search_rounded,
                                size: 19,
                                color: Color.fromARGB(255, 11, 11, 11),
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

                            errorBuilder: (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return const Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 19,
                                color: Color.fromARGB(255, 8, 8, 8),
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