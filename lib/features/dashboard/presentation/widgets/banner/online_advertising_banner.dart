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
      height: 191,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF05234D),
            Color(0xFF13A391),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.5),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9FB),
            borderRadius: BorderRadius.circular(11.5),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(11.5),
            child: InkWell(
              onTap: onTap ??
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Online Advertising details coming soon.')),
                    );
                  },
              borderRadius: BorderRadius.circular(11.5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11.5),
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
                      top: 25,
                      child: Icon(
                        Icons.bolt,
                        size: 40,
                        color: Color(0xFFFFCC00),
                      ),
                    ),

                    // Bottom Yellow Lightning Bolt
                    const Positioned(
                      left: 110,
                      bottom: 35,
                      child: Icon(
                        Icons.bolt,
                        size: 32,
                        color: Color(0xFFFFCC00),
                      ),
                    ),

                    // Red Mail Envelope
                    Positioned(
                      left: 105,
                      top: 35,
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
                      top: 80,
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
                      top: 95,
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
                      bottom: 50,
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
                      bottom: 24,
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
                            fontSize: 24,
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
        ),
      ),
    );
  }
}
