import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_navigation_provider.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';

class DashboardBottomNavigation extends StatelessWidget {
  const DashboardBottomNavigation({super.key, this.selectedIndex});

  final int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardNavigationProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeIndex = selectedIndex ?? provider.selectedIndex;

    // Cap the system font scale so the bar keeps a fixed, compact height on
    // phones with large accessibility text.
    final mq = MediaQuery.of(context);
    return MediaQuery(
      data: mq.copyWith(textScaler: mq.textScaler.clamp(maxScaleFactor: 1.1)),
      child: SafeArea(
        top: false,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            gradient: isDark
                ? AppColors.amberGradientDark
                : AppColors.amberGradient,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x263E2F1C),
                blurRadius: 12,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _item(
                  context,
                  provider,
                  activeIndex,
                  0,
                  "assets/icons/home.svg.png",
                  "Home",
                  isDark,
                ),
                _item(
                  context,
                  provider,
                  activeIndex,
                  1,
                  "assets/icons/visitors.svg.png",
                  "Visitors",
                  isDark,
                ),
                _item(
                  context,
                  provider,
                  activeIndex,
                  2,
                  "assets/icons/community.svg.png",
                  "Community",
                  isDark,
                ),
                _item(
                  context,
                  provider,
                  activeIndex,
                  3,
                  "assets/icons/payments.svg.png",
                  "Payments",
                  isDark,
                ),
                _item(
                  context,
                  provider,
                  activeIndex,
                  4,
                  "assets/icons/more.svg.png",
                  "More",
                  isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    DashboardNavigationProvider provider,
    int activeIndex,
    int index,
    String image,
    String title,
    bool isDark,
  ) {
    final bool selected = activeIndex == index;
    final activeBlue = AppColors.orange;
    final inactiveColor = Colors.white;

    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,

        onTap: () {
          // Update the selected bottom-navigation index.
          provider.changeIndex(index);

          if (index == 3) {
            // Payments screen is not available yet.
            CustomSnackbar.info(context, '$title coming soon.');
            return;
          }

          if (index == 4) {
            // More — open the Quick Actions screen.
            if (ModalRoute.of(context)?.settings.name !=
                AppRoutes.quickActions) {
              Navigator.pushNamed(context, AppRoutes.quickActions);
            }
            return;
          }

          if (index == 1) {
            // Visitors — open the visitor list screen.
            if (ModalRoute.of(context)?.settings.name != AppRoutes.activities &&
                ModalRoute.of(context)?.settings.name !=
                    AppRoutes.visitorList) {
              Navigator.pushNamed(context, AppRoutes.visitorList);
            }
            return;
          }

          if (index == 0) {
            // Home — return to the existing Dashboard.
            if (ModalRoute.of(context)?.settings.name != AppRoutes.dashboard) {
              Navigator.popUntil(
                context,
                ModalRoute.withName(AppRoutes.dashboard),
              );
            }
          } else if (index == 2) {
            // Community — open the Community Feed / Notice Board.
            if (ModalRoute.of(context)?.settings.name != AppRoutes.noticeList) {
              Navigator.pushNamed(context, AppRoutes.noticeList);
            }
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// ICON BACKGROUND
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: selected ? activeBlue : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  image,
                  width: 18,
                  height: 18,
                  fit: BoxFit.contain,
                  color: Colors.white,
                  filterQuality: FilterQuality.high,
                  isAntiAlias: true,
                  errorBuilder: (_, _, _) {
                    return const Icon(
                      Icons.circle_outlined,
                      size: 18,
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: inactiveColor,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
