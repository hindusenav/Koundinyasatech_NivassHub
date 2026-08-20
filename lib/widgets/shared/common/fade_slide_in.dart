import 'package:flutter/material.dart';

/// Fades and slides [child] upward as [progress] goes from 0 to 1. Both new
/// screens stagger their entrance reveal across several of these, driven by
/// one shared [AnimationController]/[Interval] set per screen.
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    super.key,
    required this.progress,
    required this.child,
    this.distance = 16,
  });

  final double progress;
  final Widget child;
  final double distance;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    return Opacity(
      opacity: clamped,
      child: Transform.translate(
        offset: Offset(0, (1 - clamped) * distance),
        child: child,
      ),
    );
  }
}
