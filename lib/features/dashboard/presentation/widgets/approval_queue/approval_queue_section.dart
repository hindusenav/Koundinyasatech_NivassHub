import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_provider.dart';
import 'visitor_card.dart';

class ApprovalQueueSection extends StatelessWidget {
  const ApprovalQueueSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    final visitors = provider.visitors;

    if (visitors.isEmpty) {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: SectionEmpty(
      icon: Icons.people_outline,
      title: 'No Pending Visitors',
      message:
          'There are no visitor approvals waiting right now.',
    ),
  );
}

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Pending Approvals (${visitors.length})',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          ...visitors.map(
            (visitor) => VisitorCard(
              visitor: visitor,
              onApprove: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      '${visitor.visitorName} approved',
                    ),
                  ),
                );
              },
              onReject: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      '${visitor.visitorName} rejected',
                    ),
                  ),
                );
              },
              onCallGuard: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Calling Security Desk...',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}