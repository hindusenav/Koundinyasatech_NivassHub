import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';

/// "NIVASS" revealed letter by letter, with the gap between letters
/// growing naturally over [spacingProgress] rather than sitting at its
/// final spacing from the start.
class AnimatedWordmark extends StatelessWidget {
  const AnimatedWordmark({
    super.key,
    required this.progress,
    required this.spacingProgress,
  });

  /// Raw main-controller value (0..1) driving each letter's own pop-in.
  final double progress;

  /// 0..1 — grows the gap between letters from tight to final spacing.
  final double spacingProgress;

  static const _word = 'NIVASS';
  static const _start = 0.70;
  static const _stagger = 0.02;
  static const _span = 0.10;
  static const _finalGap = 6.0;

  @override
  Widget build(BuildContext context) {
    final gap = spacingProgress.clamp(0.0, 1.0) * _finalGap;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_word.length * 2 - 1, (index) {
        if (index.isOdd) return SizedBox(width: gap);
        final i = index ~/ 2;

        final begin = (_start + i * _stagger).clamp(0.0, 1.0);
        final end = (begin + _span).clamp(0.0, 1.0);
        final letterProgress = end > begin
            ? Interval(begin, end, curve: Curves.easeOutCubic).transform(progress)
            : 1.0;
        final clamped = letterProgress.clamp(0.0, 1.0);

        return Opacity(
          opacity: clamped,
          child: Transform.translate(
            offset: Offset(0, (1 - clamped) * 14),
            child: Text(
              _word[i],
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }),
    );
  }
}
