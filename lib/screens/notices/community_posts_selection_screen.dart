import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/services/core/api_client.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';
import 'package:flutter_nivasshub/providers/notices/notices_provider.dart';
import 'package:flutter_nivasshub/widgets/notices/community_header_container.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CommunityHeaderContainer(
        title: 'Community Posts',
      ),
      bottomNavigationBar: const DashboardBottomNavigation(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CreateCommunityPostHeaderCard(),
            const SizedBox(height: 24),

            // luxury-banner-card (Height: 303px, Radius: 12px, Padding: 16px, Drop Shadow: Offset(0, 2), Blur: 12, Color: #000000 3.92%)
            Container(
              height: 303,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000), // Drop shadow: #000000 3.92%
                    offset: Offset(0, 2),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    // Banner Image
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600&q=80',
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: const Color(0xFFE2E8F0)),
                        errorWidget: (context, url, err) => Container(
                          color: const Color(0xFF0F172A),
                          child: const Icon(Icons.apartment,
                              size: 50, color: Colors.white),
                        ),
                      ),
                    ),

                    // Colors Overlay (#000000 55%)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: .2),
                              Colors.black.withValues(alpha: .55),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                    // Layout: Vertical, Justify space-between, Padding: 16px
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // banner-top (Flow: Horizontal, Width Fill 364px, Height Hug 16px)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // ad-badge (Radius: 4px, Padding: Top/Bottom 2px, Left/Right 6px, Color: #FFFFFF 20%)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: .20),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Ad',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // banner-details (Gap: 4px)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // brand (Inter 800 ExtraBold, 18px, Line height 100%, Letter spacing 1px, Color: #FFFFFF)
                              const Text(
                                'ALTURA',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  height: 1.0,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4), // Gap: 4px

                              // sub-info-row (Flow: Horizontal, Width Fill 364px, Height Hug 16px, Justify: space-between)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  // sub (Inter 500 Medium, 12px, Line height 100%, Color: #E5E7EB)
                                  Text(
                                    '2 & 3 BHK Homes',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Color(0xFFE5E7EB),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 1.0,
                                      letterSpacing: 0,
                                    ),
                                  ),

                                  // price (Inter 700 Bold, 13px, Line height 100%, Color: #FBBF24)
                                  Text(
                                    '₹1.30 Crore Onwards',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Color(0xFFFBBF24),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      height: 1.0,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ],
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
