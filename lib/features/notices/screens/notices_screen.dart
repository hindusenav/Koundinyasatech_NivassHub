import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/network/api_client.dart';
import '../../dashboard/presentation/widgets/navigation/dashboard_bottom_navigation.dart';
import '../models/advertisement_model.dart';
import '../provider/notices_provider.dart';
import '../widgets/advertisement_banner.dart';
import '../widgets/create_post_header_card.dart';

/// Screen matching exact Figma design for "Community Posts" screen:
/// - Top Bar with title "Community Posts" & notification bell icon
/// - "Create a community post" card options (Create Post, Create Poll, Host an Event)
/// - Hero Advertisement Banner (ALTURA)
/// - Dashboard Bottom Navigation Bar
class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key, required this.apiClient});

  final ApiClient apiClient;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoticesProvider(apiClient: apiClient)..loadFeed(),
      child: const _NoticesView(),
    );
  }
}

class _NoticesView extends StatelessWidget {
  const _NoticesView();

  @override
  Widget build(BuildContext context) {
    return Consumer<NoticesProvider>(
      builder: (context, provider, child) {
        final AdvertisementModel fallbackAd = const AdvertisementModel(
          bannerId: 'ad_altura',
          title: 'ALTURA',
          subtitle: '2 & 3 BHK Homes',
          price: '₹1.30 Crore Onwards',
          image: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00',
          redirectUrl: 'https://altura.com',
        );

        final AdvertisementModel displayAd = provider.banners.isNotEmpty
            ? provider.banners.first
            : fallbackAd;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: const Color(0xFFE0F2FE),
            elevation: 0,
            titleSpacing: 0,
            leading: Navigator.of(context).canPop()
                ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : const SizedBox(width: 16),
            title: const Text(
              'Community Posts',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_outlined,
                  color: Colors.black87,
                ),
                onPressed: () {},
              ),
            ],
          ),
          bottomNavigationBar: const DashboardBottomNavigation(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CreateCommunityPostHeaderCard(),
                  const SizedBox(height: 24),
                  AdvertisementBanner(advertisement: displayAd),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
