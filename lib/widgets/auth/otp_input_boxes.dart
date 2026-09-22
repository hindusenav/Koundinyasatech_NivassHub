import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';

/// A row of single-digit OTP boxes. Internally this is a single invisible
/// `TextField` capturing all keystrokes (numeric-only, capped at [length]) —
/// the visible boxes are pure display, each rendering one character of the
/// field's current text. This sidesteps the classic multi-`FocusNode`
/// auto-advance dance (and its focus-transfer race conditions) entirely:
/// typing naturally fills left-to-right, and backspace naturally removes
/// the last digit, both for free from the single underlying field.
class OtpInputBoxes extends StatefulWidget {
  const OtpInputBoxes({
    super.key,
    this.length = 4,
    required this.onCompleted,
    this.onChanged,
    this.enabled = true,
    this.autofocus = true,
  });

  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool autofocus;

  @override
  State<OtpInputBoxes> createState() => _OtpInputBoxesState();
}

class _OtpInputBoxesState extends State<OtpInputBoxes> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    widget.onChanged?.call(value);
    if (value.length == widget.length) {
      widget.onCompleted(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final boxBackground = isDark ? AppColors.surfaceDark : Colors.white;
    final border = isDark ? AuthColors.borderDarkMode : AuthColors.border;
    final primaryBlue = isDark
        ? AuthColors.primaryBlueDarkMode
        : AuthColors.primaryBlue;
    final disabledOpacity = widget.enabled ? 1.0 : 0.5;

    // Box/gap are a preferred size, scaled down together — never clipped
    // independently — whenever `length` boxes at that size wouldn't fit
    // the available width (narrow phones, a 6-digit code, etc.).
    return LayoutBuilder(
      builder: (context, constraints) {
        const preferredBoxSize = 52.0;
        const preferredGap = 12.0;
        final preferredWidth =
            widget.length * preferredBoxSize + (widget.length - 1) * preferredGap;
        final maxWidth = constraints.maxWidth;
        final scale = (maxWidth.isFinite && preferredWidth > maxWidth)
            ? maxWidth / preferredWidth
            : 1.0;
        final boxSize = preferredBoxSize * scale;
        final boxGap = preferredGap * scale;
        final totalWidth = widget.length * boxSize + (widget.length - 1) * boxGap;
        final fontSize = (boxSize * 0.4).clamp(14.0, 22.0);

        return GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          child: Opacity(
            opacity: disabledOpacity,
            child: SizedBox(
              width: totalWidth,
              height: boxSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: Listenable.merge([_controller, _focusNode]),
                    builder: (context, _) {
                      final text = _controller.text;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(widget.length, (index) {
                          final char = index < text.length ? text[index] : '';
                          final isNextToFill =
                              index == text.length && _focusNode.hasFocus;
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index == widget.length - 1 ? 0 : boxGap,
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: boxSize,
                              height: boxSize,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: boxBackground,
                                borderRadius: AppRadius.radiusMd,
                                border: Border.all(
                                  color: isNextToFill ? primaryBlue : border,
                                  width: isNextToFill ? 2 : 1,
                                ),
                                boxShadow: isNextToFill
                                    ? [
                                        BoxShadow(
                                          color: primaryBlue.withValues(alpha: 0.15),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                char,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                  Opacity(
                    opacity: 0,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      enabled: widget.enabled,
                      autofocus: widget.autofocus,
                      showCursor: false,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(widget.length),
                      ],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      onChanged: _handleChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
