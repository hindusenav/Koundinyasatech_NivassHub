import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';

/// Circular badge matching Figma Illustration Container:
/// - Container Size: 64x64 (Radius: 32)
/// - Background: BLUE NH (#0E2543)
/// - Shadow: Shadow cards 1 (X: 4, Y: 4, Blur: 4, Spread: 0, #000000 15%)
/// - Inner Icon: `# shield-check` (Width: 28px, Height: 28px)
class AuthShieldBadge extends StatelessWidget {
  const AuthShieldBadge({
    super.key,
    this.size = 64,
    this.iconSize = 28,
  });

  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AuthColors.navyBadge,
        boxShadow: [AuthColors.shadowCards1],
      ),
      child: Center(
        child: CustomPaint(
          size: Size(iconSize, iconSize),
          painter: const _ShieldCheckPainter(color: Colors.white),
        ),
      ),
    );
  }
}

class _ShieldCheckPainter extends CustomPainter {
  const _ShieldCheckPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // Scale standard 24x24 icon viewport to actual size (e.g. 28x28)
    canvas.scale(size.width / 24.0, size.height / 24.0);

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Shield outline matching Figma # shield-check:
    // Peaks UP at apex (12, 3.2), slopes down to shoulders (19.8, 6.2),
    // runs straight vertical to (19.8, 12.0), then curves smoothly to bottom point (12, 20.8).
    final path = Path();
    path.moveTo(12.0, 3.2);
    // Slope down-right to shoulder
    path.cubicTo(16.0, 3.8, 19.8, 5.2, 19.8, 6.2);
    // Vertical right side down to midpoint
    path.lineTo(19.8, 12.0);
    // Right bottom curve to bottom tip
    path.cubicTo(19.8, 16.5, 16.5, 19.8, 12.0, 20.8);
    // Left bottom curve from bottom tip
    path.cubicTo(7.5, 19.8, 4.2, 16.5, 4.2, 12.0);
    // Left vertical side up to shoulder
    path.lineTo(4.2, 6.2);
    // Top left slope back up to apex
    path.cubicTo(4.2, 5.2, 8.0, 3.8, 12.0, 3.2);
    path.close();

    canvas.drawPath(path, strokePaint);

    // Centered checkmark inside shield: M9 12 l2.2 2.3 l4.3 -4.5
    final checkPath = Path();
    checkPath.moveTo(9.0, 12.0);
    checkPath.lineTo(11.2, 14.3);
    checkPath.lineTo(15.5, 9.8);

    canvas.drawPath(checkPath, strokePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShieldCheckPainter oldDelegate) =>
      oldDelegate.color != color;
}
