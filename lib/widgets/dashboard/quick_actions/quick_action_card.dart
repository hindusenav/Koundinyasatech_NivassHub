import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/models/dashboard/quick_action_model.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({super.key, required this.action, required this.onTap});

  final QuickActionModel action;
  final VoidCallback onTap;

  bool get _isViewMore => action.name.toLowerCase() == "view more";

  bool get _isBookNow => action.name.toLowerCase() == "book now";

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              // "View More" uses the Figma orange; the rest are soft tinted tiles.
              color: _isViewMore
                  ? FigmaColors.orange
                  : (isDark ? t.card : const Color(0xFFEAF1FF)),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isViewMore ? Colors.transparent : t.cardBorder,
              ),
            ),
            child: Center(
              child: Image.asset(
                action.assetPath,
                width: _isViewMore
                    ? 24
                    : _isBookNow
                    ? 36
                    : 28,
                height: _isViewMore
                    ? 24
                    : _isBookNow
                    ? 36
                    : 28,
                fit: BoxFit.contain,
                color: _isViewMore ? Colors.white : null,
                filterQuality: FilterQuality.high,
                isAntiAlias: true,
                errorBuilder: (_, _, _) {
                  return Icon(
                    Icons.image_not_supported_outlined,
                    size: 26,
                    color: Colors.grey.shade600,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 74,
            child: Text(
              action.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                height: 1.25,
                fontWeight: FontWeight.w600,
                color: t.heading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
