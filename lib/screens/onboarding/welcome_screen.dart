
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'onboarding_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  static const Color backgroundColor = Color(0xFFF9FFFB);
  static const Color navy = Color(0xFF0E2543);

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
    );

    _navigationTimer = Timer(
      const Duration(seconds: 5),
      () {
        if (!mounted) return;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => _buildNextScreen(),
          ),
        );
      },
    );
  }

  // Uses the onboarding screen widget from your project.
  Widget _buildNextScreen() {
    return OnboardingScreen();
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBody: true,
      body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: 440,
            height: 956,
            child: ClipRect(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(
                    color: backgroundColor,
                  ),

                  Positioned(
                    left: -40,
                    right: -40,
                    top: 530,
                    bottom: -20,
                    child: Opacity(
                      opacity: 0.45,
                      child: Image.asset(
                        'assets/images/onboard_8_transparent.png',
                        fit: BoxFit.fill,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  Positioned(
                    left: 39,
                    top: 77,
                    width: 361,
                    height: 361,
                    child: Image.asset(
                      'assets/images/nivas_welcomelogo.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const Positioned(
                    left: 116,
                    top: 425,
                    width: 209,
                    height: 49,
                    child: Text(
                      'Welcome!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: navy,
                        fontFamily: 'DMSans',
                        fontSize: 42,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                      ),
                    ),
                  ),

                  const Positioned(
                    left: 72,
                    top: 482,
                    width: 295,
                    height: 49,
                    child: Text(
                      'To NivaasHub',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: navy,
                        fontFamily: 'DMSans',
                        fontSize: 38,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
