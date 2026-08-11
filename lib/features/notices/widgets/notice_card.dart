import 'package:flutter/material.dart';

import '../../../core/constants/app_dimensions.dart';
import '../models/notice_model.dart';

/// Pixel-perfect Notice Card component matching updated API contract & Figma spec:
/// Header: Notice Icon + Category/Author Badge + Timestamp + More menu
/// Body: Title + Description
/// Action: Outlined Action button (Download / View Details / Issue Now)
class NoticeCard extends StatelessWidget {
  const NoticeCard({super.key, required this.notice});

  final NoticeModel notice;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppDimensions.padding16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //----------------------------------------------------------
          // Header: Icon + Category/Author + Timestamp + Actions
          //----------------------------------------------------------
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  color: Color(0xFF0284C7),
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Notice',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  notice.author.isNotEmpty ? notice.author : notice.category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                notice.timestamp.isNotEmpty ? notice.timestamp : notice.date,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey.shade500,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          //----------------------------------------------------------
          // Title & Description
          //----------------------------------------------------------
          Text(
            notice.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            notice.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),

          //----------------------------------------------------------
          // Action: Outlined Action Button (e.g. Download / View Details)
          //----------------------------------------------------------
          OutlinedButton.icon(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF16A34A),
              side: const BorderSide(color: Color(0xFF16A34A)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            icon: Icon(
              notice.action.toLowerCase().contains('download')
                  ? Icons.download_rounded
                  : Icons.arrow_forward_rounded,
              size: 16,
            ),
            label: Text(
              notice.action,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
