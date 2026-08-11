import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_provider.dart';
import '../empty/section_empty.dart';

class ApprovalQueueSection extends StatelessWidget {
  const ApprovalQueueSection({super.key});

  static const _avatarColors = [
    Color(0xFFEAB308), // Yellow B
    Color(0xFF7E22CE), // Purple Z
    Color(0xFFEC4899), // Pink/Photo Help
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final visitors = provider.visitors;

    if (visitors.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SectionEmpty(
          icon: Icons.people_outline,
          title: 'No Pending Visitors',
          message: 'There are no visitor approvals waiting right now.',
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Approval Queue (${visitors.length})',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: const Text(
                  'View all',
                  style: TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < visitors.length && i < 3; i++)
                _VisitorAvatar(
                  name: visitors[i].visitorName,
                  subtitle: visitors[i].flat.isNotEmpty ? visitors[i].flat : 'User Name',
                  color: _avatarColors[i % _avatarColors.length],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VisitorAvatar extends StatelessWidget {
  const _VisitorAvatar({
    required this.name,
    required this.subtitle,
    required this.color,
  });

  final String name;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: color,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 90,
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(
          width: 90,
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
