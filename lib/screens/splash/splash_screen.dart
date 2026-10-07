import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';
import 'package:flutter_nivasshub/screens/welcome/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const String _iconAsset = 'assets/images/nivaashub_logo_mark.png';
  static const String _fullLogoAsset = 'assets/images/nivaashub_logo.png';

  bool _showIcon = false;
  bool _showFullLogo = false;

  Timer? _iconTimer;
  Timer? _logoTimer;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();

    // 0.0s - 1.0s: background only.
    // 1.0s - 2.0s: icon fades in and scales 0.5 -> 1.0.
    _iconTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) setState(() => _showIcon = true);
    });

    // 2.0s - 3.5s: full logo replaces the icon and stays static.
    _logoTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showFullLogo = true);
    });

    // At 3.5s, hand off to the auth/KYC state machine.
    _navTimer = Timer(const Duration(milliseconds: 3500), _navigate);
  }

  Future<void> _navigate() async {
    final destination =
        await context.read<AuthStateProvider>().resolveStartDestination();
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
              opacity:
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
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
    _iconTimer?.cancel();
    _logoTimer?.cancel();
    _navTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              opacity: _showIcon && !_showFullLogo ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              child: AnimatedScale(
                scale: _showIcon ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                child: Image.asset(_iconAsset, width: 96, height: 96),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              opacity: _showFullLogo ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              child: Image.asset(_fullLogoAsset, width: 240),
            ),
          ),
        ],
      ),
    );
  }
}
