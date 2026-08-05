import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_navigation_provider.dart';

class DashboardBottomNavigation extends StatelessWidget {
  const DashboardBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardNavigationProvider>();

    return SafeArea(
      top: false,
      child: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color(0xffD9ECFF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 8,
            bottom: 4,
          ),
          child: Row(
            children: [
              _item(provider, 0, "assets/icons/home.svg.png", "Home"),
              _item(provider, 1, "assets/icons/visitors.svg.png", "Visitors"),
              _item(provider, 2, "assets/icons/community.svg.png", "Community"),
              _item(provider, 3, "assets/icons/payments.svg.png", "Payments"),
              _item(provider, 4, "assets/icons/more.svg.png", "More"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(
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
      onTap: () => provider.changeIndex(index),
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xff1565C0)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  image,
                  width: 18, // was 16
                  height: 18, // was 16
                  color: selected
                      ? Colors.white
                      : const Color(0xff5F6368),
                ),
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10, // was 9
                fontWeight: selected
                    ? FontWeight.w700
                    : FontWeight.w600,
                color: selected
                    ? const Color(0xff1565C0)
                    : const Color(0xff4B5563),
                letterSpacing: 0.2,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}