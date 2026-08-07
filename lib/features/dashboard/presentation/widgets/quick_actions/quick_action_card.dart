import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
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

  bool get _isSponsored =>
      action.name.toLowerCase() == "book now";

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18), // 🔥 smoother
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              /// 🔥 BIGGER BOX
              Container(
                width: 70,  // 🔥 increased
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
                      color: Colors.black.withOpacity(.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                /// 🔥 BIGGER ICON
                child: Center(
                  child: Image.asset(
                    action.assetPath,
                    width: _isViewMore ? 26 : 30, // 🔥 increased
                    height: _isViewMore ? 26 : 30,
                    fit: BoxFit.contain,
                    color: _isViewMore ? Colors.white : null,
                    errorBuilder: (_, __, ___) {
                      return const Icon(
                        Icons.image_not_supported_outlined,
                        size: 28,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ),

              /// 🔥 AD BADGE (slightly improved)
              if (_isSponsored)
                Positioned(
                  top: -6,
                  left: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "AD",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8), // 🔥 better spacing

          /// TEXT
          SizedBox(
            width: 74, // 🔥 slightly wider
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