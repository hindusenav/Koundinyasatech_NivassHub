import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/legacy_app_dimensions.dart';
import 'package:flutter_nivasshub/models/notices/community_post_model.dart';
import 'package:flutter_nivasshub/providers/notices/notices_provider.dart';

class CommunityPostCard extends StatelessWidget {
  const CommunityPostCard({super.key, required this.post});

  final CommunityPostModel post;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPoll =
        post.type.toLowerCase() == 'poll' || post.pollOptions.isNotEmpty;
    final isEvent = post.type.toLowerCase() == 'event';

    final headingColor =
        isDark ? AppColors.noticesHeadingDark : AppColors.noticesHeadingLight;
    final mutedColor = isDark ? AppColors.noticesMutedDark : AppColors.noticesMutedLight;
    final secondaryColor =
        isDark ? AppColors.noticesSecondaryTextDark : AppColors.noticesSecondaryTextLight;
    final bodyColor = isDark ? AppColors.noticesBodyTextDark : AppColors.noticesBodyTextLight;
    final dividerColor = isDark ? AppColors.noticesDividerDark : AppColors.noticesDividerLight;

    return Container(
      decoration: BoxDecoration(
        color: isEvent
            ? (isDark ? AppColors.noticesBlueTintBgDark : AppColors.noticesBlueTintBgLight)
            : isPoll
            ? (isDark ? AppColors.noticesBackgroundDark : AppColors.noticesBackgroundLight)
            : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEvent
              ? (isDark ? AppColors.noticesBlueBorderDark : AppColors.noticesBlueBorderLight)
              : isPoll
              ? (isDark ? AppColors.noticesCardBorderDark : AppColors.noticesCardBorderLight)
              : dividerColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
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
                backgroundColor: isDark
                    ? AppColors.noticesBlueLightBorderDark
                    : AppColors.noticesBlueLightBorderLight,
                backgroundImage: post.profileImage.isNotEmpty
                    ? NetworkImage(post.profileImage)
                    : null,
                child: post.profileImage.isEmpty
                    ? Text(
                        post.userName.isNotEmpty
                            ? post.userName[0].toUpperCase()
                            : 'U',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.communityAvatarTextDark
                              : AppColors.communityAvatarTextLight,
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: headingColor,
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
                              color: dividerColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              post.userFlat,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.noticesLabelTextDark
                                    : AppColors.noticesLabelTextLight,
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
                      style: TextStyle(
                        color: mutedColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(Icons.more_horiz, color: mutedColor),
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: headingColor,
              ),
            ),
            const SizedBox(height: 6),
          ],
          Text(
            post.content,
            style: TextStyle(
              fontSize: 13.5,
              color: bodyColor,
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
                    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? AppColors.noticesBorderDark : AppColors.noticesBorderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.radio_button_unchecked,
                        size: 18,
                        color: secondaryColor,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        option,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.noticesTitleTextDark
                              : AppColors.noticesTitleTextLight,
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
                  color: dividerColor,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (_, _, _) => Container(
                  height: 180,
                  color: dividerColor,
                  child: Icon(
                    Icons.broken_image,
                    size: 36,
                    color: mutedColor,
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),
          Divider(height: 1, color: dividerColor),
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
                        color: post.isLiked ? Colors.red : secondaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.likes}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: post.isLiked ? Colors.red : secondaryColor,
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
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: secondaryColor,
                        size: 19,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.comments}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: secondaryColor,
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
                      ? AppColors.communityReactionOrange
                      : (isDark
                          ? AppColors.communityAccentBlueDark
                          : AppColors.communityAccentBlueLight),
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
