import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/asset_constants.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';
import 'package:flutter_nivasshub/screens/welcome/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Flow (3600ms total), matching the design:
  //   navy launch screen -> white screen with the mark -> full logo -> welcome
  //
  //   0.0-0.3s  solid navy (same colour as the native launch window)
  //   0.3-0.9s  background eases navy -> white
  //   0.7-1.2s  mark fades in, scale 0.85 -> 0.96
  //   1.2-1.8s  scale 0.96 -> 1.02 -> 1.00 (settle)
  //   1.3-2.1s  mark rotates 120 degrees (3-way symmetric, ends identical)
  //   2.2-3.1s  mark glides left into the full logo while the wordmark
  //             fades and slides in
  //   3.1-3.6s  hold, then navigate
  static const int _totalMs = 3600;
  static const Duration _duration = Duration(milliseconds: _totalMs);
  static const Interval _backgroundInterval = Interval(
    300 / _totalMs,
    900 / _totalMs,
    curve: Curves.easeInOut,
  );
  static const Interval _fadeInterval = Interval(
    700 / _totalMs,
    1200 / _totalMs,
    curve: Curves.easeOut,
  );
  static const Interval _scaleInterval = Interval(
    700 / _totalMs,
    1800 / _totalMs,
  );
  static const Interval _rotationInterval = Interval(
    1300 / _totalMs,
    2100 / _totalMs,
    curve: Curves.easeInOutCubic,
  );
  static const Interval _slideInterval = Interval(
    2200 / _totalMs,
    3100 / _totalMs,
    curve: Curves.easeInOutCubic,
  );
  static const Interval _wordmarkInterval = Interval(
    2300 / _totalMs,
    3100 / _totalMs,
    curve: Curves.easeOut,
  );
  static const double _rotationAngle = 120.0 * math.pi / 180.0;
  static const double _wordmarkSlideUnits = 26;

  // Logo proportions from the original artwork (viewBox units): a 140-tall
  // mark, a 38 gap, then a 403x66 wordmark.
  static const double _markUnits = 140;
  static const double _gapUnits = 38;
  static const double _wordmarkWidthUnits = 403;
  static const double _wordmarkHeightUnits = 66;
  static const double _totalUnits =
      _markUnits + _gapUnits + _wordmarkWidthUnits;
  static const double _logoWidthFraction = 0.78;
  static const double _logoMaxWidth = 420;

  late final AnimationController _controller;
  late final Animation<Color?> _background;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<double> _rotation;
  late final Animation<double> _slide;
  late final Animation<double> _wordmark;
  late final Future<AuthStartDestination> _destinationFuture;

  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _duration);

    _background = ColorTween(
      begin: AppColors.splashBackgroundNavy,
      end: AppColors.white,
    ).animate(CurvedAnimation(parent: _controller, curve: _backgroundInterval));

    _fade = CurvedAnimation(parent: _controller, curve: _fadeInterval);

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.85,
          end: 0.96,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.96,
          end: 1.02,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.02,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: _scaleInterval));

    _rotation = Tween<double>(
      begin: 0.0,
      end: _rotationAngle,
    ).animate(CurvedAnimation(parent: _controller, curve: _rotationInterval));

    _slide = CurvedAnimation(parent: _controller, curve: _slideInterval);
    _wordmark = CurvedAnimation(parent: _controller, curve: _wordmarkInterval);

    // Resolve the destination while the animation plays.
    _destinationFuture = context
        .read<AuthStateProvider>()
        .resolveStartDestination();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) _navigate();
    });

    _start();
  }

  /// Warms the SVG cache so the first frame already has the logo, then plays
  /// the animation once. Falls back to playing immediately if warming fails.
  Future<void> _start() async {
    try {
      await Future.wait([
        _warm(AppAssets.splashMark),
        _warm(AppAssets.splashWordmark),
      ]);
    } catch (e) {
      debugPrint('[Splash] SVG warm-up failed: $e');
    }
    if (mounted) _controller.forward();
  }

  Future<void> _warm(String asset) {
    final loader = SvgAssetLoader(asset);
    return svg.cache.putIfAbsent(
      loader.cacheKey(null),
      () => loader.loadBytes(null),
    );
  }

  Future<void> _navigate() async {
    if (_navigated || !mounted) return;
    _navigated = true;

    final destination = await _destinationFuture;
    if (!mounted) return;

    debugPrint('[Nav] Splash -> ${destination.routeName}');

    if (destination.routeName == AppRoutes.welcome) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          settings: const RouteSettings(name: AppRoutes.welcome),
          transitionDuration: const Duration(milliseconds: 550),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const WelcomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        ),
      );
      return;
    }

    NavigationService.pushNamedAndRemoveUntil(
      destination.routeName,
      arguments: destination.arguments,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logoWidth = math.min(
      MediaQuery.sizeOf(context).width * _logoWidthFraction,
      _logoMaxWidth,
    );
    final unit = logoWidth / _totalUnits;

    // The mark starts alone in the middle of the screen, then glides left to
    // its place in the full logo (the row's layout never changes).
    final markStartShift = (_totalUnits / 2 - _markUnits / 2) * unit;

    // Static SVGs are built once and passed as `child`.
    final mark = SizedBox(
      width: _markUnits * unit,
      height: _markUnits * unit,
      child: AnimatedBuilder(
        animation: _controller,
        child: SvgPicture.asset(AppAssets.splashMark),
        builder: (context, child) => Transform.translate(
          offset: Offset(markStartShift * (1 - _slide.value), 0),
          child: Transform.rotate(angle: _rotation.value, child: child),
        ),
      ),
    );

    final wordmark = SizedBox(
      width: _wordmarkWidthUnits * unit,
      height: _wordmarkHeightUnits * unit,
      child: AnimatedBuilder(
        animation: _wordmark,
        child: SvgPicture.asset(AppAssets.splashWordmark),
        builder: (context, child) => Opacity(
          opacity: _wordmark.value,
          child: Transform.translate(
            offset: Offset(
              -_wordmarkSlideUnits * unit * (1 - _wordmark.value),
              0,
            ),
            child: child,
          ),
        ),
      ),
    );

    final logo = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        mark,
        SizedBox(width: _gapUnits * unit),
        wordmark,
      ],
    );

    final animatedLogo = Center(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          child: logo,
          builder: (context, child) => Opacity(
            opacity: _fade.value,
            child: Transform.scale(scale: _scale.value, child: child),
          ),
        ),
      ),
    );

    // Only the background colour rebuilds with the controller; the logo
    // subtree above is passed through as a stable child.
    return AnimatedBuilder(
      animation: _background,
      child: animatedLogo,
      builder: (context, child) {
        final background = _background.value ?? AppColors.white;
        final darkBackground = background.computeLuminance() < 0.5;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: darkBackground
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: Scaffold(backgroundColor: background, body: child),
        );
      },
    );
  }
}
