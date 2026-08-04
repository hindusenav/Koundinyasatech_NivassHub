import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Ambient decorative backdrop: a handful of large, very soft blurred blobs
/// in brand blue/teal/amber tones, drifting slowly near the screen edges.
/// Purely decorative — ignores pointer events and is excluded from semantics.
class SoftBlobBackground extends StatefulWidget {
  const SoftBlobBackground({
    super.key,
    this.blobCount = 4,
    this.driftAmplitude = 16,
  });

  final int blobCount;
  final double driftAmplitude;

  @override
  State<SoftBlobBackground> createState() => _SoftBlobBackgroundState();
}

class _SoftBlobBackgroundState extends State<SoftBlobBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Blob> _blobs;

  static const List<Color> _palette = [
    AppColors.primaryLight,
    AppColors.secondaryLight,
    AppColors.tertiary,
  ];

  @override
  void initState() {
    super.initState();
    final random = math.Random(11);
    _blobs = List.generate(widget.blobCount, (i) {
      return _Blob(
        dx: _edgeBiased(random),
        dy: _edgeBiased(random),
        radius: 120 + random.nextDouble() * 90,
        color: _palette[i % _palette.length],
        alpha: 0.06 + random.nextDouble() * 0.04,
        phase: random.nextDouble() * 2 * math.pi,
        speed: 0.3 + random.nextDouble() * 0.25,
      );
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();
  }

  static double _edgeBiased(math.Random random) {
    return random.nextBool()
        ? -0.05 + random.nextDouble() * 0.3
        : 0.75 + random.nextDouble() * 0.3;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              size: Size.infinite,
              painter: _BlobPainter(
                blobs: _blobs,
                t: _controller.value,
                amplitude: widget.driftAmplitude,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Blob {
  _Blob({
    required this.dx,
    required this.dy,
    required this.radius,
    required this.color,
    required this.alpha,
    required this.phase,
    required this.speed,
  });

  final double dx;
  final double dy;
  final double radius;
  final Color color;
  final double alpha;
  final double phase;
  final double speed;
}

class _BlobPainter extends CustomPainter {
  _BlobPainter({required this.blobs, required this.t, required this.amplitude});

  final List<_Blob> blobs;
  final double t;
  final double amplitude;

  @override
  void paint(Canvas canvas, Size size) {
    for (final blob in blobs) {
      final angle = t * 2 * math.pi * blob.speed + blob.phase;
      final position = Offset(
        blob.dx * size.width + math.cos(angle) * amplitude,
        blob.dy * size.height + math.sin(angle) * amplitude,
      );
      canvas.drawCircle(
        position,
        blob.radius,
        Paint()
          ..color = blob.color.withValues(alpha: blob.alpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BlobPainter oldDelegate) => oldDelegate.t != t;
}
