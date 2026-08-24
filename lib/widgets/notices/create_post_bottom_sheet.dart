import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/screens/notices/create_event_screen.dart';
import 'package:flutter_nivasshub/screens/notices/create_poll_screen.dart';
import 'package:flutter_nivasshub/screens/notices/create_post_screen.dart';

/// Modal bottom sheet matching Figma "Create a community post" menu.
class CreateCommunityPostBottomSheet extends StatelessWidget {
  const CreateCommunityPostBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const CreateCommunityPostBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headingColor =
        isDark ? AppColors.noticesHeadingDark : Colors.black87;
    final secondaryColor =
        isDark ? AppColors.textSecondaryDark : Colors.grey.shade600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.grey700 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Create a community post',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: headingColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose a post format to engage with your neighbors',
            style: TextStyle(fontSize: 13, color: secondaryColor),
          ),
          const SizedBox(height: 20),
          _OptionCard(
            icon: Icons.edit_outlined,
            iconColor:
                isDark ? AppColors.communityAccentBlueDark : AppColors.communityAccentBlueLight,
            iconBg: isDark ? AppColors.noticesBlueTintBgDark : AppColors.noticesBlueTintBgLight,
            title: 'Create Post',
            subtitle: 'Share news, updates, or helpful recommendations',
            onTap: () {
              final nav = Navigator.of(context);
              nav.pop();
              nav.push(
                MaterialPageRoute(builder: (_) => const CreatePostScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          _OptionCard(
            icon: Icons.bar_chart_outlined,
            iconColor: isDark ? AppColors.noticesAccentBlueDark : AppColors.noticesAccentBlueLight,
            iconBg: isDark ? AppColors.noticesAppBarDark : AppColors.noticesAppBarLight,
            title: 'Create Poll',
            subtitle: 'Get quick feedback or vote on community matters',
            onTap: () {
              final nav = Navigator.of(context);
              nav.pop();
              nav.push(
                MaterialPageRoute(builder: (_) => const CreatePollScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          _OptionCard(
            icon: Icons.calendar_today_outlined,
            iconColor:
                isDark ? AppColors.communityAccentBlueDark : AppColors.communityAccentBlueLight,
            iconBg: isDark ? AppColors.noticesBlueTintBgDark : AppColors.noticesBlueTintBgLight,
            title: 'Host an Event',
            subtitle: 'Invite residents to gatherings or meetings',
            onTap: () {
              final nav = Navigator.of(context);
              nav.pop();
              nav.push(
                MaterialPageRoute(builder: (_) => const CreateEventScreen()),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? AppColors.noticesCardBorderDark : AppColors.noticesCardBorderLight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark ? AppColors.noticesHeadingDark : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
