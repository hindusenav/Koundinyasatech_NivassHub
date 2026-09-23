import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/models/dashboard/notice_model.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';

class NoticeDetailsScreen extends StatelessWidget {
  const NoticeDetailsScreen({
    super.key,
    required this.notice,
  });

  final NoticeModel notice;

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headingColor =
        isDark ? AppColors.noticesHeadingDark : AppColors.noticesHeadingLight;
    final mutedColor =
        isDark ? AppColors.noticesMutedDark : AppColors.noticesMutedLight;
    final bodyColor =
        isDark ? AppColors.noticesBodyTextDark : AppColors.noticesBodyTextLight;

    String headerTitle = 'Notice 1';
    if (notice.noticeId == 'not_2') {
      headerTitle = 'Notice 2';
    } else if (notice.noticeId == 'not_3') {
      headerTitle = 'Notice 3';
    } else if (notice.title.contains('Notice')) {
      headerTitle = notice.title.split(' ').take(2).join(' ');
    }

    String greetingTitle = 'Notice Board';
    if (notice.noticeId.toLowerCase().contains('ad') ||
        notice.title.toLowerCase().contains('advertisement') ||
        notice.title.toLowerCase().contains('ad')) {
      greetingTitle = 'Advertisement Details';
    }

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.noticesBackgroundDark : AppColors.noticesBackgroundLight,
      bottomNavigationBar: const DashboardBottomNavigation(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Header Container matching Figma specs
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: statusBarHeight > 0 ? statusBarHeight + 12 : 12,
                  right: 20,
                  bottom: 16,
                  left: 20,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.dashboardHeaderDark : const Color(0xFFC7E3FF),
                ),
              child: Row(
                children: [
                  // Back Button
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.arrow_back,
                        color: headingColor,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Greeting Container (Title Pill)
                  Expanded(
                    child: Container(
                      height: 38,
                      padding: const EdgeInsets.only(left: 16, right: 12),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: isDark
                              ? AppColors.borderDark
                              : const Color(0xFFCCDFF2),
                          width: 1,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          greetingTitle,
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            color: isDark
                                ? AppColors.noticesHeadingDark
                                : const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            height: 1.0,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notice Card Container (Post Container matching Figma specs)
            Container(
              padding: const EdgeInsets.only(
                top: 24,
                right: 22,
                bottom: 24,
                left: 22,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: (isDark
                          ? AppColors.noticesTealAccentDark
                          : AppColors.noticesTealAccentLight)
                      .withValues(alpha: .5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? .3 : .03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notice Header Row (Header Left, 60px height)
                  SizedBox(
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Post Icon Container (48x48, radius 12, padding 10, bg #E8F4FF, shadow (4,4,4,0 15%))
                        Container(
                          height: 48,
                          width: 48,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.noticesAppBarDark
                                : const Color(0xFFE8F4FF),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 4,
                                spreadRadius: 0,
                                offset: const Offset(4, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.assignment_add,
                            color: isDark
                                ? headingColor
                                : const Color(0xFF05234D),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Text Post Title (DM Sans 500 Medium 20px height 1.2 #05234D)
                              Text(
                                headerTitle,
                                style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  height: 1.2,
                                  letterSpacing: 0,
                                  color: isDark
                                      ? headingColor
                                      : const Color(0xFF05234D),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Metadata Row (gap 12px)
                              Row(
                                children: [
                                  // Post Admin Container (#05234D, padding 4/8/4/8, radius 6px)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF05234D),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      notice.postedBy,
                                      style: const TextStyle(
                                        fontFamily: 'DM Sans',
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Text Post Date (DM Sans 400 Regular 13px height 1.0 #3D3D3D)
                                  Text(
                                    notice.date,
                                    style: TextStyle(
                                      fontFamily: 'DM Sans',
                                      color: isDark
                                          ? mutedColor
                                          : const Color(0xFF3D3D3D),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      height: 1.0,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Post More Options Icon Container (40x40, radius 8px, padding 8px, icon #05234D)
                        Container(
                          height: 40,
                          width: 40,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.more_vert,
                            color: isDark
                                ? headingColor
                                : const Color(0xFF05234D),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Notice Accent Strip (#EC9211, height 2px, radius 16px)
                  Container(
                    height: 2,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.noticesAmberDark
                          : const Color(0xFFEC9211),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Text Post Subtitle (DM Sans 500 Medium 16px height 1.0 #000000)
                  Text(
                    notice.title.startsWith('Notice') || notice.title.isEmpty
                        ? 'Expense report for quarter ending on June 2026'
                        : notice.title,
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 1.0,
                      letterSpacing: 0,
                      color: isDark
                          ? headingColor
                          : const Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Text Post Description Body (DM Sans 400 Regular 14px height 1.6 #000000 - 3 paragraphs matching Figma)
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.6,
                      letterSpacing: 0,
                      color: isDark
                          ? bodyColor
                          : const Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.6,
                      letterSpacing: 0,
                      color: isDark
                          ? bodyColor
                          : const Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.6,
                      letterSpacing: 0,
                      color: isDark
                          ? bodyColor
                          : const Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Download PDF Primary Button (cta-button matching Figma specs: 48px height, 12px radius, #0060BD)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Downloading notice PDF...'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? AppColors.noticesAccentBlueDark
                            : const Color(0xFF0060BD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.file_download_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Download PDF',
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              height: 1.0,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
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
