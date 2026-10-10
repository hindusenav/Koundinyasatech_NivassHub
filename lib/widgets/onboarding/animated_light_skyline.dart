import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/asset_constants.dart';
import 'package:flutter_nivasshub/constants/onboarding/onboarding_colors.dart';

/// Light-mode skyline for Onboarding Screen 2, gently animated.
///
/// The navy line-art asset is recolored (navy -> transparent, white strokes ->
/// soft blue) and split into layers by clipping the same image:
///  * clouds and birds drift left to right at different speeds, with a slight
///    vertical float, and fade in/out at the edges so they never pop;
///  * buildings are split into a back and a front band that sway a pixel or two
///    in opposite directions for soft parallax;
///  * a faint sun glow slowly travels across the sky.
///
/// With animations disabled (reduced motion) it renders the static artwork.
class AnimatedLightSkyline extends StatefulWidget {
  const AnimatedLightSkyline({super.key});

  @override
  State<AnimatedLightSkyline> createState() => _AnimatedLightSkylineState();
}

class _AnimatedLightSkylineState extends State<AnimatedLightSkyline>
    with SingleTickerProviderStateMixin {
  // Source image size and the regions (in source pixels) of the movable parts.
  static const double _srcW = 854;
  static const double _srcH = 1842;
  static const double _splitY = 1590; // back / front building bands.

  static const Rect _cloudLarge = Rect.fromLTRB(655, 1170, 845, 1265);
  static const Rect _cloudLeft = Rect.fromLTRB(0, 1015, 165, 1105);
  static const Rect _cloudSmall = Rect.fromLTRB(200, 1135, 285, 1190);
  static const Rect _birds = Rect.fromLTRB(730, 1335, 810, 1415);

  // One long loop; every layer uses an integer multiple so it wraps seamlessly.
  static const Duration _loop = Duration(seconds: 180);

  late final AnimationController _controller;
  bool _reduceMotion = false;

  static const ColorFilter _lineFilter = ColorFilter.matrix(<double>[
    0, 0, 0, 0, 59,
    0, 0, 0, 0, 110,
    0, 0, 0, 0, 168,
    0.2126 * 1.25, 0.7152 * 1.25, 0.0722 * 1.25, 0, -0.13 * 1.25 * 255,
  ]);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _loop);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion) {
      _controller.stop();
      _controller.value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final w = box.maxWidth;
        final scale = w / _srcW;
        final imgH = _srcH * scale;

        Widget layer(Rect region, {Path? clip}) => ColorFiltered(
              colorFilter: _lineFilter,
              child: ClipPath(
                clipper: _SourceClipper(region: region, scale: scale, path: clip),
                child: Image.asset(
                  AppAssets.onboardingSkyline,
                  width: w,
                  height: imgH,
                  fit: BoxFit.fill,
                ),
              ),
            );

        final movers = <_Mover>[
          _Mover(_cloudLarge, speed: 3, floatCycles: 24, floatAmp: 2.2, lift: 60),
          _Mover(_cloudLeft, speed: 2, floatCycles: 18, floatAmp: 1.6),
          _Mover(_cloudSmall, speed: 1, floatCycles: 14, floatAmp: 1.2),
          _Mover(_birds, speed: 4, floatCycles: 40, floatAmp: 1.5),
        ];

        final backClip = Path()
          ..fillType = PathFillType.evenOdd
          ..addRect(const Rect.fromLTWH(0, 0, _srcW, _splitY));
        for (final m in movers) {
          backClip.addRect(m.region);
        }
        final backLayer = layer(const Rect.fromLTWH(0, 0, _srcW, _splitY), clip: backClip);
        final frontLayer = layer(const Rect.fromLTWH(0, _splitY, _srcW, _srcH - _splitY));
        final moverLayers = [for (final m in movers) layer(m.region)];

        return ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (r) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x00FFFFFF), Colors.white],
            stops: [0.0, 0.22],
          ).createShader(r),
          child: Opacity(
            opacity: 0.55,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final t = _controller.value;
                final sway = math.sin(t * 2 * math.pi * 30); // ~6s period.
                return ClipRect(
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Positioned.fill(child: _SunGlow(t: t)),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        width: w,
                        height: imgH,
                        child: Stack(
                          children: [
                            Transform.translate(
                              offset: Offset(-1.5 * sway, 0),
                              child: backLayer,
                            ),
                            Transform.translate(
                              offset: Offset(1.5 * sway, 0),
                              child: frontLayer,
                            ),
                            for (var i = 0; i < movers.length; i++)
                              _drift(movers[i], moverLayers[i], t, scale),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Moves [child] (the full-size image clipped to [m].region) rightwards in a
  /// seamless loop, floating vertically a touch, fading near the edges.
  Widget _drift(_Mover m, Widget child, double t, double scale) {
    final region = m.region;
    final travel = (_srcW + region.width + 40) * scale;
    final start = -(region.right + 20) * scale; // fully off-screen left.
    final phase0 = (region.left * scale - start) / travel; // original spot.
    final p = (phase0 + t * m.speed) % 1.0;
    final dx = start + p * travel - region.left * scale;
    final dy = math.sin(t * 2 * math.pi * m.floatCycles) * m.floatAmp - m.lift * scale;
    final edge = math.min(p, 1 - p);
    final fade = Curves.easeOut.transform((edge / 0.12).clamp(0.0, 1.0));
    return Opacity(
      opacity: fade,
      child: Transform.translate(offset: Offset(dx, dy), child: child),
    );
  }
}

class _Mover {
  const _Mover(this.region,
      {required this.speed,
      required this.floatCycles,
      required this.floatAmp,
      this.lift = 0});

  final Rect region;
  final int speed;
  final int floatCycles;
  final double floatAmp;

  /// Source pixels this layer is raised so it clears the buildings it passes.
  final double lift;
}

/// Clips to a source-pixel [region] (or an arbitrary source-space [path]),
/// scaled to the displayed image size.
class _SourceClipper extends CustomClipper<Path> {
  _SourceClipper({required this.region, required this.scale, this.path});

  final Rect region;
  final double scale;
  final Path? path;

  @override
  Path getClip(Size size) {
    final m = Matrix4.diagonal3Values(scale, scale, 1).storage;
    return (path ?? (Path()..addRect(region))).transform(m);
  }

  @override
  bool shouldReclip(_SourceClipper old) =>
      old.scale != scale || old.region != region;
}

/// Very soft warm light that drifts slowly across the sky.
class _SunGlow extends StatelessWidget {
  const _SunGlow({required this.t});

  final double t;

  @override
  Widget build(BuildContext context) {
    final x = 0.15 + 0.55 * (0.5 + 0.5 * math.sin(t * 2 * math.pi * 2));
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(x * 2 - 1, -0.9),
            radius: 0.9,
            colors: [
              OnboardingColors.accentOrangeLight.withValues(alpha: 0.18),
              OnboardingColors.accentOrangeLight.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
