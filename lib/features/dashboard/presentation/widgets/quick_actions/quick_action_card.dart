import 'package:flutter/material.dart';

import '../../../data/models/quick_action_model.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    super.key,
    required this.action,
    required this.onTap,
  });

  final QuickActionModel action;
  final VoidCallback onTap;

  bool get _isViewMore =>
      action.name.toLowerCase() == "view more";

  bool get _isBookNow =>
      action.name.toLowerCase() == "book now";

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // ===========================================================
              // EXISTING BOX — NO CHANGES
              // ===========================================================

              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: _isViewMore
                      ? const Color(0xFFFF8A00)
                      : Colors.white,

                  borderRadius: BorderRadius.circular(18),

                  border: Border.all(
                    color: _isViewMore
                        ? Colors.transparent
                        : const Color(0xffECECEC),
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                // =========================================================
                // IMAGE — ONLY BOOK NOW SIZE CHANGED
                // =========================================================

                child: Center(
                  child: Image.asset(
                    action.assetPath,

                    // View More remains 26.
                    // Other icons remain 30.
                    // Book Now is increased to 42.
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

                    color: _isViewMore
                        ? Colors.white
                        : null,

                    errorBuilder: (_, _, _) {
                      return const Icon(
                        Icons.image_not_supported_outlined,
                        size: 28,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ),

              // ===========================================================
              // AD BADGE REMOVED
              // ===========================================================
            ],
          ),

          // =============================================================
          // EXISTING GAP — NO CHANGE
          // =============================================================

          const SizedBox(height: 8),

          // =============================================================
          // EXISTING TEXT — NO CHANGE
          // =============================================================

          SizedBox(
            width: 74,
            child: Text(
              action.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                height: 1.25,
                fontWeight: FontWeight.w500,
                color: Color(0xff303030),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
