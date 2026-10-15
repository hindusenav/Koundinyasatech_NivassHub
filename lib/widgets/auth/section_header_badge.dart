import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';

/// Reusable section title with an orange vertical indicator bar,
/// matching the POPULAR COUNTRIES, ALL CITIES, PERSONAL DETAILS, etc. headers.
class SectionHeaderBadge extends StatelessWidget {
  const SectionHeaderBadge({
    super.key,
    required this.title,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  });

  final String title;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 3.5,
            height: 15,
            decoration: BoxDecoration(
              color: AuthColors.orangeButton,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AuthColors.blueNh,
            ),
          ),
        ],
      ),
    );
  }
}
