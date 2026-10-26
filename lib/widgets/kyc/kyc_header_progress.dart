import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';

/// "Onboarding Progress ... Step N of M" strip designed to sit inside the
/// bronze header (`FigmaHeaderScaffold.bottom`): white text, orange bar.
class KycHeaderProgress extends StatelessWidget {
  const KycHeaderProgress({
    super.key,
    required this.current,
    required this.total,
    this.label = 'Onboarding Progress',
  });

  final int current;
  final int total;
  final String label;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(label, style: style)),
            Text('Step $current of $total', style: style),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: total == 0 ? 0 : current / total,
            minHeight: 6,
            backgroundColor: AppColors.white.withValues(alpha: 0.25),
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryOrange),
          ),
        ),
      ],
    );
  }
}

/// Small translucent pill for the header subtitle ("Tenant · 3 documents
/// required").
class KycHeaderBadge extends StatelessWidget {
  const KycHeaderBadge({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
