import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../app/app_routes.dart';
import '../../provider/dashboard_provider.dart';
import '../empty/section_empty.dart';

class ApprovalQueueSection extends StatelessWidget {
  const ApprovalQueueSection({
    super.key,
  });

  static const _avatarColors = [
    Color(0xFFF59E0B),
    Color(0xFF8B5CF6),
    Color(0xFF10B981),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    final visitors = provider.visitors;

    if (visitors.isEmpty) {
      return const SectionEmpty(
        icon: Icons.people_outline,
        title: 'No Pending Visitors',
        message: 'There are no visitor approvals waiting right now.',
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF05234D),
            Color(0xFF13A391),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.5), // 0.5px gradient border
        child: Container(
          padding: const EdgeInsets.all(16), // 16px padding
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER FRAME (Height: 23px, Justify: space-between)
              SizedBox(
                height: 23,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Approval Queue (${visitors.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        height: 1.1,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.activities),
                      borderRadius: BorderRadius.circular(4),
                      child: const Text(
                        'View all',
                        style: TextStyle(
                          color: Color(0xFF0284C7),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8), // 8px gap

              /// APPROVAL QUEUE LIST (Height: 118px, Vertical Padding: 8px, Item Gap: 16px)
              Container(
                height: 118,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < visitors.length && i < 3; i++) ...[
                      if (i > 0) const SizedBox(width: 16),
                      _VisitorAvatar(
                        name: visitors[i].visitorName,
                        subtitle: visitors[i].visitorType.isNotEmpty
                            ? visitors[i].visitorType
                            : 'Delivery',
                        color: _avatarColors[i % _avatarColors.length],
                        isImage: i == 2,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VisitorAvatar extends StatelessWidget {
  const _VisitorAvatar({
    required this.name,
    required this.subtitle,
    required this.color,
    this.isImage = false,
  });

  final String name;
  final String subtitle;
  final Color color;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isImage)
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=100&q=80'),
                fit: BoxFit.cover,
              ),
            ),
          )
        else
          CircleAvatar(
            radius: 24,
            backgroundColor: color,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

        const SizedBox(height: 8),

        SizedBox(
          width: 85,
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ),

        const SizedBox(height: 2),

        SizedBox(
          width: 85,
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
            ),
          ),
        ),
      ],
    );
  }
}