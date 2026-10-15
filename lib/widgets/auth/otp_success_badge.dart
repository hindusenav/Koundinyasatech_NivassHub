import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';

/// Large success checkmark badge widget surrounded by concentric green pulse rings
/// and decorative sparkles, used on Screen 3 (OTP Verification Success).
class OtpSuccessBadge extends StatelessWidget {
  const OtpSuccessBadge({super.key, this.size = 140});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 40,
      height: size + 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer subtle green glow ring
          Container(
            width: size + 36,
            height: size + 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AuthColors.successGreen.withValues(alpha: 0.08),
              border: Border.all(
                color: AuthColors.successGreen.withValues(alpha: 0.18),
                width: 1.5,
              ),
            ),
          ),
          // Inner dashed/thin ring
          Container(
            width: size + 16,
            height: size + 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AuthColors.successGreen.withValues(alpha: 0.12),
              border: Border.all(
                color: AuthColors.successGreen.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
          ),
          // Solid green center circle badge
          Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AuthColors.successGreen,
              boxShadow: [
                BoxShadow(
                  color: Color(0x332EBA60),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.check_rounded,
                size: 72,
                color: Colors.white,
              ),
            ),
          ),
          // Decorative sparkles around the badge
          Positioned(
            top: 12,
            left: 18,
            child: Icon(
              Icons.star_rounded,
              size: 14,
              color: AuthColors.successGreen.withValues(alpha: 0.8),
            ),
          ),
          Positioned(
            top: 18,
            right: 14,
            child: Icon(
              Icons.star_rounded,
              size: 16,
              color: AuthColors.successGreen.withValues(alpha: 0.8),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 14,
            child: Icon(
              Icons.star_rounded,
              size: 16,
              color: AuthColors.successGreen.withValues(alpha: 0.8),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 20,
            child: Icon(
              Icons.star_rounded,
              size: 14,
              color: AuthColors.successGreen.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
