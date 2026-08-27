// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:flutter_nivasshub/constants/app_colors.dart';
// import 'package:flutter_nivasshub/routes/app_routes.dart';
// import 'package:flutter_nivasshub/providers/dashboard/dashboard_navigation_provider.dart';
// import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';

// class DashboardBottomNavigation extends StatelessWidget {
//   const DashboardBottomNavigation({super.key, this.selectedIndex});

//   final int? selectedIndex;

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<DashboardNavigationProvider>();
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final activeIndex = selectedIndex ?? provider.selectedIndex;

//     return SafeArea(
//       top: false,
//       child: Container(
//         height: 84,
//         decoration: BoxDecoration(
//           color: isDark ? const Color(0xFF1E293B) : const Color(0xFFC7E3FF),
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(24),
//             topRight: Radius.circular(24),
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _item(
//                 context,
//                 provider,
//                 activeIndex,
//                 0,
//                 "assets/icons/home.svg.png",
//                 "Home",
//                 isDark,
//               ),
//               _item(
//                 context,
//                 provider,
//                 activeIndex,
//                 1,
//                 "assets/icons/visitors.svg.png",
//                 "Visitors",
//                 isDark,
//               ),
//               _item(
//                 context,
//                 provider,
//                 activeIndex,
//                 2,
//                 "assets/icons/community.svg.png",
//                 "Community",
//                 isDark,
//               ),
//               _item(
//                 context,
//                 provider,
//                 activeIndex,
//                 3,
//                 "assets/icons/payments.svg.png",
//                 "Payments",
//                 isDark,
//               ),
//               _item(
//                 context,
//                 provider,
//                 activeIndex,
//                 4,
//                 "assets/icons/more.svg.png",
//                 "More",
//                 isDark,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _item(
//     BuildContext context,
//     DashboardNavigationProvider provider,
//     int activeIndex,
//     int index,
//     String image,
//     String title,
//     bool isDark,
//   ) {
//     final bool selected = activeIndex == index;
//     final activeBlue = isDark ? AppColors.noticesAccentBlueDark : const Color(0xFF0060BD);

//     return Expanded(
//       child: InkWell(
//         splashColor: Colors.transparent,
//         highlightColor: Colors.transparent,
//         onTap: () {
//           if (index == 1 || index == 3) {
//             // Visitors / Payments — screens don't exist yet.
//             CustomSnackbar.info(context, '$title coming soon.');
//             return;
//           }

//           if (index == 4) {
//             // More — settings screen
//             Navigator.pushNamed(context, AppRoutes.settings);
//             return;
//           }

//           if (index == 0) {
//             // Home — return to the existing Dashboard already in the stack
//             if (ModalRoute.of(context)?.settings.name != AppRoutes.dashboard) {
//               Navigator.popUntil(
//                 context,
//                 ModalRoute.withName(AppRoutes.dashboard),
//               );
//             }
//           } else if (index == 2) {
//             // Community — opens the full Community Feed / Notice Board.
//             if (ModalRoute.of(context)?.settings.name != AppRoutes.noticeList) {
//               Navigator.pushNamed(context, AppRoutes.noticeList);
//             }
//           }
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             /// ICON BACKGROUND
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               height: 40,
//               width: 40,
//               decoration: BoxDecoration(
//                 color: selected
//                     ? activeBlue
//                     : Colors.transparent,
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Image.asset(
//                   image,
//                   width: 22,
//                   height: 22,
//                   fit: BoxFit.contain,
//                   color: selected
//                       ? Colors.white
//                       : (isDark
//                           ? Colors.white70
//                           : const Color(0xFF475569)),
//                   filterQuality: FilterQuality.high,
//                   isAntiAlias: true,
//                   errorBuilder: (_, _, _) {
//                     return Icon(
//                       Icons.circle_outlined,
//                       size: 22,
//                       color: selected ? Colors.white : const Color(0xFF475569),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: 'DM Sans',
//                 fontSize: 11,
//                 fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
//                 color: selected
//                     ? activeBlue
//                     : (isDark
//                         ? AppColors.textSecondaryDark
//                         : const Color(0xFF475569)),
//                 letterSpacing: 0.2,
//                 height: 1.1,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

/////////////////////////////////

import 'package:flutter/material.dart';
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

    return SafeArea(
      top: false,
      child: Container(
        height: 84,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFC7E3FF),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
            ],
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
    final activeBlue = isDark
        ? AppColors.noticesAccentBlueDark
        : const Color(0xFF0060BD);

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
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: selected ? activeBlue : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  image,
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                  color: selected
                      ? Colors.white
                      : (isDark ? Colors.white70 : const Color(0xFF475569)),
                  filterQuality: FilterQuality.high,
                  isAntiAlias: true,
                  errorBuilder: (_, _, _) {
                    return Icon(
                      Icons.circle_outlined,
                      size: 22,
                      color: selected ? Colors.white : const Color(0xFF475569),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? activeBlue
                    : (isDark
                          ? AppColors.textSecondaryDark
                          : const Color(0xFF475569)),
                letterSpacing: 0.2,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
