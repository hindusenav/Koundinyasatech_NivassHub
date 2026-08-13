import 'package:flutter/material.dart';

import '../../dashboard/data/models/banner_model.dart';
import '../../dashboard/presentation/widgets/banner/banner_card.dart';
import '../models/advertisement_model.dart';

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

    return BannerCard(banner: bannerModel);
  }
}
