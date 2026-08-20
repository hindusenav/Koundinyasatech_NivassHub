import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/screens/notices/create_event_screen.dart';
import 'package:flutter_nivasshub/screens/notices/create_poll_screen.dart';
import 'package:flutter_nivasshub/screens/notices/create_post_screen.dart';

/// Section component matching Figma Screen ("Community Posts" -> Frame 2106259979).
class CreateCommunityPostHeaderCard extends StatelessWidget {
  const CreateCommunityPostHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // sheet-header
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Create a community post',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05234D),
                height: 1.0,
                letterSpacing: 0,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Choose a post format to engage with your neighbors',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3E3E3E),
                height: 1.0,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16), // Frame 2106259979 gap: 16px

        // actions-list (Gap: 10px)
        Column(
          children: [
            _OptionCard(
              icon: Icons.edit_outlined,
              title: 'Create Post',
              subtitle: 'Share news, updates, or helpful recommendations',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreatePostScreen()),
                );
              },
            ),
            const SizedBox(height: 10), // actions-list Gap: 10px
            _OptionCard(
              icon: Icons.bar_chart_rounded,
              title: 'Create Poll',
              subtitle: 'Get quick feedback or vote on community matters',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreatePollScreen()),
                );
              },
            ),
            const SizedBox(height: 10), // actions-list Gap: 10px
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
        ),
      ],
    );
  }
}

/// action-card:
/// Flow Horizontal, Width Fill (400px), Height Fixed (82px), Radius 12px, Border 1px (#E2E8F0),
/// Padding 14px, Gap 14px, Background #F8FAFC, Shadow (X:4, Y:4, Blur:4, Color #000000 15%).
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
    return Container(
      height: 82, // Height: Fixed (82px)
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC), // Colors: #F8FAFC
        borderRadius: BorderRadius.circular(12), // Radius: 12px
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1), // Border: 1px #E2E8F0
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000), // Shadow: #000000 15% opacity
            offset: Offset(4, 4), // X: 4, Y: 4
            blurRadius: 4, // Blur: 4
            spreadRadius: 0, // Spread: 0
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(14), // Padding: 14px
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // icon-frame (Width: 40px, Height: 40px, Radius: 10px, Padding: 10px, Color: #E8F4FF, Border: #E8F4FF)
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F4FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE8F4FF), width: 1),
                  ),
                  child: Icon(icon, color: const Color(0xFF0284C7), size: 20),
                ),
                const SizedBox(width: 14), // Gap: 14px

                // action-text (Flow: Vertical, Width Fill 318px, Height Hug 38px, Gap 2px)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Action Title (DM Sans 15px SemiBold 600, Color #05234D)
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF05234D),
                          height: 1.0,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 2), // Gap: 2px
                      // Action Description
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF3E3E3E),
                          height: 1.0,
                          letterSpacing: 0,
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
