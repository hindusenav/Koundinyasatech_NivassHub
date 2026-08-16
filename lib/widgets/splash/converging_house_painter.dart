import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';

/// Several small glowing dots — each standing in for a resident — travel in
/// from different directions, leaving soft trails, and settle onto the
/// vertices of a simple house silhouette. Once settled, the outline draws
/// itself and glows in with a soft white fill. Everything here fades out
/// together via [roughOpacity] once the polished logo is ready to take over.
class ConvergingHousePainter extends CustomPainter {
  ConvergingHousePainter({
    required this.center,
    required this.radius,
    required this.dotProgress,
    required this.outlineProgress,
    required this.fillProgress,
    required this.dotFadeProgress,
    required this.roughOpacity,
  });

  final Offset center;
  final double radius;

  /// 0..1 — dots traveling from their start positions to the house vertices.
  final double dotProgress;

  /// 0..1 — the connecting outline drawing itself in.
  final double outlineProgress;

  /// 0..1 — the soft white glow-fill inside the outline.
  final double fillProgress;

  /// 0..1 — how much the individual dots have faded out (1 = fully gone).
  final double dotFadeProgress;

  /// Overall fade for this whole rough/abstract stage as the polished logo
  /// takes over.
  final double roughOpacity;

  static const List<double> _startAngles = [0.3, 1.2, 2.1, 3.3, 4.3, 5.4];
  static const List<int> _vertexOf = [0, 1, 2, 3, 4, 0];

  @override
  void paint(Canvas canvas, Size size) {
    if (roughOpacity <= 0) return;

    final vertices = _houseVertices();
    final startRadius = size.longestSide * 0.62;

    if (dotProgress > 0 && dotFadeProgress < 1) {
      final dotAlpha = (1 - dotFadeProgress) * roughOpacity;

      for (var i = 0; i < _startAngles.length; i++) {
        final start = center +
            Offset(math.cos(_startAngles[i]), math.sin(_startAngles[i])) * startRadius;
        final target = vertices[_vertexOf[i]];

        for (var k = 0; k < 5; k++) {
          final trailT = (dotProgress - k * 0.05).clamp(0.0, 1.0);
          final trailPos = Offset.lerp(start, target, trailT)!;
          final trailAlpha = (1 - k / 5) * 0.35 * dotAlpha;
          canvas.drawCircle(
            trailPos,
            4.5 - k * 0.5,
            Paint()..color = AppColors.splashGlow.withValues(alpha: trailAlpha),
          );
        }

        final pos = Offset.lerp(start, target, dotProgress)!;
        canvas.drawCircle(
          pos,
          7,
          Paint()
            ..color = AppColors.splashGlow.withValues(alpha: 0.5 * dotAlpha)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
        );
        canvas.drawCircle(pos, 3.2, Paint()..color = AppColors.white.withValues(alpha: dotAlpha));
      }
    }

    if (outlineProgress > 0) {
      final path = Path()..moveTo(vertices[0].dx, vertices[0].dy);
      for (var i = 1; i < vertices.length; i++) {
        path.lineTo(vertices[i].dx, vertices[i].dy);
      }
      path.close();

      final outlinePaint = Paint()
        ..color = AppColors.white.withValues(alpha: outlineProgress * 0.85 * roughOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(path, outlinePaint);

      if (fillProgress > 0) {
        canvas.drawPath(
          path,
          Paint()
            ..color = AppColors.white.withValues(alpha: fillProgress * 0.55 * roughOpacity)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
        );
        canvas.drawPath(
          path,
          Paint()..color = AppColors.white.withValues(alpha: fillProgress * 0.7 * roughOpacity),
        );
      }
    }
  }

  List<Offset> _houseVertices() {
    return [
      center + Offset(0, -0.52 * radius), // peak
      center + Offset(-0.46 * radius, -0.06 * radius), // left eave
      center + Offset(-0.46 * radius, 0.34 * radius), // bottom-left
      center + Offset(0.46 * radius, 0.34 * radius), // bottom-right
      center + Offset(0.46 * radius, -0.06 * radius), // right eave
    ];
  }

  @override
  bool shouldRepaint(covariant ConvergingHousePainter oldDelegate) {
    return oldDelegate.dotProgress != dotProgress ||
        oldDelegate.outlineProgress != outlineProgress ||
        oldDelegate.fillProgress != fillProgress ||
        oldDelegate.dotFadeProgress != dotFadeProgress ||
        oldDelegate.roughOpacity != roughOpacity ||
        oldDelegate.center != center;
  }
}
