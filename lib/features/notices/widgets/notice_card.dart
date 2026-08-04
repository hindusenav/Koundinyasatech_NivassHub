import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

import '../models/notice_model.dart';

class NoticeCard extends StatelessWidget {
  const NoticeCard({super.key, required this.notice});

  final NoticeModel notice;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.padding16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //----------------------------------------------------------
            // Header
            //----------------------------------------------------------
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.campaign,
                    color: Colors.orange,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    notice.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),

                _PriorityBadge(priority: notice.priority),
              ],
            ),

            const SizedBox(height: 16),

            //----------------------------------------------------------
            // Description
            //----------------------------------------------------------
            Text(
              notice.description,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 16),

            //----------------------------------------------------------
            // Footer
            //----------------------------------------------------------
            Row(
              children: [
                const Icon(Icons.schedule, size: 18, color: Colors.grey),

                const SizedBox(width: 6),

                Text(
                  notice.date,
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const Spacer(),

                if (notice.hasAttachment)
                  Row(
                    children: const [
                      Icon(
                        Icons.attach_file,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Attachment",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
              ],
            ),

            const Divider(height: 24),

            //----------------------------------------------------------
            // Bottom Actions
            //----------------------------------------------------------
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () {},

                icon: const Icon(Icons.visibility),

                label: const Text("Read More"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.priority});

  final String priority;

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (priority.toLowerCase()) {
      case "high":
        color = Colors.red;
        break;

      case "medium":
        color = Colors.orange;
        break;

      default:
        color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
