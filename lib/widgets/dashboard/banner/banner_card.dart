import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/screens/notices/advertisement_details_screen.dart';
import 'package:flutter_nivasshub/models/dashboard/banner_model.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({
    super.key,
    required this.banner,
    this.margin,
  });

  final BannerModel banner;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t = FigmaColors.of(context);
    final title = banner.title.isNotEmpty ? banner.title : 'Century Bliss';
    final isNikoo = title.toLowerCase().contains('nikoo') ||
        title.toLowerCase().contains('nikaa') ||
        title.toLowerCase().contains('luxury');

    final dateStr = isNikoo ? 'Aug 04, 2026' : 'Aug 08, 2026';
    final likesCount = isNikoo ? 42 : 34;
    final commentsCount = isNikoo ? 12 : 5;
    final imageUrl = isNikoo
        ? 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600&q=80'
        : 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=600&q=80';

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // Teal accent border reads clearly against both a light and a
          // dark card surface, so it's kept as-is in both themes.
          color: t.cardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .3 : .03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AdvertisementDetailsScreen(projectName: title),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Cover Image with rounded top corners
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: SizedBox(
                  height: 165,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: isDark ? AppColors.grey800 : const Color(0xFFF1F5F9),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFF3E2F1C),
                      child: const Icon(
                        Icons.apartment_rounded,
                        color: Colors.white70,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date & Bookmark Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: t.body,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              dateStr,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: t.body,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.bookmark_border_outlined,
                          size: 18,
                          color: t.body,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // AD Tag Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.grey800 : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'AD',
                        style: TextStyle(
                          color: t.body,
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Ad Title
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.5,
                        color: t.heading,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Description text with red Read More link
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: t.body,
                          height: 1.4,
                        ),
                        children: const [
                          TextSpan(
                            text:
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
                          ),
                          TextSpan(
                            text: 'Read More',
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Thin Horizontal Divider
                    Divider(
                      height: 1,
                      color: isDark ? AppColors.grey800 : const Color(0xFFF1F5F9),
                    ),
                    const SizedBox(height: 10),

                    // Social Action Toolbar: Likes, Comments & Share
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_border_outlined,
                          size: 16,
                          color: t.body,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$likesCount',
                          style: TextStyle(
                            fontSize: 12,
                            color: t.body,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 15,
                          color: t.body,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$commentsCount',
                          style: TextStyle(
                            fontSize: 12,
                            color: t.body,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.share_outlined,
                          size: 16,
                          color: t.body,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
