import 'package:flutter/material.dart';

import '../../../data/models/community_meeting_model.dart';

class CommunityMeetingCard extends StatelessWidget {
  const CommunityMeetingCard({
    super.key,
    required this.meeting,
  });

  final CommunityMeetingModel meeting;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.campaign_outlined,
                size: 20,
                color: Color(0xFF1E3A8A),
              ),
              const SizedBox(width: 8),
              Text(
                meeting.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            meeting.message,
            style: const TextStyle(
              fontSize: 12.5,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Material(
            color: const Color(0xFFE57C00),
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Action recorded.')),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  meeting.ctaLabel.isNotEmpty ? meeting.ctaLabel : 'ISSUE NOW',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
