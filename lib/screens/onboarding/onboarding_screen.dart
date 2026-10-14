
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/services/country/country_service_base.dart';

import 'login_screen.dart';
import 'dummy_account_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const Color navy = Color(0xFF0E2543);
  static const Color orange = Color(0xFFFC7118);

  late final VideoPlayerController _videoController;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarContrastEnforced: false,
      ),
    );

    _videoController = VideoPlayerController.asset(
      'assets/videos/onboarding_screen5.mp4',
    );

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      await _videoController.initialize();
      await _videoController.setLooping(true);
      await _videoController.setVolume(0);
      await _videoController.play();

      if (!mounted) return;

      setState(() {
        _videoReady = true;
      });
    } catch (error, stackTrace) {
      debugPrint('Onboarding background video failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _openLogin() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (routeContext) {
          return Provider<CountryServiceBase>.value(
            value: context.read<CountryServiceBase>(),
            child: const LoginScreen(),
          );
        }
      ),
    );
  }

  void _openDummyAccount() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const DummyAccountScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
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
                  // Full-canvas navy background.
                  const ColoredBox(color: navy),

                  // Background video.
                  Positioned(
                    left: -1,
                    top: 340,
                    width: 442,
                    height: 616,
                    child: _videoReady
                        ? ClipRect(
                            child: Opacity(
                              opacity: 0.31,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  width: _videoController.value.size.width,
                                  height: _videoController.value.size.height,
                                  child: VideoPlayer(_videoController),
                                ),
                              ),
                            ),
                          )
                        : const ColoredBox(color: navy),
                  ),

                  // Blend the video into the navy background.
                  Positioned(
                    left: 0,
                    top: 340,
                    width: 440,
                    height: 616,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              navy,
                              const Color(0x000E2543),
                              const Color(0x000E2543),
                              navy,
                            ],
                            stops: const [0.0, 0.18, 0.78, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // NivaasHub logo.
                  Positioned(
                    left: 50,
                    top: 173,
                    width: 340,
                    height: 340,
                    child: Image.asset(
                      'assets/images/blackLogo.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  // Main heading.
                  const Positioned(
                    left: 32,
                    top: 404,
                    width: 376,
                    child: Text(
                      'One Community, One Platform',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF05234D),
                        fontFamily: 'DMSans',
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                  ),

                  // Description.
                  const Positioned(
                    left: 32,
                    top: 465,
                    width: 376,
                    child: Text(
                      'NivaasHub connects residents, manages visitors, '
                      'handles payments, and keeps your society running '
                      'smoothly — all in one place.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: navy,
                        fontFamily: 'DMSans',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                      ),
                    ),
                  ),

                  // Create Account button.
                  Positioned(
                    left: 29,
                    top: 583,
                    width: 382,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _openDummyAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        foregroundColor: const Color(0xFFF1F8FF),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Center(
                            child: Text(
                              'Create Account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              width: 28,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF1F8FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                size: 18,
                                color: orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Login button.
                  Positioned(
                    left: 29,
                    top: 657,
                    width: 382,
                    height: 55,
                    child: OutlinedButton(
                      onPressed: _openLogin,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: orange,
                        side: const BorderSide(
                          color: orange,
                          width: 1,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Center(
                            child: Text(
                              'Login',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Positioned(
                            right: 0,
                            child: Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: orange,
                            ),
                          ),
                        ],
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
