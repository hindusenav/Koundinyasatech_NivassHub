import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_provider.dart';
import '../empty/section_empty.dart';
import 'advertisement_card.dart';

class AdvertisementSection extends StatelessWidget {
  const AdvertisementSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    final banners = provider.advertisementBanners;

    if (banners.isEmpty) {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: SectionEmpty(
      icon: Icons.image_outlined,
      title: 'No Advertisements',
      message:
          'Advertisements will appear here when available.',
    ),
  );
}

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          const Text(
            "Advertisements",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          ...banners.map(
            (banner) => AdvertisementCard(
              banner: banner,
              onTap: () {
                if (banner.redirectUrl.isNotEmpty) {
                  // Launch URL when backend provides one.
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Redirect URL is not available.',
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}