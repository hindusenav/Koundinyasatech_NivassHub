import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/custom_button.dart';

/// The app's primary call-to-action button — filled, theme primary color.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.size = CustomButtonSize.medium,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final CustomButtonSize size;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
      variant: CustomButtonVariant.filled,
    );
  }
}
