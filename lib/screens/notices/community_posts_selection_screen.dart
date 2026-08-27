import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final headerColor = isDark ? AppColors.dashboardHeaderDark : const Color(0xFFC7E3FF);
    final titleColor = isDark ? AppColors.noticesTitleTextDark : const Color(0xFF05234D);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.noticesBackgroundDark : const Color(0xFFF8FAFC),
      bottomNavigationBar: const DashboardBottomNavigation(selectedIndex: 2),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Edge-to-Edge Light Blue Header Container (#C7E3FF fill matching Figma)
              Container(
                width: double.infinity,
                color: headerColor,
                padding: EdgeInsets.only(
                  top: statusBarHeight > 0 ? statusBarHeight + 12 : 12,
                  left: 20,
                  right: 20,
                  bottom: 16,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: titleColor,
                        size: 24,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 38,
                        padding: const EdgeInsets.only(left: 16, right: 12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.surfaceDark
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: isDark
                                ? AppColors.borderDark
                                : const Color(0xFFCCDFF2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Community Posts',
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                height: 1.0,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : const Color(0xFF000000),
                              ),
                            ),
                            Icon(
                              Icons.notifications_none_outlined,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : const Color(0xFF000000),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CreateCommunityPostHeaderCard(),
                  const SizedBox(height: 24),

                  // Hero Ad Banner Card (ALTURA)
                  Container(
                    height: 260,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? AppColors.noticesCardBorderDark
                            : const Color(0xFFE5E7EB),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? .3 : .06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800&q=80',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: isDark
                                    ? AppColors.noticesCardBorderDark
                                    : const Color(0xFFE2E8F0),
                              ),
                              errorWidget: (context, url, err) => Container(
                                color: const Color(0xFF0F172A),
                                child: const Icon(Icons.apartment,
                                    size: 50, color: Colors.white),
                              ),
                            ),
                          ),
                          // Gradient Scrim
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: .75),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                          // Top Right "Ad" Badge
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: .5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Ad',
                                style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          // Bottom Text Overlay
                          Positioned(
                            left: 16,
                            bottom: 16,
                            right: 16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'ALTURA',
                                      style: TextStyle(
                                        fontFamily: 'DM Sans',
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      '2 & 3 BHK Homes',
                                      style: TextStyle(
                                        fontFamily: 'DM Sans',
                                        color: Color(0xE6FFFFFF),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const Text(
                                  '₹1.30 Crore Onwards',
                                  style: TextStyle(
                                    fontFamily: 'DM Sans',
                                    color: Color(0xFFEC9211),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
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
          ),
        ],
      ),
    ),
  ),
);
  }
}
