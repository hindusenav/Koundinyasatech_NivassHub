import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/widgets/shared/glass/glass_widgets.dart';

class GenerateOtpBanner extends StatelessWidget {
  const GenerateOtpBanner({super.key});

  void _generate(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP / QR generation coming soon.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    return GlassCard(
      radius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/icons/qr_icon.png',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) =>
                    Icon(Icons.qr_code_2_rounded, size: 20, color: t.accent),
              ),
              const SizedBox(width: 8),
              Text(
                'Invite a guest',
                style: GoogleFonts.inter(
                  color: t.heading,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Generate an OTP or QR code for smooth gate entry.',
            style: GoogleFonts.inter(
              color: t.body,
              fontSize: 12,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 34,
            child: ElevatedButton.icon(
              onPressed: () => _generate(context),
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              iconAlignment: IconAlignment.end,
              label: Text(
                'Generate code',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(0, 34),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
