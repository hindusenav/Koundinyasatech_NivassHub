import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../dashboard/data/models/notice_model.dart';
import '../../dashboard/presentation/widgets/navigation/dashboard_bottom_navigation.dart';

class NoticeDetailsScreen extends StatelessWidget {
  const NoticeDetailsScreen({
    super.key,
    required this.notice,
  });

  final NoticeModel notice;

  @override
  Widget build(BuildContext context) {
    String headerTitle = 'Notice 1';
    if (notice.noticeId == 'not_2') {
      headerTitle = 'Notice 2';
    } else if (notice.noticeId == 'not_3') {
      headerTitle = 'Notice 3';
    } else if (notice.title.contains('Notice')) {
      headerTitle = notice.title.split(' ').take(2).join(' ');
    }

    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: const DashboardBottomNavigation(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // =====================================================
              // HEADER CONTAINER (Height: 66px Hug, Color: #C7E3FF, Padding: Top 12px, Right 20px, Bottom 16px, Left 20px)
              // =====================================================
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: statusBarHeight > 0 ? statusBarHeight + 12 : 12,
                  left: 20,
                  right: 20,
                  bottom: 16,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFC7E3FF),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 6,
                      spreadRadius: 0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 38,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// NAVIGATION & GREETING CONTAINER (352px x 38px, Radius: 40px, Border: 1px #CCDFF2, Padding: Left 16px, Right 12px, Gap: 10px)
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                }
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Color(0xFF0F172A),
                                  size: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 38,
                                padding: const EdgeInsets.only(left: 16, right: 12),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(
                                    color: const Color(0xFFCCDFF2),
                                    width: 1.0,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    /// GREETING TEXT ("Notice Board", DM Sans 600 SemiBold, 18px, Line height: 100%)
                                    SizedBox(
                                      height: 23,
                                      child: Text(
                                        'Notice Board',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Color(0xFF0F172A),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          height: 1.0,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // =====================================================
              // MAIN SCROLLABLE CONTENT BODY (ORIGINAL POST CONTAINER)
              // =====================================================
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Notice Card Container matching Figma Screen 2
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF2DD4BF).withValues(alpha: .5),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Notice Header Row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 42,
                                  width: 42,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0F2FE),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: .06),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.assignment_add,
                                    color: Color(0xFF0F172A),
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        headerTitle,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF0F172A),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              notice.postedBy,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            notice.date,
                                            style: const TextStyle(
                                              color: Color(0xFF94A3B8),
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.more_vert,
                                  color: Color(0xFF0F172A),
                                  size: 20,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Orange Divider Line
                            Container(
                              height: 2,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE57C00),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Title & Full Content Body
                            Text(
                              notice.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xFF0F172A),
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              notice.body,
                              style: const TextStyle(
                                color: Color(0xFF334155),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.6,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                              style: TextStyle(
                                color: Color(0xFF334155),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.6,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                              style: TextStyle(
                                color: Color(0xFF334155),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.6,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 20),

                            /// CTA-BUTTON (Height: 48px, Radius: 12px, Color: Blue 1 #0060BD)
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Downloading notice PDF...'),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0060BD),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                icon: const Icon(
                                  Icons.download,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                label: const Text(
                                  'Download PDF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
