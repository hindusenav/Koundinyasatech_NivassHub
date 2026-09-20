import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/app_search_bar.dart';
import 'package:flutter_nivasshub/widgets/shared/loaders/loader.dart';
import 'package:flutter_nivasshub/widgets/shared/states/custom_error_widget.dart';
import 'package:flutter_nivasshub/widgets/shared/states/empty_state.dart';

/// Generic, searchable picker presented as a modal bottom sheet.
///
/// The app has no dropdown widget and uses modal sheets for selection
/// everywhere, so this is the reusable form of that pattern rather than a
/// `DropdownButton`. It is deliberately not KYC-specific: the seven
/// cascade levels, the role picker, the sub-branch picker and the
/// country-code picker all use it.
///
/// Styling comes from `AppTheme.bottomSheetTheme` (rounded top + drag
/// handle) and the shared `Loader` / `EmptyState` / `CustomErrorWidget`,
/// so this widget adds no chrome of its own. Follows
/// `ActivityTypeFilterSheet`'s existing `static show(...)` idiom.
class SelectionBottomSheet<T> extends StatefulWidget {
  const SelectionBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.labelOf,
    this.subtitleOf,
    this.leadingOf,
    this.selected,
    this.searchHint = 'Search',
    this.showSearch = true,
    this.emptyTitle = 'Nothing to choose from',
    this.emptyMessage,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  final String title;
  final List<T> items;
  final String Function(T item) labelOf;
  final String? Function(T item)? subtitleOf;
  final Widget? Function(T item)? leadingOf;
  final T? selected;
  final String searchHint;

  /// Hidden for short lists — searching five options is noise.
  final bool showSearch;

  final String emptyTitle;
  final String? emptyMessage;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  /// Opens the sheet and resolves to the chosen item, or `null` if the
  /// user dismissed it without choosing.
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required List<T> items,
    required String Function(T item) labelOf,
    String? Function(T item)? subtitleOf,
    Widget? Function(T item)? leadingOf,
    T? selected,
    String searchHint = 'Search',
    bool showSearch = true,
    String emptyTitle = 'Nothing to choose from',
    String? emptyMessage,
    bool isLoading = false,
    String? errorMessage,
    VoidCallback? onRetry,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SelectionBottomSheet<T>(
        title: title,
        items: items,
        labelOf: labelOf,
        subtitleOf: subtitleOf,
        leadingOf: leadingOf,
        selected: selected,
        searchHint: searchHint,
        showSearch: showSearch,
        emptyTitle: emptyTitle,
        emptyMessage: emptyMessage,
        isLoading: isLoading,
        errorMessage: errorMessage,
        onRetry: onRetry,
      ),
    );
  }

  @override
  State<SelectionBottomSheet<T>> createState() =>
      _SelectionBottomSheetState<T>();
}

class _SelectionBottomSheetState<T> extends State<SelectionBottomSheet<T>> {
  String _query = '';

  List<T> get _filtered {
    if (_query.isEmpty) return widget.items;
    final query = _query.toLowerCase();
    return widget.items
        .where(
          (item) =>
              widget.labelOf(item).toLowerCase().contains(query) ||
              (widget.subtitleOf?.call(item) ?? '').toLowerCase().contains(
                query,
              ),
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    // Capped so a long list never pushes the handle off-screen, and short
    // lists still size to their content.
    final maxHeight = MediaQuery.of(context).size.height * 0.75;

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: AppSpacing.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Text(
                widget.title,
                style: AppTextStyles.titleMedium.copyWith(color: textPrimary),
              ),
            ),
            if (widget.showSearch && widget.items.length > 6)
              Padding(
                padding: AppSpacing.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                child: AppSearchBar(
                  hint: widget.searchHint,
                  onChanged: (value) => setState(() => _query = value),
                ),
              ),
            AppSpacing.gapSm,
            Flexible(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (widget.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Loader(),
      );
    }

    if (widget.errorMessage != null) {
      return Padding(
        padding: AppSpacing.vertical(AppSpacing.lg),
        child: CustomErrorWidget(
          message: widget.errorMessage!,
          onRetry: widget.onRetry == null
              ? null
              : () {
                  Navigator.of(context).pop();
                  widget.onRetry!();
                },
        ),
      );
    }

    final items = _filtered;
    if (items.isEmpty) {
      return Padding(
        padding: AppSpacing.vertical(AppSpacing.lg),
        child: EmptyState(
          // A search that matched nothing is a different situation from a
          // level that genuinely has no options.
          title: _query.isEmpty ? widget.emptyTitle : 'No matches',
          message: _query.isEmpty ? widget.emptyMessage : null,
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: AppSpacing.vertical(AppSpacing.xs),
      itemCount: items.length,
      separatorBuilder: (_, _) => const Divider(height: 1, indent: 16),
      itemBuilder: (context, index) => _buildRow(context, items[index]),
    );
  }

  Widget _buildRow(BuildContext context, T item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    final subtitle = widget.subtitleOf?.call(item);
    final isSelected = widget.selected == item;

    return ListTile(
      leading: widget.leadingOf?.call(item),
      title: Text(
        widget.labelOf(item),
        style: AppTextStyles.bodyLarge.copyWith(
          color: textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      subtitle: subtitle == null || subtitle.isEmpty
          ? null
          : Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
            ),
      trailing: isSelected
          ? const Icon(
              AppIcons.check,
              size: AppDimensions.iconSm,
              color: AppColors.primary,
            )
          : null,
      onTap: () => Navigator.of(context).pop(item),
    );
  }
}
