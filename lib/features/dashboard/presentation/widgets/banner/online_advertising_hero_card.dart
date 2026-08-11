import 'package:flutter/material.dart';

class OnlineAdvertisingHeroCard extends StatelessWidget {
  const OnlineAdvertisingHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Left side yellow illustration background shape
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 140,
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: CustomPaint(
                painter: _YellowShapePainter(),
              ),
            ),
          ),
          // Loudspeaker Megaphone Icon
          Positioned(
            left: 10,
            top: 20,
            child: Transform.rotate(
              angle: -0.2,
              child: const Icon(
                Icons.campaign,
                size: 70,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
          // Envelope and graphics
          const Positioned(
            left: 70,
            top: 16,
            child: Icon(
              Icons.mark_email_unread_rounded,
              size: 22,
              color: Color(0xFFDC2626),
            ),
          ),
          const Positioned(
            left: 95,
            top: 48,
            child: Icon(
              Icons.thumb_up_alt_rounded,
              size: 18,
              color: Color(0xFF1D4ED8),
            ),
          ),
          const Positioned(
            left: 65,
            top: 85,
            child: Icon(
              Icons.star_rounded,
              size: 16,
              color: Color(0xFFD97706),
            ),
          ),
          // Right text
          const Positioned(
            right: 20,
            top: 36,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E3A8A),
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Advertising',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E3A8A),
                    letterSpacing: -0.5,
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

class _YellowShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFDE047)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.8, 0)
      ..lineTo(size.width * 0.5, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
