import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/models/dashboard/quick_action_model.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({super.key, required this.action, required this.onTap});

  final QuickActionModel action;
  final VoidCallback onTap;

  static const double _tileSize = 52;
  static const double _tileRadius = 18;

  String get _key => action.name.toLowerCase();

  /// Material icon per known action; `null` falls back to the API's asset.
  IconData? get _icon => switch (_key) {
    'pre-approve' => Icons.person_add_alt_1_rounded,
    'payments' => Icons.account_balance_wallet_rounded,
    'pass' => Icons.badge_rounded,
    'security' => Icons.shield_rounded,
    'book now' => Icons.event_available_rounded,
    'buy/sell' => Icons.storefront_rounded,
    'free trial' => Icons.card_giftcard_rounded,
    'view more' => Icons.more_horiz_rounded,
    _ => null,
  };

  Color get _tint => switch (_key) {
    'pre-approve' => AppColors.iconPreApproveBg,
    'payments' => AppColors.iconPaymentsBg,
    'pass' => AppColors.iconPassBg,
    'security' => AppColors.iconSecurityBg,
    'book now' => AppColors.iconBookNowBg,
    'buy/sell' => AppColors.iconBuySellBg,
    'free trial' => AppColors.iconTrialBg,
    'view more' => AppColors.iconMoreBg,
    _ => AppColors.iconMoreBg,
  };

  @override
  Widget build(BuildContext context) {
    final icon = _icon;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(_tileRadius),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _tileSize,
            height: _tileSize,
            decoration: BoxDecoration(
              color: _tint,
              borderRadius: BorderRadius.circular(_tileRadius),
            ),
            child: Center(
              child: icon != null
                  ? Icon(icon, size: 26, color: AppColors.textDark)
                  : Image.asset(
                      action.assetPath,
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                      color: AppColors.textDark,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.apps_rounded,
                        size: 26,
                        color: AppColors.textMuted,
                      ),
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
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
