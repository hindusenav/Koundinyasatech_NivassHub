import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';

/// Frosted dark circular icon button used on top of the live preview.
class CameraGlassButton extends StatelessWidget {
  const CameraGlassButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.active = false,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool active;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: active
            ? AppColors.primary.withValues(alpha: 0.9)
            : AppColors.black.withValues(alpha: 0.38),
        shape: CircleBorder(
          side: BorderSide(color: AppColors.white.withValues(alpha: 0.18)),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed == null
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  onPressed!();
                },
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              icon,
              size: 22,
              color: AppColors.white.withValues(alpha: enabled ? 1 : 0.4),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shutter: brand-orange ring around a white disc that squeezes on press.
class CameraShutterButton extends StatefulWidget {
  const CameraShutterButton({
    super.key,
    required this.onPressed,
    this.busy = false,
  });

  final VoidCallback onPressed;
  final bool busy;

  @override
  State<CameraShutterButton> createState() => _CameraShutterButtonState();
}

class _CameraShutterButtonState extends State<CameraShutterButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Capture photo',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _down = true),
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) => setState(() => _down = false),
        onTap: widget.busy
            ? null
            : () {
                HapticFeedback.mediumImpact();
                widget.onPressed();
              },
        child: Container(
          width: 84,
          height: 84,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 24,
                spreadRadius: 1,
              ),
            ],
          ),
          child: AnimatedScale(
            scale: _down ? 0.86 : 1,
            duration: const Duration(milliseconds: 110),
            curve: Curves.easeOut,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: widget.busy
                  ? const Padding(
                      padding: EdgeInsets.all(22),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppColors.primary,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

/// Rounded pill with a hint line, shown over the preview.
class CameraHintPill extends StatelessWidget {
  const CameraHintPill({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.42),
        borderRadius: AppRadius.radiusFull,
        border: Border.all(color: AppColors.white.withValues(alpha: 0.14)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.labelMedium.copyWith(color: AppColors.white),
      ),
    );
  }
}

/// Primary (brand gradient) or secondary (glass outline) action used on the
/// dark camera surfaces.
class CameraActionButton extends StatelessWidget {
  const CameraActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.primary = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.5 : 1,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          height: 54,
          decoration: BoxDecoration(
            borderRadius: AppRadius.radiusXl,
            gradient: primary
                ? const LinearGradient(
                    colors: [AppColors.primaryLight, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: primary ? null : AppColors.white.withValues(alpha: 0.1),
            border: primary
                ? null
                : Border.all(color: AppColors.white.withValues(alpha: 0.28)),
            boxShadow: primary
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: InkWell(
            borderRadius: AppRadius.radiusXl,
            onTap: onPressed,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: AppColors.white),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Dims everything outside a centred document-shaped window and draws brand
/// corner brackets around it.
class CameraDocumentGuide extends StatelessWidget {
  const CameraDocumentGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: CustomPaint(painter: _DocumentGuidePainter(), size: Size.infinite),
    );
  }
}

class _DocumentGuidePainter extends CustomPainter {
  const _DocumentGuidePainter();

  static const double _radius = 18;
  static const double _arm = 28;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width * 0.86;
    final height = (width / 1.45).clamp(0.0, size.height * 0.6);
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.46),
        width: width,
        height: height,
      ),
      const Radius.circular(_radius),
    );

    final scrim = Path()
      ..addRect(Offset.zero & size)
      ..addRRect(rect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(
      scrim,
      Paint()..color = AppColors.black.withValues(alpha: 0.5),
    );

    canvas.drawRRect(
      rect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = AppColors.white.withValues(alpha: 0.25),
    );

    final l = rect.left, t = rect.top, r = rect.right, b = rect.bottom;
    const rad = Radius.circular(_radius);
    final path = Path()
      ..moveTo(l, t + _arm)
      ..lineTo(l, t + _radius)
      ..arcToPoint(Offset(l + _radius, t), radius: rad)
      ..lineTo(l + _arm, t)
      ..moveTo(r - _arm, t)
      ..lineTo(r - _radius, t)
      ..arcToPoint(Offset(r, t + _radius), radius: rad)
      ..lineTo(r, t + _arm)
      ..moveTo(r, b - _arm)
      ..lineTo(r, b - _radius)
      ..arcToPoint(Offset(r - _radius, b), radius: rad)
      ..lineTo(r - _arm, b)
      ..moveTo(l + _arm, b)
      ..lineTo(l + _radius, b)
      ..arcToPoint(Offset(l, b - _radius), radius: rad)
      ..lineTo(l, b - _arm);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..color = AppColors.primary,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
