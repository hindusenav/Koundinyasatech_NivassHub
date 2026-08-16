import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/widgets/shared/brand/nivass_logo_mark.dart';
import 'package:flutter_nivasshub/screens/welcome/welcome_screen.dart';
import 'package:flutter_nivasshub/widgets/splash/animated_ring_painter.dart';
import 'package:flutter_nivasshub/widgets/splash/animated_wordmark.dart';
import 'package:flutter_nivasshub/widgets/splash/converging_house_painter.dart';
import 'package:flutter_nivasshub/widgets/splash/floating_particles.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  static const double _logoSize = 156;

  late final AnimationController _controller;
  late final AnimationController _exitController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    );
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _controller.forward().whenComplete(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      await _exitController.forward();
      if (!mounted) return;
      _goToWelcome();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _exitController.dispose();
    super.dispose();
  }

  void _goToWelcome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        settings: const RouteSettings(name: AppRoutes.welcome),
        transitionDuration: const Duration(milliseconds: 550),
        pageBuilder: (context, animation, secondaryAnimation) => const WelcomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final cardCenter = Offset(size.width / 2, size.height * 0.38);

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([_controller, _exitController]),
        builder: (context, _) {
          final t = _controller.value;

          final backgroundOpacity =
              const Interval(0.0, 0.05, curve: Curves.easeOut).transform(t);
          final centerGlowProgress =
              const Interval(0.0, 0.14, curve: Curves.easeOut).transform(t);
          final dotProgress =
              const Interval(0.08, 0.30, curve: Curves.easeInOutCubic).transform(t);
          final outlineProgress =
              const Interval(0.28, 0.34, curve: Curves.easeOut).transform(t);
          final fillProgress =
              const Interval(0.31, 0.40, curve: Curves.easeOut).transform(t);
          final dotFadeProgress =
              const Interval(0.36, 0.44, curve: Curves.easeIn).transform(t);
          final roughOpacity =
              1 - const Interval(0.58, 0.66, curve: Curves.easeIn).transform(t);
          final ringProgress =
              const Interval(0.42, 0.62, curve: Curves.easeInOutCubic).transform(t);
          final crispEntrance =
              const Interval(0.60, 0.70, curve: Curves.easeOutCubic).transform(t);
          final crispScale = 0.94 + crispEntrance * 0.06;
          final spacingProgress =
              const Interval(0.70, 0.84, curve: Curves.easeOutCubic).transform(t);
          final subtitleProgress =
              const Interval(0.82, 0.90, curve: Curves.easeOut).transform(t);
          final shimmerProgress =
              const Interval(0.88, 1.0, curve: Curves.easeInOut).transform(t);
          final backgroundZoom =
              1.0 + const Interval(0.86, 1.0, curve: Curves.easeOut).transform(t) * 0.03;

          final exitT = Curves.easeInCubic.transform(_exitController.value);
          final exitOpacity = 1.0 - exitT;
          final exitScale = 1.0 - exitT * 0.06;

          return Opacity(
            opacity: backgroundOpacity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: exitOpacity,
                    child: Transform.scale(
                      scale: backgroundZoom,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.splashGradientTop,
                              AppColors.splashGradientBottom,
                            ],
                          ),
                        ),
                        child: const FloatingParticles(),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Opacity(
                    opacity: exitOpacity,
                    child: Transform.scale(
                      scale: exitScale,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: IgnorePointer(
                              child: Center(
                                child: Opacity(
                                  opacity: centerGlowProgress * 0.16,
                                  child: Container(
                                    width: 260,
                                    height: 260,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          AppColors.white.withValues(alpha: 0.9),
                                          AppColors.white.withValues(alpha: 0.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: CustomPaint(
                              painter: ConvergingHousePainter(
                                center: cardCenter,
                                radius: _logoSize / 2,
                                dotProgress: dotProgress,
                                outlineProgress: outlineProgress,
                                fillProgress: fillProgress,
                                dotFadeProgress: dotFadeProgress,
                                roughOpacity: roughOpacity,
                              ),
                            ),
                          ),
                          Positioned(
                            left: cardCenter.dx - _logoSize / 2,
                            top: cardCenter.dy - _logoSize / 2,
                            width: _logoSize,
                            height: _logoSize,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomPaint(
                                  size: Size.square(_logoSize),
                                  painter: AnimatedRingPainter(progress: ringProgress),
                                ),
                                if (shimmerProgress > 0 && shimmerProgress < 1)
                                  IgnorePointer(
                                    child: _ShimmerSweep(
                                      size: _logoSize * 0.86,
                                      progress: shimmerProgress,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: cardCenter.dy + _logoSize / 2 + 24,
                            child: Column(
                              children: [
                                AnimatedWordmark(progress: t, spacingProgress: spacingProgress),
                                const SizedBox(height: 8),
                                Opacity(
                                  opacity: subtitleProgress.clamp(0.0, 1.0) * 0.75,
                                  child: Transform.translate(
                                    offset:
                                        Offset(0, (1 - subtitleProgress).clamp(0.0, 1.0) * 10),
                                    child: const Text(
                                      'Smart Society Management',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 13,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: cardCenter.dx - _logoSize / 2,
                  top: cardCenter.dy - _logoSize / 2,
                  width: _logoSize,
                  height: _logoSize,
                  child: Center(
                    child: Opacity(
                      opacity: crispEntrance.clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: crispScale,
                        child: NivassLogoMark(size: _logoSize * 0.86),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ShimmerSweep extends StatelessWidget {
  const _ShimmerSweep({required this.size, required this.progress});

  final double size;
  final double progress;

  @override
  Widget build(BuildContext context) {
    const band = 0.35;
    final start = -band + (1 + 2 * band) * progress;

    return ClipOval(
      child: ShaderMask(
        blendMode: BlendMode.plus,
        shaderCallback: (bounds) {
          return LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: const [Colors.transparent, Colors.white, Colors.transparent],
            stops: [
              (start - band).clamp(0.0, 1.0),
              start.clamp(0.0, 1.0),
              (start + band).clamp(0.0, 1.0),
            ],
          ).createShader(bounds);
        },
        child: Container(
          width: size,
          height: size,
          color: AppColors.splashGlow.withValues(alpha: 0.25),
        ),
      ),
    );
  }
}
