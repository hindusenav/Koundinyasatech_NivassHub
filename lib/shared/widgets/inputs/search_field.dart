import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/utils/debouncer.dart';
import 'custom_text_field.dart';

/// A [CustomTextField] preset for search — debounces [onChanged] so a
/// filter/API call doesn't fire on every keystroke, and shows a clear
/// button once text is entered.
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    this.hint = 'Search',
    this.onChanged,
    this.onClear,
    this.controller,
    this.debounceDuration = AppConstants.debounceDuration,
  });

  final String hint;
  final void Function(String)? onChanged;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final Duration debounceDuration;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;
  late final Debouncer _debouncer;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _debouncer = Debouncer(duration: widget.debounceDuration);
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _debouncer.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: _controller,
      hint: widget.hint,
      prefixIcon: AppIcons.search,
      suffixIcon: _hasText
          ? IconButton(
              icon: Icon(AppIcons.close, size: AppDimensions.iconSm),
              onPressed: _handleClear,
            )
          : null,
      onChanged: (value) =>
          _debouncer.run(() => widget.onChanged?.call(value)),
    );
  }
}
