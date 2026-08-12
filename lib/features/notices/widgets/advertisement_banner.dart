import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/advertisement_model.dart';

/// Reusable Advertisement Banner component matching Figma ALTURA card.
class AdvertisementBanner extends StatelessWidget {
  const AdvertisementBanner({super.key, required this.advertisement});

  final AdvertisementModel advertisement;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: advertisement.imageUrl.isNotEmpty
                  ? advertisement.imageUrl
                  : 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00',
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(color: const Color(0xFF1E293B)),
              errorWidget: (_, _, _) => Container(
                color: const Color(0xFF1E293B),
                child: const Center(
                  child: Icon(Icons.apartment, size: 60, color: Colors.white70),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Ad',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        advertisement.title.isNotEmpty
                            ? advertisement.title
                            : 'ALTURA',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        advertisement.subtitle.isNotEmpty
                            ? advertisement.subtitle
                            : '2 & 3 BHK Homes',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF08A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    advertisement.price.isNotEmpty
                        ? advertisement.price
                        : '₹1.30 Crore Onwards',
                    style: const TextStyle(
                      color: Color(0xFF854D0E),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
