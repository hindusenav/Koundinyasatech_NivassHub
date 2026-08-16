import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/screens/notices/notice_details_screen.dart';
import 'package:flutter_nivasshub/models/dashboard/notice_model.dart';

class NoticeCard extends StatelessWidget {
  const NoticeCard({
    super.key,
    required this.notice,
    this.onTap,
  });

  final NoticeModel notice;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    String headerTitle = 'Notice';
    if (notice.noticeId == 'not_1') {
      headerTitle = 'Notice 1';
    } else if (notice.noticeId == 'not_2') {
      headerTitle = 'Notice 2';
    } else if (notice.noticeId == 'not_3') {
      headerTitle = 'Notice 3';
    } else if (notice.title.contains('Notice')) {
      headerTitle = notice.title.split(' ').take(2).join(' ');
    }

    void handleTap() {
      if (onTap != null) {
        onTap!();
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => NoticeDetailsScreen(notice: notice),
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2DD4BF).withValues(alpha: .5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: handleTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .06),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.assignment_add,
                        color: Color(0xFF0F172A),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            headerTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F172A),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  notice.postedBy,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                notice.date,
                                style: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.more_vert,
                      color: Color(0xFF0F172A),
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Thin orange divider bar
                Container(
                  height: 2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE57C00),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  notice.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  notice.body,
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 12.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),

                // Download Button Badge
                Material(
                  color: const Color(0xFFC7F9CC),
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Downloading document...'),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: const [
                              Icon(
                                Icons.article_outlined,
                                size: 20,
                                color: Color(0xFF0F172A),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Icon(
                                  Icons.arrow_downward,
                                  size: 10,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            notice.downloadLabel,
                            style: const TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}