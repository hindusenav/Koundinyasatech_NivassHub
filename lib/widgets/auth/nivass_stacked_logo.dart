import 'package:flutter/material.dart';

/// Pixel-perfect stacked brand logo matching Figma Dev Mode specifications
/// for `nivaashub-logo-stacked.png` (238x238 fit).
///
/// Consists of:
/// 1. Tri-color geometric house mark (Blue roof chevron, Navy center dot,
///    Terracotta orange bottom-left bracket, Emerald green bottom-right bracket)
/// 2. "nivaas" (Navy) + "hub" (Terracotta orange) title in DM Sans bold
/// 3. "ONE COMMUNITY · ONE PLATFORM" subtitle in DM Sans with tracking
class NivassStackedLogo extends StatelessWidget {
  const NivassStackedLogo({
    super.key,
    this.width = 238,
    this.scale = 1.0,
  });

  final double width;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * scale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Geometric Brand Mark
          CustomPaint(
            size: Size(68 * scale, 68 * scale),
            painter: _NivassLogoMarkPainter(),
          ),
          SizedBox(height: 12 * scale),
          // Brand Title: nivaashub
          RichText(
            text: TextSpan(
              text: 'nivaas',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 32 * scale,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A4789), // Navy Blue
                letterSpacing: -0.5,
                height: 1.0,
              ),
              children: [
                TextSpan(
                  text: 'hub',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 32 * scale,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFC85A2A), // Terracotta Orange
                    letterSpacing: -0.5,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8 * scale),
          // Subtitle / Tagline
          Text(
            'ONE COMMUNITY · ONE PLATFORM',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 8.5 * scale,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
              letterSpacing: 2.2 * scale,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _NivassLogoMarkPainter extends CustomPainter {
  const _NivassLogoMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Coordinate space based on 68x68 design canvas
    final scaleX = size.width / 68.0;
    final scaleY = size.height / 68.0;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    const strokeW = 8.5;

    // 1. Blue Roof Chevron (Top)
    final bluePaint = Paint()
      ..color = const Color(0xFF1A4789)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final roofPath = Path()
      ..moveTo(16, 29)
      ..lineTo(34, 13)
      ..lineTo(52, 29);
    canvas.drawPath(roofPath, bluePaint);

    // 2. Navy Center Dot
    final navyPaint = Paint()
      ..color = const Color(0xFF0E2543)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(34, 34), 7.5, navyPaint);

    // 3. Orange Bottom-Left Bracket
    final orangePaint = Paint()
      ..color = const Color(0xFFC85A2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final leftBracketPath = Path()
      ..moveTo(15, 34)
      ..lineTo(10, 52)
      ..lineTo(29, 58);
    canvas.drawPath(leftBracketPath, orangePaint);

    // 4. Emerald Green Bottom-Right Bracket
    final greenPaint = Paint()
      ..color = const Color(0xFF009A60)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final rightBracketPath = Path()
      ..moveTo(53, 34)
      ..lineTo(58, 52)
      ..lineTo(39, 58);
    canvas.drawPath(rightBracketPath, greenPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _NivassLogoMarkPainter oldDelegate) => false;
}
