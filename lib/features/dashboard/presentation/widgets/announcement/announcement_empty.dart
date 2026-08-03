import 'package:flutter/material.dart';

class AnnouncementEmpty extends StatelessWidget {
  const AnnouncementEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.campaign_outlined,
            size: 40,
            color: Colors.grey,
          ),
          SizedBox(height: 12),
          Text(
            'No announcements available',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}