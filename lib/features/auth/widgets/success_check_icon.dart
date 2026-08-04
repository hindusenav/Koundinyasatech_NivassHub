import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';

/// Green success circle + checkmark, with a slowly rotating segmented ring
/// and a few sparkles that fade in sequentially. [entrance] (0..1, one-shot)
/// drives the scale-in and sparkle stagger; the ring's rotation is a
/// separate, always-running loop owned locally — same idiom as
/// `OnboardingLogoCard`'s ambient float.
class SuccessCheckIcon extends StatefulWidget {
  const SuccessCheckIcon({super.key, required this.entrance, this.size = 140});

  final double entrance;
  final double size;

  @override
  State<SuccessCheckIcon> createState() => _SuccessCheckIconState();
}

class _SuccessCheckIconState extends State<SuccessCheckIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ringController;

  static const List<double> _sparkleAngles = [-0.9, 0.5, 2.1, 3.6];
  static const List<List<double>> _sparkleIntervals = [
    [0.30, 0.60],
    [0.40, 0.70],
    [0.50, 0.80],
    [0.60, 0.90],
  ];

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entrance = widget.entrance.clamp(0.0, 1.0);
    final ringSize = widget.size * 1.5;

    return SizedBox(
      width: ringSize,
      height: ringSize,
      child: AnimatedBuilder(
        animation: _ringController,
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: entrance,
                child: Transform.rotate(
                  angle: _ringController.value * 2 * math.pi,
                  child: CustomPaint(
                    size: Size.square(ringSize),
                    painter: _RingPainter(),
                  ),
                ),
              ),
              ..._buildSparkles(ringSize, entrance),
              Transform.scale(
                scale: 0.8 + entrance * 0.2,
                child: Opacity(
                  opacity: entrance,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.success.withValues(alpha: 0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      AppIcons.check,
                      color: AppColors.white,
                      size: widget.size * 0.5,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildSparkles(double ringSize, double entrance) {
    final radius = ringSize / 2 * 0.92;

    return List.generate(_sparkleAngles.length, (i) {
      final sparkleT = Interval(
        _sparkleIntervals[i][0],
        _sparkleIntervals[i][1],
        curve: Curves.easeOut,
      ).transform(entrance).clamp(0.0, 1.0);
      final offset = Offset(math.cos(_sparkleAngles[i]), math.sin(_sparkleAngles[i])) * radius;

      return Positioned(
        left: ringSize / 2 + offset.dx - 6,
        top: ringSize / 2 + offset.dy - 6,
        child: Opacity(
          opacity: sparkleT,
          child: Transform.scale(
            scale: 0.5 + sparkleT * 0.5,
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.7;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..color = AppColors.success.withValues(alpha: 0.45);

    const segmentCount = 8;
    const sweep = math.pi / 10;
    for (var i = 0; i < segmentCount; i++) {
      final start = (2 * math.pi / segmentCount) * i;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) => false;
}
