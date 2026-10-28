import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_navigation_provider.dart';

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
          height: 68,
          decoration: BoxDecoration(
            gradient: AppColors.navGradient,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowSoft,
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

  static const _tabRoutes = [
    AppRoutes.dashboard,
    AppRoutes.visitorList,
    AppRoutes.noticeList,
    AppRoutes.payments,
    AppRoutes.quickActions,
  ];

  /// Switches tab. Works both inside a route (sub-page bars) and from the
  /// persistent bar hosted above the Navigator (no Navigator in `context`).
  void _onTap(
    BuildContext context,
    DashboardNavigationProvider provider,
    int index,
  ) {
    final navigator =
        NavigationService.navigatorKey.currentState ?? Navigator.of(context);
    final current =
        provider.currentRoute ?? ModalRoute.of(context)?.settings.name;
    final target = _tabRoutes[index];

    // Already on this tab (Visitors has two route names).
    if (current == target ||
        (index == 1 && current == AppRoutes.activities)) {
      return;
    }

    provider.changeIndex(index);

    if (index == 0) {
      navigator.popUntil(ModalRoute.withName(AppRoutes.dashboard));
    } else if (current != null &&
        current != AppRoutes.dashboard &&
        DashboardNavigationProvider.tabRoutes.contains(current)) {
      // Tab -> tab: replace instead of stacking, so Back goes Home.
      navigator.pushReplacementNamed(target);
    } else {
      navigator.pushNamed(target);
    }
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
    final activeBlue = AppColors.primaryOrange;
    final inactiveColor = selected ? AppColors.primaryOrange : AppColors.cardBorder.withValues(alpha: 0.6);

    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,

        onTap: () => _onTap(context, provider, index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// ICON BACKGROUND
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: selected ? activeBlue.withValues(alpha: 0.16) : Colors.transparent,
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: activeBlue.withValues(alpha: 0.35),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  image,
                  width: 18,
                  height: 18,
                  fit: BoxFit.contain,
                  color: inactiveColor,
                  filterQuality: FilterQuality.high,
                  isAntiAlias: true,
                  errorBuilder: (_, _, _) {
                    return Icon(
                      Icons.circle_outlined,
                      size: 18,
                      color: inactiveColor,
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
