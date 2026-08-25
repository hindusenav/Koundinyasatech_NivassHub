import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/models/dashboard/quick_action_model.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({super.key, required this.action, required this.onTap});

  final QuickActionModel action;
  final VoidCallback onTap;

  bool get _isViewMore => action.name.toLowerCase() == "view more";

  bool get _isBookNow => action.name.toLowerCase() == "book now";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  // Amber "View More" tile stays the same saturated color in
                  // both themes (white icon on top already works in both).
                  color: _isViewMore ? const Color(0xFFFF8A00) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _isViewMore
                        ? Colors.transparent
                        : const Color(0xffECECEC),
                    width: 1.5, // Thicker border for better quality
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? .3 : .06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    action.assetPath,
                    width: _isViewMore
                        ? 26
                        : _isBookNow
                        ? 42
                        : 30,
                    height: _isViewMore
                        ? 26
                        : _isBookNow
                        ? 42
                        : 30,
                    fit: BoxFit.contain,
                    color: _isViewMore ? Colors.white : null,
                    // Better image quality
                    filterQuality: FilterQuality.high,
                    isAntiAlias: true,
                    errorBuilder: (_, _, _) {
                      return Icon(
                        Icons.image_not_supported_outlined,
                        size: 28,
                        color: Colors.grey.shade600,
                        weight: 600, // Thicker fallback icon
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
                fontWeight: FontWeight.w600, // Thicker text
                color: Color(0xff1A1A1A), // Darker black
                letterSpacing: 0.2, // Better readability
              ),
            ),
          ),
        ],
      ),
    );
  }
}
