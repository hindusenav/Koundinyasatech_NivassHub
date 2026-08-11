import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../app/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../provider/dashboard_provider.dart';
import '../empty/section_empty.dart';

class ApprovalQueueSection extends StatelessWidget {
  const ApprovalQueueSection({
    super.key,
  });

  static const _avatarColors = [
    Color(0xffFFA726),
    Color(0xff42A5F5),
    Color(0xff26A69A),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xffECECEC),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Approval Queue (${visitors.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                // Only navigation wired here — the Activities screen itself
                // lives entirely under `lib/features/visitor/` and doesn't
                // touch this widget's existing layout/data/business logic.
                onPressed: () => Navigator.pushNamed(context, AppRoutes.activities),
                child: const Text(
                  'View all',
                  style: TextStyle(
                    color: Color(0xff1565C0),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < visitors.length && i < 3; i++)
                _VisitorAvatar(
                  name: visitors[i].visitorName,
                  subtitle: 'Flat ${visitors[i].flat}',
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
          radius: 30,
          backgroundColor: color,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: 90,
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 2),

        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}