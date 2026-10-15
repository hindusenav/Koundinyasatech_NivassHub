import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Large success checkmark badge widget matching Figma specifications:
/// A vibrant green gradient circular badge with 3D checkmark, surrounded by
/// a thin green orbital ring with sparkles and dots.
class OtpSuccessBadge extends StatelessWidget {
  const OtpSuccessBadge({super.key, this.size = 280});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: const _OtpVerificationIconPainter(),
      ),
    );
  }
}

class _OtpVerificationIconPainter extends CustomPainter {
  const _OtpVerificationIconPainter();

  double _degToRad(double deg) => deg * math.pi / 180.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final orbitRadius = size.width * 0.44;
    final circleRadius = size.width * 0.28;

    // 1. Orbital Ring Arcs
    final orbitPaint = Paint()
      ..color = const Color(0xFF86EFAC)
      ..strokeWidth = (size.width * 0.007).clamp(1.5, 2.5)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final orbitRect = Rect.fromCircle(center: center, radius: orbitRadius);

    // Segment 1 (Top arc: ~9:45 to ~1:30)
    canvas.drawArc(orbitRect, _degToRad(198), _degToRad(108), false, orbitPaint);

    // Segment 2 (Top-right accent arc: ~1:50 to ~3:20)
    canvas.drawArc(orbitRect, _degToRad(325), _degToRad(55), false, orbitPaint);

    // Segment 3 (Bottom arc: ~4:00 to ~7:30)
    canvas.drawArc(orbitRect, _degToRad(30), _degToRad(105), false, orbitPaint);

    // Segment 4 (Bottom-left accent arc: ~7:50 to ~9:20)
    canvas.drawArc(orbitRect, _degToRad(145), _degToRad(45), false, orbitPaint);

    // 2. Decorative Dots on Orbit
    final dotPaint = Paint()
      ..color = const Color(0xFF86EFAC)
      ..style = PaintingStyle.fill;

    final dotRadius = size.width * 0.013;

    // Dot 1 (~1:30 o'clock, 315 deg)
    final d1Angle = _degToRad(315);
    final dot1Center = Offset(
      center.dx + orbitRadius * math.cos(d1Angle),
      center.dy + orbitRadius * math.sin(d1Angle),
    );
    canvas.drawCircle(dot1Center, dotRadius, dotPaint);

    // Dot 2 (~7:30 o'clock, 140 deg)
    final d2Angle = _degToRad(140);
    final dot2Center = Offset(
      center.dx + orbitRadius * math.cos(d2Angle),
      center.dy + orbitRadius * math.sin(d2Angle),
    );
    canvas.drawCircle(dot2Center, dotRadius, dotPaint);

    // 3. Four-Pointed Sparkles on Orbit
    final sparklePaint = Paint()
      ..color = const Color(0xFF4ADE80)
      ..style = PaintingStyle.fill;

    final sparkleRadius = size.width * 0.038;

    // Sparkle 1 (~9:45 o'clock, 195 deg)
    final sp1Angle = _degToRad(195);
    final sp1Center = Offset(
      center.dx + orbitRadius * math.cos(sp1Angle),
      center.dy + orbitRadius * math.sin(sp1Angle),
    );
    _drawSparkle(canvas, sp1Center, sparkleRadius, sparklePaint);

    // Sparkle 2 (~4:15 o'clock, 25 deg)
    final sp2Angle = _degToRad(25);
    final sp2Center = Offset(
      center.dx + orbitRadius * math.cos(sp2Angle),
      center.dy + orbitRadius * math.sin(sp2Angle),
    );
    _drawSparkle(canvas, sp2Center, sparkleRadius, sparklePaint);

    // 4. Central Badge Shadow
    final shadowPaint = Paint()
      ..color = const Color(0x3522C55E)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, size.width * 0.06);

    canvas.drawCircle(
      center.translate(0, size.width * 0.025),
      circleRadius,
      shadowPaint,
    );

    // Ambient soft shadow
    final ambientShadowPaint = Paint()
      ..color = const Color(0x12000000)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, size.width * 0.03);

    canvas.drawCircle(
      center.translate(0, size.width * 0.012),
      circleRadius,
      ambientShadowPaint,
    );

    // 5. Central Badge Gradient Circle
    final circleRect = Rect.fromCircle(center: center, radius: circleRadius);
    final circlePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF5EE88A),
          Color(0xFF22C55E),
        ],
      ).createShader(circleRect);

    canvas.drawCircle(center, circleRadius, circlePaint);

    // 6. Checkmark
    final checkPath = Path();
    checkPath.moveTo(
      center.dx - circleRadius * 0.44,
      center.dy - circleRadius * 0.02,
    );
    checkPath.lineTo(
      center.dx - circleRadius * 0.12,
      center.dy + circleRadius * 0.36,
    );
    checkPath.lineTo(
      center.dx + circleRadius * 0.46,
      center.dy - circleRadius * 0.30,
    );

    final checkStrokeWidth = circleRadius * 0.22;

    // Checkmark 3D Depth Shadow
    final checkShadowPath = Path();
    final shadowOffsetY = circleRadius * 0.035;
    checkShadowPath.moveTo(
      center.dx - circleRadius * 0.44,
      center.dy - circleRadius * 0.02 + shadowOffsetY,
    );
    checkShadowPath.lineTo(
      center.dx - circleRadius * 0.12,
      center.dy + circleRadius * 0.36 + shadowOffsetY,
    );
    checkShadowPath.lineTo(
      center.dx + circleRadius * 0.46,
      center.dy - circleRadius * 0.30 + shadowOffsetY,
    );

    final checkShadowPaint = Paint()
      ..color = const Color(0x28000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = checkStrokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawPath(checkShadowPath, checkShadowPaint);

    // Checkmark Foreground
    final checkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = checkStrokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(checkPath, checkPaint);
  }

  void _drawSparkle(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path()
      ..moveTo(center.dx, center.dy - radius)
      ..quadraticBezierTo(center.dx, center.dy, center.dx + radius, center.dy)
      ..quadraticBezierTo(center.dx, center.dy, center.dx, center.dy + radius)
      ..quadraticBezierTo(center.dx, center.dy, center.dx - radius, center.dy)
      ..quadraticBezierTo(center.dx, center.dy, center.dx, center.dy - radius)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _OtpVerificationIconPainter oldDelegate) => false;
}
