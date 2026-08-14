import 'package:flutter/material.dart';

import '../../../../notices/screens/notice_details_screen.dart';
import '../../../data/models/notice_model.dart';

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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2DD4BF).withValues(alpha: .5),
          width: 0.5,
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
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// HEADER LEFT & MORE OPTIONS (Height: 52px, Gap: 12px)
                SizedBox(
                  height: 52,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// POST ICON CONTAINER (48px x 48px, Radius: 12px, Padding: 10px)
                      Container(
                        height: 48,
                        width: 48,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4FF),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x26000000),
                              blurRadius: 4,
                              spreadRadius: 0,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.assignment_add,
                          color: Color(0xFF0F172A),
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// TITLE GROUP (Column, Height: 52px, Gap: 4px)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// POST TITLE (DM Sans 500 Medium, 20px, Line height: 120%, Color: Blue 2 #05234D)
                            SizedBox(
                              height: 24,
                              child: Text(
                                headerTitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Color(0xFF05234D),
                                  height: 1.2,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),

                            const SizedBox(height: 4),

                            /// METADATA ROW (Row, Height: 24px, Gap: 12px)
                            SizedBox(
                              height: 24,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /// POST ADMIN CONTAINER (Height: 24px, Radius: 6px, Padding: 8px h / 4px v, Color: Blue 2 #05234D)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF05234D),
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

                                  const SizedBox(width: 12),

                                  /// POST DATE (DM Sans 400 Regular, 13px, Line height: 100%, Color: #7F7F7F)
                                  Text(
                                    notice.date,
                                    style: const TextStyle(
                                      color: Color(0xFF7F7F7F),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      height: 1.0,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// POST MORE OPTIONS ICON CONTAINER (40px x 40px, Radius: 8px, Padding: 8px)
                      Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.more_vert,
                          color: Color(0xFF0F172A),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8), // 8px Gap

                /// NOTICE ACCENT STRIP (Height: 2px, Fill: 362px, Radius: 16px, Color: Yellow 1 #EC9211)
                Container(
                  height: 2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEC9211),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                const SizedBox(height: 8), // 8px Gap

                /// POST SUBTITLE (DM Sans 500 Medium, 14px, Height: 36px, Line height: 100%)
                SizedBox(
                  height: 36,
                  child: Text(
                    notice.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF0F172A),
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                /// POST DESCRIPTION BODY (DM Sans 400 Regular, 14px, Height: 66px, Line height: 160%)
                SizedBox(
                  height: 66,
                  child: Text(
                    notice.body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF334155),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.6,
                      letterSpacing: 0,
                    ),
                  ),
                ),

                const SizedBox(height: 8), // 8px Gap

                /// POST DOWNLOAD CONTAINER (Height: 28px, Radius: 4px, Padding: 4px h / 2px v, Gap: 8px, Color: Green 2 #C2F7E1)
                Material(
                  color: const Color(0xFFC2F7E1),
                  borderRadius: BorderRadius.circular(4),
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Downloading document...'),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      height: 28,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.file_download_outlined,
                            size: 18,
                            color: Color(0xFF0F172A),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            notice.downloadLabel,
                            style: const TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
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