import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/banner_model.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({
    super.key,
    required this.banner,
  });

  final BannerModel banner;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 150,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1EA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -16,
            bottom: -18,
            child: Icon(
              Icons.campaign_rounded,
              size: 110,
              color: AppColors.tertiary.withValues(alpha: .85),
            ),
          ),
          Positioned(
            left: 58,
            top: 22,
            child: Transform.rotate(
              angle: -0.35,
              child: Icon(
                Icons.mail_rounded,
                size: 28,
                color: AppColors.error.withValues(alpha: .85),
              ),
            ),
          ),
          Positioned(
            left: 92,
            top: 54,
            child: Icon(
              Icons.thumb_up_alt_rounded,
              size: 24,
              color: AppColors.primary,
            ),
          ),
          Positioned(
            left: 108,
            top: 20,
            child: Icon(
              Icons.favorite_rounded,
              size: 20,
              color: AppColors.error,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                banner.title,
                textAlign: TextAlign.right,
                maxLines: 2,
                style: const TextStyle(
                  color: Color(0xFF1E3D7A),
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
