import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerIndicator extends StatelessWidget {
  const BannerIndicator({
    super.key,
    required this.currentIndex,
    required this.count,
  });

  final int currentIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return AnimatedSmoothIndicator(
      activeIndex: currentIndex,
      count: count,
      effect: const WormEffect(
        dotHeight: 8,
        dotWidth: 8,
        spacing: 8,
        activeDotColor: AppColors.primaryOrange,
        dotColor: Colors.grey,
      ),
    );
  }
}