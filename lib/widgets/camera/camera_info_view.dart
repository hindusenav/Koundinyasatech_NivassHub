import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/widgets/camera/camera_widgets.dart';

/// One reassurance line on the permission screen.
class CameraInfoPoint {
  const CameraInfoPoint(this.icon, this.text);

  final IconData icon;
  final String text;
}

/// Full-screen, brand-themed explainer used by the camera for both the
/// "allow camera access" step and the "camera unavailable" state, so every
/// camera entry point in the app shows the same look.
class CameraInfoView extends StatelessWidget {
  const CameraInfoView({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.onPrimary,
    required this.secondaryLabel,
    required this.onSecondary,
    this.primaryIcon,
    this.points = const [],
  });

  final IconData icon;
  final String title;
  final String body;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final IconData? primaryIcon;
  final String secondaryLabel;
  final VoidCallback onSecondary;
  final List<CameraInfoPoint> points;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.splashBackgroundNavy, AppColors.darkCard],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _GlowIcon(icon: icon),
                        const SizedBox(height: 32),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: AppColors.textPrimaryDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          body,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.navInactive,
                            height: 1.5,
                          ),
                        ),
                        if (points.isNotEmpty) ...[
                          const SizedBox(height: 28),
                          for (final point in points) _PointRow(point: point),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              CameraActionButton(
                label: primaryLabel,
                icon: primaryIcon,
                primary: true,
                onPressed: onPrimary,
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: onSecondary,
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  foregroundColor: AppColors.navInactive,
                ),
                child: Text(secondaryLabel, style: AppTextStyles.labelLarge),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowIcon extends StatelessWidget {
  const _GlowIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 168,
      height: 168,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.32),
                  AppColors.primary.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          Container(
            width: 116,
            height: 116,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.35),
              ),
            ),
          ),
          Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryLight, AppColors.primary],
              ),
            ),
            child: Icon(icon, size: 40, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

class _PointRow extends StatelessWidget {
  const _PointRow({required this.point});

  final CameraInfoPoint point;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(point.icon, size: 18, color: AppColors.primaryLight),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              point.text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Icons used by the camera explainer screens.
class CameraIcons {
  CameraIcons._();

  static const IconData camera = AppIcons.camera;
  static const IconData unavailable = Icons.no_photography_outlined;
  static const IconData capture = Icons.document_scanner_outlined;
  static const IconData privacy = AppIcons.lock;
  static const IconData control = AppIcons.settings;
}
