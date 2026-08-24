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
    const boxSize = 56.0;
    const boxGap = 16.0;
    final totalWidth = widget.length * boxSize + (widget.length - 1) * boxGap;
    final boxBackground = isDark ? AppColors.surfaceDark : Colors.white;
    final border = isDark ? AuthColors.borderDarkMode : AuthColors.border;
    final primaryBlue = isDark
        ? AuthColors.primaryBlueDarkMode
        : AuthColors.primaryBlue;

    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
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
                    final isNextToFill = index == text.length && _focusNode.hasFocus;
                    return Padding(
                      padding: EdgeInsets.only(right: index == widget.length - 1 ? 0 : boxGap),
                      child: Container(
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
                        ),
                        child: Text(
                          char,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
    );
  }
}
