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
            fontFamily: 'DM Sans',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.noticesHeadingDark : const Color(0xFF05234D),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Choose a post format to engage with your neighbors',
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.noticesSecondaryTextDark : const Color(0xFF6B7280),
          ),
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
        isDark ? AppColors.noticesHeadingDark : const Color(0xFF05234D);
    final secondaryColor =
        isDark ? AppColors.noticesSecondaryTextDark : const Color(0xFF6B7280);
    final accentBlue =
        isDark ? AppColors.noticesAccentBlueDark : const Color(0xFF0060BD);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.noticesCardBorderDark : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .3 : .04),
            blurRadius: 10,
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
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.noticesBlueTintBgDark
                        : const Color(0xFFF0F5FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? AppColors.noticesBlueLightBorderDark
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Center(
                    child: Icon(icon, color: accentBlue, size: 22),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: headingColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
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
