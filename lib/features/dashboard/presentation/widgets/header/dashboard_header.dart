import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_provider.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    final user = provider.home?.data.user;
    final addresses = provider.addresses;

    final flatLabel = addresses.isNotEmpty
        ? addresses.firstWhere(
            (e) => e.isDefault,
            orElse: () => addresses.first,
          ).flatNumber
        : (user?.flatNumber ?? 'B - 402');

    final statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Container(
        width: double.infinity,
        height: 106 + statusBarHeight,
        decoration: const BoxDecoration(
          color: Color(0xFFC7E1F8),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: statusBarHeight,
            left: 13,
            right: 13,
            bottom: 12,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // =====================================================
                  // USER DETAILS
                  // =====================================================

                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // =================================================
                        // HELLO USER NAME
                        // =================================================

                        Text(
                          'Hello! ${user?.name ?? 'User name'} 👋',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F1F1F),
                            height: 1.15,
                            letterSpacing: 0.05,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // =================================================
                        // CHAT + B-402 + DROPDOWN
                        // =================================================

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ---------------------------------------------
                            // CHAT IMAGE
                            // ---------------------------------------------

                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                // TODO: Chat action
                              },
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                  'assets/icons/chat.png',
                                  width: 18,
                                  height: 18,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            const SizedBox(width: 5),

                            // ---------------------------------------------
                            // B - 402
                            // ---------------------------------------------

                            Text(
                              flatLabel.isNotEmpty
                                  ? flatLabel
                                  : 'B - 402',
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4A4A4A),
                                height: 1.1,
                                letterSpacing: 0.1,
                              ),
                            ),

                            const SizedBox(width: 3),

                            // ---------------------------------------------
                            // DROPDOWN
                            // ---------------------------------------------

                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 13,
                              color: Color(0xFF222222),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // =====================================================
                  // SEARCH
                  // =====================================================

                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // TODO: Search action
                    },
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: Center(
                        child: Image.asset(
                          'assets/icons/search.png',
                          width: 17,
                          height: 17,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 5),

                  // =====================================================
                  // NOTIFICATION
                  // =====================================================

                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // TODO: Notification action
                    },
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: Center(
                        child: Image.asset(
                          'assets/icons/notification.png',
                          width: 19,
                          height: 19,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 5),

                  // =====================================================
                  // PROFILE
                  // =====================================================

                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // TODO: Profile action
                    },
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset(
                        'assets/icons/profile.png',
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}