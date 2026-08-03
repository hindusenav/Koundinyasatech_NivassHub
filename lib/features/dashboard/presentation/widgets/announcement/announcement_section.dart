import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_provider.dart';
import 'announcement_card.dart';
import 'announcement_empty.dart';

class AnnouncementSection extends StatelessWidget {
  const AnnouncementSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    final announcement = provider.announcement;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Announcements',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          if (announcement == null)
            const AnnouncementEmpty()
          else
            AnnouncementCard(
              announcement: announcement,
              onTap: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Announcement details coming soon.',
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}