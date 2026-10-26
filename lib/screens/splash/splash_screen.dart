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
  // Flow (2800ms): the logo card fades/scales in on the bronze gradient,
  // the title follows, then the app navigates to the resolved destination.
  static const Duration _duration = Duration(milliseconds: 2800);
  static const Interval _logoInterval = Interval(
    0.0,
    0.45,
    curve: Curves.easeOutBack,
  );
  static const Interval _titleInterval = Interval(
    0.25,
    0.7,
    curve: Curves.easeOut,
  );
  static const double _logoCardSize = 112;
  static const double _logoCardRadius = 24;
  static const String _appTitle = 'NivassHub';
  static const String _appSubtitle = 'Your gated community, simplified';

  late final AnimationController _controller;
  late final Animation<double> _logo;
  late final Animation<double> _title;
  late final Future<AuthStartDestination> _destinationFuture;

  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _duration);
    _logo = CurvedAnimation(parent: _controller, curve: _logoInterval);
    _title = CurvedAnimation(parent: _controller, curve: _titleInterval);

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
      await _warm(AppAssets.splashMark);
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

    // First-time unauthenticated users: once the splash animation completes
    // (this runs only once, guarded by `_navigated`), open the first
    // onboarding screen automatically. Replacing the splash keeps it out of
    // the back stack so the user can't return to it.
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(gradient: AppColors.headerGradient),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logo.drive(Tween<double>(begin: 0.8, end: 1.0)),
                  child: FadeTransition(
                    opacity: _logo,
                    child: Container(
                      width: _logoCardSize,
                      height: _logoCardSize,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(_logoCardRadius),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.overlay,
                            blurRadius: 24,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(AppAssets.splashMark),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeTransition(
                  opacity: _title,
                  child: const Text(
                    _appTitle,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                FadeTransition(
                  opacity: _title,
                  child: Text(
                    _appSubtitle,
                    style: TextStyle(
                      color: AppColors.cardBorder.withValues(alpha: 0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _title,
                  child: const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryOrange,
                      ),
                      backgroundColor: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
