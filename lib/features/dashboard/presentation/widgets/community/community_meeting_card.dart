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
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFBAE6FD),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.campaign_outlined,
                color: Color(0xFF0284C7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  meeting.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            meeting.message,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 32,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("RSVP recorded successfully!"),
                    backgroundColor: Color(0xFF059669),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFFE57C00),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                meeting.ctaLabel.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}