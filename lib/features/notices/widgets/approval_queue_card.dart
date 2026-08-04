import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class ApprovalQueueCard extends StatelessWidget {
  const ApprovalQueueCard({
    super.key,
    required this.name,
    required this.flatNumber,
    required this.purpose,
    required this.time,
    this.profileImage = '',
    this.onApprove,
    this.onReject,
  });

  final String name;
  final String flatNumber;
  final String purpose;
  final String time;
  final String profileImage;

  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.padding16,
        vertical: 8,
      ),
      elevation: 2,
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.padding16),
        child: Column(
          children: [
            //-----------------------------------------
            // Visitor Details
            //-----------------------------------------
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.shimmerBase,
                  backgroundImage: profileImage.isNotEmpty
                      ? NetworkImage(profileImage)
                      : null,
                  child: profileImage.isEmpty ? const Icon(Icons.person) : null,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Flat : $flatNumber",
                        style: theme.textTheme.bodySmall,
                      ),

                      const SizedBox(height: 4),

                      Text(purpose, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),

                Column(
                  children: [
                    const Icon(Icons.access_time, size: 18),

                    const SizedBox(height: 4),

                    Text(time, style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),

            //-----------------------------------------
            // Buttons
            //-----------------------------------------
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                    icon: const Icon(Icons.close),
                    label: const Text("Reject"),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text("Approve"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
