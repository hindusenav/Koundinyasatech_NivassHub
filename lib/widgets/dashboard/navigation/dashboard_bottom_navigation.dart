import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_navigation_provider.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';

class DashboardBottomNavigation extends StatelessWidget {
  const DashboardBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardNavigationProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Container(
        height: 90, // increased height for bigger icons
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.bottomNavBackgroundDark
              : AppColors.bottomNavBackgroundLight,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _item(context, provider, 0, "assets/icons/home.svg.png", "Home", isDark),
              _item(context, provider, 1, "assets/icons/visitors.svg.png", "Visitors", isDark),
              _item(context, provider, 2, "assets/icons/community.svg.png", "Community", isDark),
              _item(context, provider, 3, "assets/icons/payments.svg.png", "Payments", isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    DashboardNavigationProvider provider,
    int index,
    String image,
    String title,
    bool isDark,
  ) {
    final bool selected = provider.selectedIndex == index;

    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          if (index == 1 || index == 3) {
            // Visitors / Payments — screens don't exist yet.
            CustomSnackbar.info(context, '$title coming soon.');
            return;
          }

          if (index == 0) {
            // Home — return to the existing Dashboard already in the
            // stack instead of pushing a duplicate instance.
            // DashboardNavObserver updates the highlight once this pop
            // actually lands on the Dashboard route.
            if (ModalRoute.of(context)?.settings.name != AppRoutes.dashboard) {
              Navigator.popUntil(context, ModalRoute.withName(AppRoutes.dashboard));
            }
          } else if (index == 2) {
            // Community — opens the full Community Feed / Notice Board.
            // Guard against pushing a duplicate instance when the user
            // re-taps "Community" while already viewing it (this bottom
            // nav is also rendered on NoticesScreen itself) — without
            // this, Back had to pop through multiple stacked copies of
            // the same screen before it reached the real previous screen.
            // DashboardNavObserver updates the highlight once this push
            // actually lands on the Community route.
            if (ModalRoute.of(context)?.settings.name != AppRoutes.noticeList) {
              Navigator.pushNamed(context, AppRoutes.noticeList);
            }
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// 🔵 ICON BACKGROUND (bigger like Figma)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: selected
                    ? (isDark
                        ? AppColors.bottomNavSelectedDark
                        : AppColors.bottomNavSelectedLight)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  image,
                  width: 26, // 🔥 bigger icon
                  height: 26,
                  fit: BoxFit.contain,
                  color: selected
                      ? Colors.white
                      : (isDark ? AppColors.grey300 : AppColors.grey600), // darker = thicker feel
                ),
              ),
            ),

            const SizedBox(height: 6),

            /// 📝 LABEL
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight:
                    selected ? FontWeight.w700 : FontWeight.w600,
                color: selected
                    ? (isDark
                        ? AppColors.bottomNavSelectedDark
                        : AppColors.bottomNavSelectedLight)
                    : (isDark ? AppColors.grey300 : AppColors.grey700), // slightly darker
                letterSpacing: 0.2,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}