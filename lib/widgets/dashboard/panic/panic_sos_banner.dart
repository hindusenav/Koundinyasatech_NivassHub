import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';

class PanicSosBanner extends StatefulWidget {
  const PanicSosBanner({super.key});

  @override
  State<PanicSosBanner> createState() => _PanicSosBannerState();
}

class _PanicSosBannerState extends State<PanicSosBanner> {
  Future<void> _handleTap() async {
    final provider = context.read<DashboardProvider>();

    try {
      await provider.triggerSos(
        latitude: 0.0,
        longitude: 0.0,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SOS alert triggered successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to trigger SOS: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _handleTap,
        child: Container(
          height: 72,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // Light mode: soft emergency tint (FDEDED) with a red hairline;
            // dark mode keeps the original alarm gradient.
            color: isDark ? null : AppColors.errorLight,
            border: isDark
                ? null
                : Border.all(color: AppColors.error.withValues(alpha: 0.25)),
            // This banner uses ~4 distinct reds for the gradient stops and
            // the two icon circles below. Each plays a different visual
            // role (gradient depth vs. action-icon circle vs. alert-icon
            // circle), so they're kept distinct rather than converged onto
            // one token. All of them — plus the white text/icons on top —
            // are a fixed "emergency alarm" surface, the same category as
            // an on-primary colored button: they already read clearly in
            // both themes and are intentionally left unchanged here. Only
            // the drop shadow (a depth cue, not a brand color) is branched
            // for dark mode below.
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromARGB(255, 238, 30, 26),
                      Color(0xFFFF3B30),
                    ],
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.redAccent.withValues(alpha: 0.35)
                    : const Color(0x0D000000),
                blurRadius: isDark ? 10 : 12,
                offset: Offset(0, isDark ? 4 : 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SizedBox(
                    width: 45,
                    height: 45,
                    child: Image.asset(
                      'assets/icons/arrow_icon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Slide for PANIC / SOS',
                      style: GoogleFonts.inter(
                        color: isDark ? Colors.white : AppColors.error,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Loud alarm & emergency alerts will be triggered',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: isDark ? Colors.white70 : const Color(0xFFB42318),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(249, 229, 36, 36),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      'assets/icons/panic_icon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}