import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/models/dashboard/quick_action_model.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({super.key, required this.action, required this.onTap});

  final QuickActionModel action;
  final VoidCallback onTap;

  bool get _isViewMore => action.name.toLowerCase() == "view more";

  bool get _isBookNow => action.name.toLowerCase() == "book now";

  Color get _tint => switch (action.name.toLowerCase()) {
    "pre-approve" => const Color(0xFFFFF0B8),
    "payments" => const Color(0xFFDCD9FF),
    "posts" => const Color(0xFFC9F5EE),
    "security" => const Color(0xFFFFC9C5),
    "book now" => const Color(0xFFE6D9FF),
    "directory" => const Color(0xFFCDEBFF),
    "free trial" => const Color(0xFFC9F5E0),
    _ => const Color(0xFFE3E8F5),
  };

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              // Every action shares the same champagne / dark-amber tile.
              color: _tint,
              shape: BoxShape.circle,
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
                // Line icons take the theme accent; the "Book Now" artwork is
                // a multi-colour illustration and keeps its own colours.
                color: _isBookNow ? null : const Color(0xFF3E2F1C),
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
              style: GoogleFonts.inter(
                fontSize: 12,
                height: 1.25,
                fontWeight: FontWeight.w500,
                color: t.heading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
