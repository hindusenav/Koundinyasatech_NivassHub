import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';

/// White rounded card with the soft blue-grey shadow used across the Figma
/// screens (surface + border in dark mode).
class FigmaCard extends StatelessWidget {
  const FigmaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.cardBorder),
        boxShadow: [
          BoxShadow(
            color: t.shadow,
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Small orange-barred section label ("PERSONAL DETAILS") used on cards.
class FigmaSectionLabel extends StatelessWidget {
  const FigmaSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    return Row(
      children: [
        Container(width: 3, height: 12, color: FigmaColors.orange),
        const SizedBox(width: 6),
        Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: t.heading,
          ),
        ),
      ],
    );
  }
}

/// Full-width CTA: orange by default ("Send OTP", "Verify OTP"), navy for
/// the bottom "Continue" / "Submit" buttons.
class FigmaButton extends StatelessWidget {
  const FigmaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.navy = false,
    this.showArrow = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool navy;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    // Orange for the in-card actions ("Send OTP", "Verify OTP", "Confirm
    // City"); navy for the bottom "Continue" / "Submit" buttons.
    final color = navy ? FigmaColors.of(context).cta : FigmaColors.orange;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: color.withValues(alpha: 0.45),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showArrow) const SizedBox(width: 26),
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (showArrow) const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
      ),
    );
  }
}

/// Round navy badge with an icon, shown above the entry/OTP titles.
class FigmaBadge extends StatelessWidget {
  const FigmaBadge({
    super.key,
    this.icon = Icons.shield_outlined,
    this.size = 56,
    this.light = false,
  });

  final IconData icon;
  final double size;

  /// White disc with a navy glyph (KYC document step) instead of navy/white.
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: light
            ? FigmaColors.of(context).card
            : FigmaColors.of(context).header,
        boxShadow: [
          BoxShadow(
            color: FigmaColors.of(context).shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: light ? FigmaColors.of(context).heading : Colors.white,
        size: size * 0.45,
      ),
    );
  }
}

/// Centred title + subtitle block used under the badge.
class FigmaTitleBlock extends StatelessWidget {
  const FigmaTitleBlock({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: t.heading,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, height: 1.4, color: t.body),
          ),
        ],
      ],
    );
  }
}

/// "Onboarding Progress ... Step 1 of 3" label row with an orange bar.
class FigmaProgressStrip extends StatelessWidget {
  const FigmaProgressStrip({
    super.key,
    required this.label,
    required this.current,
    required this.total,
  });

  final String label;
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: t.heading,
              ),
            ),
            Text(
              'Step $current of $total',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: t.heading,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: total == 0 ? 0 : current / total,
            minHeight: 5,
            backgroundColor: t.fieldBorder,
            valueColor: const AlwaysStoppedAnimation(FigmaColors.orange),
          ),
        ),
      ],
    );
  }
}
