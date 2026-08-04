import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/asset_constants.dart';

/// Brand logo, placed directly on the background. Layers a subtle continuous
/// float loop on top of the parent's one-shot [entrance] scale/fade-in (0..1,
/// driven by the screen's shared entrance controller).
class OnboardingLogoCard extends StatefulWidget {
  const OnboardingLogoCard({super.key, required this.entrance, this.size = 140});

  final double entrance;
  final double size;

  @override
  State<OnboardingLogoCard> createState() => _OnboardingLogoCardState();
}

class _OnboardingLogoCardState extends State<OnboardingLogoCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, _) {
        final entrance = widget.entrance.clamp(0.0, 1.0);
        final bobY = math.sin(_floatController.value * 2 * math.pi) * 3;

        return Opacity(
          opacity: entrance,
          child: Transform.translate(
            offset: Offset(0, bobY),
            child: Transform.scale(
              scale: 0.8 + entrance * 0.2,
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: Center(
                  child: SizedBox(
                    width: 105,
                    child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
