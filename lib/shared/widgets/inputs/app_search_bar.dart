import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';

/// A fully-rounded, filled-background search input for **instant, local**
/// filtering — deliberately not built on `SearchField` (which wraps a
/// `Debouncer` for API-call use cases; filtering a small in-memory list
/// should have no perceptible delay) and not built on `CustomTextField`
/// (whose decoration always follows the app's standard rounded-rect input
/// theme; this widget's pill shape/filled background is visually distinct by
/// design, matching a search-bar convention rather than a form-field one).
/// Reusable across any future module that needs the same local-filter bar.
class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    this.hint = 'Search',
    this.onChanged,
    this.controller,
    this.autofocus = false,
  });

  final String hint;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool autofocus;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  void _handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey900),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
        filled: true,
        fillColor: AppColors.grey100,
        prefixIcon: Icon(AppIcons.search, size: AppDimensions.iconSm, color: AppColors.grey500),
        suffixIcon: _hasText
            ? IconButton(
                icon: Icon(AppIcons.close, size: AppDimensions.iconSm, color: AppColors.grey500),
                onPressed: _handleClear,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: AppRadius.radiusFull,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusFull,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusFull,
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
