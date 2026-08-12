import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_provider.dart';
import 'banner_card.dart';
import 'banner_indicator.dart';

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

    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          itemBuilder: (context, index, realIndex) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: BannerCard(
                banner: banners[index],
              ),
            );
          },
          options: CarouselOptions(
            height: 112,

            // Figma uses almost full available width.
            viewportFraction: 1.0,

            enlargeCenterPage: false,

            enableInfiniteScroll: banners.length > 1,

            autoPlay: banners.length > 1,

            autoPlayInterval: const Duration(seconds: 4),

            autoPlayAnimationDuration:
                const Duration(milliseconds: 450),

            autoPlayCurve: Curves.easeInOut,

            onPageChanged: (index, reason) {
              if (!mounted) return;

              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),

        const SizedBox(height: 7),

        BannerIndicator(
          currentIndex: currentIndex,
          count: banners.length,
        ),
      ],
    );
  }
}