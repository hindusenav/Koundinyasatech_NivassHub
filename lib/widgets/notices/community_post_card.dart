import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/legacy_app_colors.dart';
import 'package:flutter_nivasshub/constants/legacy_app_dimensions.dart';
import 'package:flutter_nivasshub/models/notices/community_post_model.dart';
import 'package:flutter_nivasshub/providers/notices/notices_provider.dart';

class CommunityPostCard extends StatelessWidget {
  const CommunityPostCard({super.key, required this.post});

  final CommunityPostModel post;

  @override
  Widget build(BuildContext context) {
    final isPoll =
        post.type.toLowerCase() == 'poll' || post.pollOptions.isNotEmpty;
    final isEvent = post.type.toLowerCase() == 'event';

    return Container(
      decoration: BoxDecoration(
        color: isEvent
            ? const Color(0xFFEFF6FF)
            : isPoll
            ? const Color(0xFFF8FAFC)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEvent
              ? const Color(0xFFBFDBFE)
              : isPoll
              ? const Color(0xFFE2E8F0)
              : const Color(0xFFF1F5F9),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppDimensions.padding16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //----------------------------------------------------------
          // Author Header: Profile Image + Name + Flat No + Timestamp
          //----------------------------------------------------------
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFDBEAFE),
                backgroundImage: post.profileImage.isNotEmpty
                    ? NetworkImage(post.profileImage)
                    : null,
                child: post.profileImage.isEmpty
                    ? Text(
                        post.userName.isNotEmpty
                            ? post.userName[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Color(0xFF1E40AF),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            post.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF0F172A),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (post.userFlat.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              post.userFlat,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      post.timestamp.isNotEmpty
                          ? post.timestamp
                          : post.createdAt,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.more_horiz, color: Color(0xFF94A3B8)),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),

          //----------------------------------------------------------
          // Title & Content
          //----------------------------------------------------------
          if (post.title.isNotEmpty && post.title != post.userName) ...[
            Text(
              post.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
          ],
          Text(
            post.content,
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF334155),
              height: 1.45,
            ),
          ),

          //----------------------------------------------------------
          // Poll Options Render
          //----------------------------------------------------------
          if (isPoll && post.pollOptions.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...post.pollOptions.map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.radio_button_unchecked,
                        size: 18,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        option,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          //----------------------------------------------------------
          // Image Attachment
          //----------------------------------------------------------
          if ((post.imageUrl ?? "").isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: post.imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  height: 180,
                  color: const Color(0xFFF1F5F9),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (_, _, _) => Container(
                  height: 180,
                  color: const Color(0xFFF1F5F9),
                  child: const Icon(
                    Icons.broken_image,
                    size: 36,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 8),

          //----------------------------------------------------------
          // Actions Footer: Like, Comment, Share & Action Button
          //----------------------------------------------------------
          Row(
            children: [
              InkWell(
                onTap: () {
                  context.read<NoticesProvider?>()?.toggleLike(post.id);
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        post.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: post.isLiked
                            ? Colors.red
                            : const Color(0xFF64748B),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.likes}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: post.isLiked
                              ? Colors.red
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Color(0xFF64748B),
                        size: 19,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.comments}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      post.action.toLowerCase().contains('issue') ||
                          post.action.toLowerCase().contains('rsvp')
                      ? const Color(0xFFF97316)
                      : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  post.action.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
