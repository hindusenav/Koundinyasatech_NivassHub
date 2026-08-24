import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';

class OnlineAdvertisingBannerCard extends StatelessWidget {
  const OnlineAdvertisingBannerCard({
    super.key,
    this.title = 'Online\nAdvertising',
    this.onTap,
  });

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xFFF9F9FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFCBD5E1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .3 : .02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Online Advertising details coming soon.')),
                );
              },
          borderRadius: BorderRadius.circular(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Yellow sun background circle at bottom left
                Positioned(
                  left: -11,
                  bottom: -19,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFCC00),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Top Yellow Lightning Bolt
                const Positioned(
                  left: 52,
                  top: 11,
                  child: Icon(
                    Icons.bolt,
                    size: 30,
                    color: Color(0xFFFFCC00),
                  ),
                ),

                // Bottom Yellow Lightning Bolt
                const Positioned(
                  left: 82,
                  bottom: 18,
                  child: Icon(
                    Icons.bolt,
                    size: 24,
                    color: Color(0xFFFFCC00),
                  ),
                ),

                // Red Mail Envelope
                Positioned(
                  left: 78,
                  top: 18,
                  child: Transform.rotate(
                    angle: 0.15,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        Icons.email,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Yellow Shopping Cart
                Positioned(
                  left: 74,
                  top: 44,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFCC00),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Icon(
                      Icons.shopping_cart,
                      size: 12,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),

                // Blue Thumbs Up Badge
                Positioned(
                  left: 93,
                  top: 53,
                  child: Transform.rotate(
                    angle: -0.1,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D4ED8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.thumb_up,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Small Heart Badge
                Positioned(
                  left: 78,
                  bottom: 26,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      size: 9,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Large Red & Blue Megaphone
                Positioned(
                  left: 15,
                  bottom: 9,
                  child: Transform.rotate(
                    angle: 0.2,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.campaign,
                        size: 38,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Right Side Bold Title Text ("Online Advertising")
                Positioned(
                  right: 24,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: isDark ? AppColors.primaryLight : const Color(0xFF163E75),
                        height: 1.1,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
