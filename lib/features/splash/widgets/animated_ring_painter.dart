import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Draws the orange ring around the logo card, sweeping clockwise from 12
/// o'clock as [progress] goes 0 -> 1, with rounded caps, a trail of small
/// sparks following the drawing tip throughout, and a soft glow blooming in
/// at the tip near the finish.
class AnimatedRingPainter extends CustomPainter {
  AnimatedRingPainter({required this.progress});

  final double progress;

  static const double _startAngle = -math.pi / 2;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final strokeWidth = size.width * 0.055;
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final sweep = progress * 2 * math.pi;

    final ringPaint = Paint()
      ..shader = const SweepGradient(
        colors: [
          AppColors.splashAccentGold,
          AppColors.splashAccentOrange,
          AppColors.splashAccentAmber,
          AppColors.splashAccentOrange,
          AppColors.splashAccentGold,
        ],
        stops: [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, _startAngle, sweep, false, ringPaint);

    if (progress > 0.03) {
      final tipAngle = _startAngle + sweep;
      final radius = rect.width / 2;
      final center = rect.center;
      for (var k = 1; k <= 4; k++) {
        final sparkAngle = tipAngle - k * 0.14;
        final sparkPos = Offset(
          center.dx + radius * math.cos(sparkAngle),
          center.dy + radius * math.sin(sparkAngle),
        );
        final sparkAlpha = (1 - k / 4) * 0.55;
        canvas.drawCircle(
          sparkPos,
          strokeWidth * (0.32 - k * 0.03),
          Paint()..color = AppColors.splashAccentGold.withValues(alpha: sparkAlpha),
        );
      }
    }

    if (progress > 0.85) {
      final glowOpacity = ((progress - 0.85) / 0.15).clamp(0.0, 1.0);
      final tipAngle = _startAngle + sweep;
      final radius = rect.width / 2;
      final center = rect.center;
      final tip = Offset(
        center.dx + radius * math.cos(tipAngle),
        center.dy + radius * math.sin(tipAngle),
      );
      canvas.drawCircle(
        tip,
        strokeWidth * 0.9,
        Paint()
          ..color = AppColors.splashAccentOrange.withValues(alpha: glowOpacity * 0.6)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, strokeWidth * 0.6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant AnimatedRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
