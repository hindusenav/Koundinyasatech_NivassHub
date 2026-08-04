import 'package:flutter/material.dart';
import '../auth_colors.dart';

/// Decorative outline-only skyline for the Login screen: a couple of
/// apartment blocks, two houses, trees, a road, a car, and a few clouds —
/// all light-blue strokes at low opacity. Purely decorative; the parent
/// wraps this in `IgnorePointer` so it never intercepts taps.
class AuthSkylinePainter extends CustomPainter {
  AuthSkylinePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final opacity = progress.clamp(0.0, 1.0);
    if (opacity <= 0) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = AuthColors.lightBlue.withValues(alpha: 0.10 * opacity);

    final w = size.width;
    final h = size.height;
    final groundY = h * 0.62;

    canvas.drawLine(Offset(0, groundY + h * 0.12), Offset(w, groundY + h * 0.12), paint);

    _drawCloud(canvas, paint, Offset(w * 0.18, h * 0.10), w * 0.09);
    _drawCloud(canvas, paint, Offset(w * 0.78, h * 0.08), w * 0.07);
    _drawCloud(canvas, paint, Offset(w * 0.48, h * 0.04), w * 0.06);

    _drawBuilding(
      canvas,
      paint,
      Rect.fromLTWH(w * 0.02, groundY - h * 0.42, w * 0.15, h * 0.42),
      rows: 4,
      cols: 2,
    );
    _drawBuilding(
      canvas,
      paint,
      Rect.fromLTWH(w * 0.82, groundY - h * 0.34, w * 0.15, h * 0.34),
      rows: 3,
      cols: 2,
    );

    _drawHouse(canvas, paint, base: Offset(w * 0.34, groundY), width: w * 0.20, height: h * 0.30);
    _drawHouse(canvas, paint, base: Offset(w * 0.62, groundY), width: w * 0.17, height: h * 0.24);

    _drawTree(canvas, paint, Offset(w * 0.22, groundY), h * 0.24);
    _drawTree(canvas, paint, Offset(w * 0.92, groundY + h * 0.02), h * 0.18);

    _drawCar(canvas, paint, Offset(w * 0.50, groundY + h * 0.16), w * 0.15);
  }

  void _drawCloud(Canvas canvas, Paint paint, Offset center, double r) {
    canvas.drawCircle(center + Offset(-r * 0.6, 0), r * 0.6, paint);
    canvas.drawCircle(center, r * 0.8, paint);
    canvas.drawCircle(center + Offset(r * 0.7, r * 0.05), r * 0.55, paint);
  }

  void _drawBuilding(
    Canvas canvas,
    Paint paint,
    Rect rect, {
    required int rows,
    required int cols,
  }) {
    canvas.drawRect(rect, paint);
    final colW = rect.width / cols;
    final rowH = rect.height / rows;
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final windowRect = Rect.fromLTWH(
          rect.left + c * colW + colW * 0.22,
          rect.top + r * rowH + rowH * 0.22,
          colW * 0.56,
          rowH * 0.5,
        );
        canvas.drawRect(windowRect, paint);
      }
    }
  }

  void _drawHouse(
    Canvas canvas,
    Paint paint, {
    required Offset base,
    required double width,
    required double height,
  }) {
    final left = base.dx - width / 2;
    final right = base.dx + width / 2;
    final top = base.dy - height;
    final roofPeak = Offset(base.dx, top - height * 0.4);

    final path = Path()
      ..moveTo(left, base.dy)
      ..lineTo(left, top)
      ..lineTo(roofPeak.dx, roofPeak.dy)
      ..lineTo(right, top)
      ..lineTo(right, base.dy);
    canvas.drawPath(path, paint);

    final doorWidth = width * 0.18;
    canvas.drawRect(
      Rect.fromLTWH(base.dx - doorWidth / 2, base.dy - height * 0.42, doorWidth, height * 0.42),
      paint,
    );
  }

  void _drawTree(Canvas canvas, Paint paint, Offset base, double height) {
    canvas.drawLine(base, base - Offset(0, height * 0.4), paint);
    canvas.drawCircle(base - Offset(0, height * 0.7), height * 0.32, paint);
  }

  void _drawCar(Canvas canvas, Paint paint, Offset center, double width) {
    final bodyRect = Rect.fromCenter(center: center, width: width, height: width * 0.32);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, Radius.circular(width * 0.08)),
      paint,
    );
    canvas.drawCircle(Offset(center.dx - width * 0.28, center.dy + width * 0.16), width * 0.09, paint);
    canvas.drawCircle(Offset(center.dx + width * 0.28, center.dy + width * 0.16), width * 0.09, paint);
  }

  @override
  bool shouldRepaint(covariant AuthSkylinePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
