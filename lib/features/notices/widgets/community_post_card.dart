import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

import '../models/community_post_model.dart';

class CommunityPostCard extends StatelessWidget {
  const CommunityPostCard({super.key, required this.post});

  final CommunityPostModel post;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.padding16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //--------------------------------------------------------
            // Header
            //--------------------------------------------------------
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    post.userName.isNotEmpty
                        ? post.userName[0].toUpperCase()
                        : "?",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        post.timeAgo ?? "Just now",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
              ],
            ),

            const SizedBox(height: 14),

            //--------------------------------------------------------
            // Content
            //--------------------------------------------------------
            Text(
              post.content,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),

            const SizedBox(height: 14),

            //--------------------------------------------------------
            // Image
            //--------------------------------------------------------
            if ((post.imageUrl ?? "").isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  imageUrl: post.imageUrl!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,

                  placeholder: (_, __) => Container(
                    height: 220,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),

                  errorWidget: (_, __, ___) => Container(
                    height: 220,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, size: 40),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            //--------------------------------------------------------
            // Likes
            //--------------------------------------------------------
            Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red, size: 18),

                const SizedBox(width: 6),

                Text("${post.likes} Likes"),

                const Spacer(),

                Text("${post.comments} Comments"),
              ],
            ),

            const Divider(height: 24),

            //--------------------------------------------------------
            // Bottom Actions
            //--------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionButton(icon: Icons.thumb_up_alt_outlined, title: "Like"),

                _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  title: "Comment",
                ),

                _ActionButton(icon: Icons.share_outlined, title: "Share"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},

      icon: Icon(icon, size: 20, color: Colors.grey.shade700),

      label: Text(title, style: TextStyle(color: Colors.grey.shade700)),
    );
  }
}
