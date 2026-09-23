import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/models/dashboard/banner_model.dart';
import 'package:flutter_nivasshub/widgets/dashboard/banner/banner_card.dart';
import 'package:flutter_nivasshub/models/notices/advertisement_model.dart';

/// Reusable Advertisement Banner component matching Figma Century Bliss / Nikoo Homes card layout.
class AdvertisementBanner extends StatelessWidget {
  const AdvertisementBanner({super.key, required this.advertisement});

  final AdvertisementModel advertisement;

  @override
  Widget build(BuildContext context) {
    final bannerModel = BannerModel(
      bannerId: advertisement.id,
      title: advertisement.title,
      image: advertisement.imageUrl,
      redirectUrl: advertisement.redirectUrl,
    );

    return BannerCard(
      banner: bannerModel,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
