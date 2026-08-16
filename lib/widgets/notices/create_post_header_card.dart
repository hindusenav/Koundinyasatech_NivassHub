import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/screens/notices/create_event_screen.dart';
import 'package:flutter_nivasshub/screens/notices/create_poll_screen.dart';
import 'package:flutter_nivasshub/screens/notices/create_post_screen.dart';

/// Section component matching Figma Screen ("Community Posts").
class CreateCommunityPostHeaderCard extends StatelessWidget {
  const CreateCommunityPostHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create a community post',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Choose a post format to engage with your neighbors',
          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: .04),
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
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFDBEAFE)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0284C7).withValues(alpha: .06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: const Color(0xFF0284C7), size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
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
