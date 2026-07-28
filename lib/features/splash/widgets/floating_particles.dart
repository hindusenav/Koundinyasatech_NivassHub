import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Ambient background dressing: a couple of very large, very soft light
/// waves drifting slowly, plus small glowing particles drifting/twinkling
/// on top. Both are driven by one fixed, seeded layout so the motion reads
/// as gentle drift rather than flicker.
class FloatingParticles extends StatefulWidget {
  const FloatingParticles({super.key, this.count = 14});

  final int count;

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  static const List<_Wave> _waves = [
    _Wave(dx: 0.3, dy: 0.28, radius: 260, speed: 0.5, phase: 0),
    _Wave(dx: 0.72, dy: 0.62, radius: 220, speed: -0.35, phase: 3.1),
  ];

  @override
  void initState() {
    super.initState();
    final random = math.Random(7);
    _particles = List.generate(
      widget.count,
      (_) => _Particle(
        dx: random.nextDouble(),
        dy: random.nextDouble(),
        radius: 1.5 + random.nextDouble() * 2,
        phase: random.nextDouble() * 2 * math.pi,
        speed: 0.4 + random.nextDouble() * 0.4,
      ),
    );
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlesPainter(
            particles: _particles,
            waves: _waves,
            t: _controller.value,
          ),
        );
      },
    );
  }
}

class _Particle {
  _Particle({
    required this.dx,
    required this.dy,
    required this.radius,
    required this.phase,
    required this.speed,
  });

  final double dx;
  final double dy;
  final double radius;
  final double phase;
  final double speed;
}

class _Wave {
  const _Wave({
    required this.dx,
    required this.dy,
    required this.radius,
    required this.speed,
    required this.phase,
  });

  final double dx;
  final double dy;
  final double radius;
  final double speed;
  final double phase;
}

class _ParticlesPainter extends CustomPainter {
  _ParticlesPainter({required this.particles, required this.waves, required this.t});

  final List<_Particle> particles;
  final List<_Wave> waves;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    for (final wave in waves) {
      final drift = math.sin((t * 2 * math.pi * wave.speed) + wave.phase);
      final position = Offset(
        wave.dx * size.width + drift * 30,
        wave.dy * size.height + math.cos((t * 2 * math.pi * wave.speed) + wave.phase) * 20,
      );
      canvas.drawCircle(
        position,
        wave.radius,
        Paint()
          ..color = AppColors.white.withValues(alpha: 0.035)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80),
      );
    }

    final paint = Paint();
    for (final particle in particles) {
      final drift = math.sin((t * 2 * math.pi * particle.speed) + particle.phase);
      final twinkle =
          0.5 + 0.5 * math.sin((t * 2 * math.pi * particle.speed * 1.3) + particle.phase);
      final position = Offset(
        particle.dx * size.width,
        particle.dy * size.height + drift * 14,
      );

      paint.color = AppColors.splashGlow.withValues(alpha: 0.10 + twinkle * 0.12);
      canvas.drawCircle(position, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) => oldDelegate.t != t;
}
