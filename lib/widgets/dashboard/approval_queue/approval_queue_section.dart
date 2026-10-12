import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/widgets/dashboard/empty/section_empty.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? FigmaTheme.dark.card : FigmaColors.navy,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? FigmaTheme.dark.cardBorder : FigmaColors.navy,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .3 : .03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Approval Queue (${visitors.length})',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, AppRoutes.activities),
                borderRadius: BorderRadius.circular(4),
                child: Text(
                  'View all',
                  style: TextStyle(
                    color: FigmaColors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < visitors.length && i < 3; i++)
                _VisitorAvatar(
                  name: visitors[i].visitorName,
                  subtitle: visitors[i].visitorType.isNotEmpty
                      ? visitors[i].visitorType
                      : 'Delivery',
                  color: _avatarColors[i % _avatarColors.length],
                  isImage: i == 2,
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
    this.isImage = false,
  });

  final String name;
  final String subtitle;
  final Color color;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return Column(
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
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
            style: TextStyle(
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}