import 'package:flutter/material.dart';
import 'custom_button.dart';

/// A secondary action button — outlined, theme primary color. Use for the
/// less prominent action alongside a [PrimaryButton] (e.g. "Cancel").
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
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
      variant: CustomButtonVariant.outlined,
    );
  }
}
