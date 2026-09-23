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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create a community post',
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.0,
            letterSpacing: 0,
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
            height: 1.0,
            letterSpacing: 0,
            color: isDark ? AppColors.noticesSecondaryTextDark : const Color(0xFF3E3E3E),
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
        const SizedBox(height: 10),
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
        const SizedBox(height: 10),
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
        isDark ? AppColors.noticesSecondaryTextDark : const Color(0xFF3E3E3E);
    final accentBlue =
        isDark ? AppColors.noticesAccentBlueDark : const Color(0xFF0060BD);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.noticesCardBorderDark : const Color(0xFFE8F4FF),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .3 : .15),
            blurRadius: 4,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.noticesBlueTintBgDark
                        : const Color(0xFFE8F4FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark
                          ? AppColors.noticesBlueLightBorderDark
                          : const Color(0xFFE8F4FF),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? .3 : .15),
                        blurRadius: 4,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(icon, color: accentBlue, size: 20),
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
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                          letterSpacing: 0,
                          color: headingColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                          letterSpacing: 0,
                          color: secondaryColor,
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
