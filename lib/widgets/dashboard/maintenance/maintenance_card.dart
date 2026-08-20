import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';

class MaintenanceCard extends StatelessWidget {
  const MaintenanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    final message = provider.home?.data.maintenanceMessage ??
        'Visitor maintenance scheduled at 11 AM.';

    if (message.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFBAE6FD),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFF0284C7),
            size: 18,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0284C7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}