import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/screens/notices/create_event_screen.dart';
import 'package:flutter_nivasshub/screens/notices/create_poll_screen.dart';
import 'package:flutter_nivasshub/screens/notices/create_post_screen.dart';

/// Section component matching Figma Screen ("Community Posts").
class CreateCommunityPostHeaderCard extends StatelessWidget {
  const CreateCommunityPostHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headingColor =
        isDark ? AppColors.noticesHeadingDark : AppColors.noticesHeadingLight;
    final secondaryColor =
        isDark ? AppColors.noticesSecondaryTextDark : AppColors.noticesSecondaryTextLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        const SizedBox(height: 16),
        _OptionCard(
          icon: Icons.edit_outlined,
          title: 'Create Post',
          subtitle: 'Share news, updates, or helpful recommendations',
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const CreatePostScreen()));
          },
        ),
        const SizedBox(height: 12),
        _OptionCard(
          icon: Icons.bar_chart_rounded,
          title: 'Create Poll',
          subtitle: 'Get quick feedback or vote on community matters',
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const CreatePollScreen()));
          },
        ),
        const SizedBox(height: 12),
        _OptionCard(
          icon: Icons.calendar_today_outlined,
          title: 'Host an Event',
          subtitle: 'Invite residents to gatherings or meetings',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CreateEventScreen()),
            );
          },
        ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headingColor =
        isDark ? AppColors.noticesHeadingDark : AppColors.noticesHeadingLight;
    final secondaryColor =
        isDark ? AppColors.noticesSecondaryTextDark : AppColors.noticesSecondaryTextLight;
    final accentBlue =
        isDark ? AppColors.noticesAccentBlueDark : AppColors.noticesAccentBlueLight;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.noticesDividerDark : AppColors.noticesDividerLight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: isDark ? .3 : .04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.noticesBlueTintBgDark
                        : AppColors.noticesBlueTintBgLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? AppColors.noticesBlueLightBorderDark
                          : AppColors.noticesBlueLightBorderLight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accentBlue.withValues(alpha: isDark ? .18 : .06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: accentBlue, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: headingColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryColor,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
