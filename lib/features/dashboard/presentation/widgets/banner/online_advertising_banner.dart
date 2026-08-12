import 'package:flutter/material.dart';

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
    return Container(
      width: double.infinity,
      height: 135,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFCBD5E1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .02),
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
                  left: -15,
                  bottom: -25,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFCC00),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Top Yellow Lightning Bolt
                const Positioned(
                  left: 70,
                  top: 15,
                  child: Icon(
                    Icons.bolt,
                    size: 40,
                    color: Color(0xFFFFCC00),
                  ),
                ),

                // Bottom Yellow Lightning Bolt
                const Positioned(
                  left: 110,
                  bottom: 25,
                  child: Icon(
                    Icons.bolt,
                    size: 32,
                    color: Color(0xFFFFCC00),
                  ),
                ),

                // Red Mail Envelope
                Positioned(
                  left: 105,
                  top: 25,
                  child: Transform.rotate(
                    angle: 0.15,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.email,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Yellow Shopping Cart
                Positioned(
                  left: 100,
                  top: 60,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFCC00),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.shopping_cart,
                      size: 16,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),

                // Blue Thumbs Up Badge
                Positioned(
                  left: 125,
                  top: 72,
                  child: Transform.rotate(
                    angle: -0.1,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D4ED8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.thumb_up,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Small Heart Badge
                Positioned(
                  left: 105,
                  bottom: 35,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Large Red & Blue Megaphone
                Positioned(
                  left: 20,
                  bottom: 12,
                  child: Transform.rotate(
                    angle: 0.2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.campaign,
                        size: 52,
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
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF163E75),
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
