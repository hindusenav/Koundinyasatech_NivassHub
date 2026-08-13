import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../provider/dashboard_provider.dart';

class MaintenanceCard extends StatelessWidget {
  const MaintenanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    final message = provider.home?.data.maintenanceMessage ?? '';

    if (message.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFD4E7FF),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline,
              color: AppColors.info,
              size: 20,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF234A84),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}