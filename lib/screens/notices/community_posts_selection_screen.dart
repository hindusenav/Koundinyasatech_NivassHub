import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/services/core/api_client.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';
import 'package:flutter_nivasshub/providers/notices/notices_provider.dart';
import 'package:flutter_nivasshub/widgets/notices/create_post_header_card.dart';

class CommunityPostsSelectionScreen extends StatelessWidget {
  const CommunityPostsSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Screen-scoped, same as NoticesScreen — CreatePostScreen/CreatePollScreen/
    // CreateEventScreen (pushed from this screen) look up NoticesProvider via
    // Provider.of, so it must be available somewhere above them in the tree.
    return ChangeNotifierProvider<NoticesProvider>(
      create: (context) => NoticesProvider(apiClient: context.read<ApiClient>()),
      child: const _CommunityPostsSelectionView(),
    );
  }
}

class _CommunityPostsSelectionView extends StatelessWidget {
  const _CommunityPostsSelectionView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headingColor =
        isDark ? AppColors.noticesHeadingDark : AppColors.noticesHeadingLight;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.noticesBackgroundDark : AppColors.noticesBackgroundLight,
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.noticesAppBarDark : AppColors.noticesAppBarLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: headingColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Community Posts',
          style: TextStyle(
            color: headingColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_outlined, color: headingColor, size: 22),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      bottomNavigationBar: const DashboardBottomNavigation(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CreateCommunityPostHeaderCard(),
            const SizedBox(height: 24),

            // Hero Ad Banner Card (ALTURA)
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? AppColors.noticesCardBorderDark
                      : AppColors.noticesCardBorderLight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? .3 : .04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                // The photo, its legibility scrim, and the text/badges
                // painted directly on top of it are intentionally
                // theme-independent (a photo does not change with app theme).
                child: Stack(
                  children: [
                    SizedBox(
                      height: 220,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600&q=80',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: isDark
                              ? AppColors.noticesCardBorderDark
                              : AppColors.noticesCardBorderLight,
                        ),
                        errorWidget: (context, url, err) => Container(
                          color: const Color(0xFF0F172A),
                          child: const Icon(Icons.apartment,
                              size: 50, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: .7),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9).withValues(alpha: .9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Ad',
                          style: TextStyle(
                              color: Color(0xFF334155),
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 16,
                      bottom: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ALTURA',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '2 & 3 BHK Homes',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '₹1.30 Crore Onwards',
                            style: TextStyle(
                              color: Color(0xFFFDE68A),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
