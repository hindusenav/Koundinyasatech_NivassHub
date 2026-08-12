import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../notices/screens/advertisement_details_screen.dart';
import '../../../data/models/banner_model.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({
    super.key,
    required this.banner,
  });

  final BannerModel banner;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AdvertisementDetailsScreen(projectName: banner.title),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 150,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xffF6F1E8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned(
              left: -8,
              bottom: -10,
              child: Icon(
                Icons.campaign_rounded,
                size: 82,
                color: AppColors.tertiary,
              ),
            ),

            Positioned(
              left: 40,
              top: 16,
              child: Transform.rotate(
                angle: -.35,
                child: const Icon(
                  Icons.mail,
                  size: 18,
                  color: Colors.red,
                ),
              ),
            ),

            const Positioned(
              left: 70,
              top: 42,
              child: Icon(
                Icons.thumb_up,
                size: 18,
                color: Color(0xff1E3D7A),
              ),
            ),

            const Positioned(
              left: 82,
              top: 14,
              child: Icon(
                Icons.favorite,
                size: 14,
                color: Colors.red,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 110,
                right: 20,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  banner.title,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1E3D7A),
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
