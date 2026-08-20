import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/widgets/dashboard/banner/banner_indicator.dart';
import 'package:flutter_nivasshub/widgets/dashboard/banner/online_advertising_banner.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final banners = provider.advertisementBanners;

    final bannerTitles = banners.isNotEmpty
        ? banners.map((b) => b.title.isNotEmpty ? b.title : 'Online\nAdvertising').toList()
        : const ['Online\nAdvertising', 'Promote\nYour Business', 'Reach Your\nCommunity'];

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: bannerTitles.length,
          itemBuilder: (context, index, realIndex) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: OnlineAdvertisingBannerCard(
                title: bannerTitles[index].contains('\n')
                    ? bannerTitles[index]
                    : 'Online\nAdvertising',
              ),
            );
          },
          options: CarouselOptions(
            height: 100,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            enableInfiniteScroll: bannerTitles.length > 1,
            autoPlay: bannerTitles.length > 1,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 450),
            autoPlayCurve: Curves.easeInOut,
            onPageChanged: (index, reason) {
              if (!mounted) return;
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        BannerIndicator(
          currentIndex: currentIndex,
          count: bannerTitles.length,
        ),
      ],
    );
  }
}