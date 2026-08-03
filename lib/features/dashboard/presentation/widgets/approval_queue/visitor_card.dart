import 'package:flutter/material.dart';

import '../../../data/models/visitor_model.dart';
import 'action_button.dart';
import 'visitor_type_icon.dart';

class VisitorCard extends StatelessWidget {
  const VisitorCard({
    super.key,
    required this.visitor,
    required this.onApprove,
    required this.onReject,
    required this.onCallGuard,
  });

  final VisitorModel visitor;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onCallGuard;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFEAF3FF),
                  child: Icon(
                    VisitorTypeIcon.icon(
                      visitor.visitorType,
                    ),
                    color: const Color(0xFF1565C0),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        visitor.visitorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${visitor.visitorType} • ${visitor.time}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Flat : ${visitor.flat}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                VisitorActionButton(
                  label: 'Reject',
                  icon: Icons.close,
                  color: Colors.red,
                  onTap: onReject,
                ),
                const SizedBox(width: 10),
                VisitorActionButton(
                  label: 'Approve',
                  icon: Icons.check,
                  color: Colors.green,
                  onTap: onApprove,
                ),
                const SizedBox(width: 10),
                VisitorActionButton(
                  label: 'Guard',
                  icon: Icons.call_outlined,
                  color: Colors.blue,
                  onTap: onCallGuard,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}