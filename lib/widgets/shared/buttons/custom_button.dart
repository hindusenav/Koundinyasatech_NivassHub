import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';

enum CustomButtonVariant { filled, outlined, text }

enum CustomButtonSize { small, medium, large }

/// Base button every other button in the app is built from. Prefer
/// [PrimaryButton]/[SecondaryButton] at call sites — reach for this directly
/// only when neither preset fits.
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = CustomButtonVariant.filled,
    this.size = CustomButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final CustomButtonVariant variant;
  final CustomButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;

  double get _height {
    switch (size) {
      case CustomButtonSize.small:
        return AppDimensions.buttonHeightSm;
      case CustomButtonSize.medium:
        return AppDimensions.buttonHeightMd;
      case CustomButtonSize.large:
        return AppDimensions.buttonHeightLg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final minimumSize = Size(isFullWidth ? double.infinity : 0, _height);

    final child = isLoading
        ? SizedBox(
            height: AppDimensions.iconSm,
            width: AppDimensions.iconSm,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                foregroundColor ??
                    (variant == CustomButtonVariant.filled
                        ? AppColors.white
                        : AppColors.primary),
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppDimensions.iconSm),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    switch (variant) {
      case CustomButtonVariant.filled:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            minimumSize: minimumSize,
          ),
          child: child,
        );
      case CustomButtonVariant.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor,
            minimumSize: minimumSize,
          ),
          child: child,
        );
      case CustomButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor,
            minimumSize: minimumSize,
          ),
          child: child,
        );
    }
  }
}
