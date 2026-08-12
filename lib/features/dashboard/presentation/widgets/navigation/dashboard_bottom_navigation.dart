import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../app/app_routes.dart';
import '../../provider/dashboard_navigation_provider.dart';

class DashboardBottomNavigation extends StatelessWidget {
  const DashboardBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardNavigationProvider>();

    return SafeArea(
      top: false,
      child: Container(
        height: 90, // increased height for bigger icons
        decoration: const BoxDecoration(
          color: Color(0xffD9ECFF),
          borderRadius: BorderRadius.only(
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
              _item(context, provider, 0, "assets/icons/home.svg.png", "Home"),
              _item(context, provider, 1, "assets/icons/visitors.svg.png", "Visitors"),
              _item(context, provider, 2, "assets/icons/community.svg.png", "Community"),
              _item(context, provider, 3, "assets/icons/payments.svg.png", "Payments"),
              _item(context, provider, 4, "assets/icons/more.svg.png", "More"),
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
  ) {
    final bool selected = provider.selectedIndex == index;

    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          provider.changeIndex(index);

          if (index == 2) {
            // Community — opens the full Community Feed / Notice Board.
            Navigator.pushNamed(context, AppRoutes.noticeList);
          } else if (index == 4) {
            // More — opens the full Quick Actions catalog directly.
            Navigator.pushNamed(context, AppRoutes.quickActions);
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
                    ? const Color(0xff1565C0)
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
                      : const Color(0xff4B5563), // darker = thicker feel
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
                    ? const Color(0xff1565C0)
                    : const Color(0xff374151), // slightly darker
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