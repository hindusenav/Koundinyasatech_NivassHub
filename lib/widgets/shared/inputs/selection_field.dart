import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';

/// A read-only form field that opens a picker when tapped — the visible
/// half of the `SelectionBottomSheet` pattern.
///
/// Built on [CustomTextField] rather than drawn from scratch so it picks
/// up `inputDecorationTheme` for free: a disabled downstream cascade level
/// looks exactly like any other disabled field, and [errorText] renders
/// through the same channel as every other error on the form.
class SelectionField extends StatefulWidget {
  const SelectionField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.hint,
    this.prefixIcon,
    this.isLoading = false,
    this.errorText,
    this.helperText,
  });

  final String label;

  /// The chosen item's display text; `null` renders [hint].
  final String? value;

  /// `null` disables the field — used while the parent level is unchosen.
  final VoidCallback? onTap;

  final String? hint;
  final IconData? prefixIcon;

  /// Swaps the chevron for a spinner while the options are being fetched.
  final bool isLoading;

  final String? errorText;
  final String? helperText;

  @override
  State<SelectionField> createState() => _SelectionFieldState();
}

class _SelectionFieldState extends State<SelectionField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value ?? '',
  );

  @override
  void didUpdateWidget(covariant SelectionField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The value is owned by the provider, not by this field, so it has to
    // be pushed back into the controller whenever a cascade reset or a
    // new selection changes it.
    final next = widget.value ?? '';
    if (_controller.text != next) _controller.text = next;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: _controller,
      label: widget.label,
      hint: widget.hint,
      helperText: widget.helperText,
      errorText: widget.errorText,
      prefixIcon: widget.prefixIcon,
      readOnly: true,
      enabled: widget.onTap != null,
      onTap: widget.isLoading ? null : widget.onTap,
      suffixIcon: widget.isLoading
          ? const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                width: AppDimensions.iconXs,
                height: AppDimensions.iconXs,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : const Icon(AppIcons.chevronDown, size: AppDimensions.iconSm),
    );
  }
}
