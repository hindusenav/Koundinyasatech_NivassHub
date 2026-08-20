import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/models/shared/app_feature_icons.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/primary_button.dart';
import 'package:flutter_nivasshub/widgets/shared/grids/category_grid.dart';
import 'package:flutter_nivasshub/widgets/shared/loaders/loader.dart';
import 'package:flutter_nivasshub/widgets/shared/states/custom_error_widget.dart';
import 'package:flutter_nivasshub/models/visitor/activity_type_filter_option.dart';
import 'package:flutter_nivasshub/providers/visitor/activity_type_filter_provider.dart';
import 'package:flutter_nivasshub/services/visitor/activity_type_filter_repository.dart';
import 'package:flutter_nivasshub/services/visitor/mock_activity_type_filter_service.dart';

/// The "Filter Activity by Type" modal bottom sheet opened from the
/// Activities screen's AppBar filter icon. Screen-scoped
/// `ChangeNotifierProvider` (same isolation pattern as `ActivitiesScreen`
/// itself) — entirely self-contained, no changes to `app.dart`/`main.dart`
/// needed. Doesn't filter anything itself; it only collects a selection and
/// hands the chosen IDs back to whoever opened it via [show]'s return value,
/// leaving the parent screen free to apply that selection however it likes.
class ActivityTypeFilterSheet extends StatelessWidget {
  const ActivityTypeFilterSheet({super.key, this.initialSelectedIds = const {}});

  final Set<String> initialSelectedIds;

  /// Opens the sheet and resolves to the selected filter IDs once
  /// "Apply Filter" is tapped, or `null` if the sheet is dismissed (close
  /// button or swipe-down) without applying.
  static Future<List<String>?> show(
    BuildContext context, {
    Set<String> initialSelectedIds = const {},
  }) {
    return showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ActivityTypeFilterSheet(initialSelectedIds: initialSelectedIds),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ActivityTypeFilterProvider(
        ActivityTypeFilterRepository(MockActivityTypeFilterService()),
        initialSelectedIds: initialSelectedIds,
      )..loadOptions(),
      child: const _ActivityTypeFilterSheetView(),
    );
  }
}

class _ActivityTypeFilterSheetView extends StatelessWidget {
  const _ActivityTypeFilterSheetView();

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityTypeFilterProvider>(
      builder: (context, provider, _) {
        return Padding(
          // Keeps the sheet above the keyboard/system nav bar and clear of
          // the drag handle the theme's `bottomSheetTheme` already draws.
          padding: EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                AppSpacing.gapMd,
                _buildBody(context, provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Filter Activity by Type',
            style: AppTextStyles.titleMedium.copyWith(color: context.colorScheme.onSurface),
          ),
        ),
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: AppRadius.radiusFull,
          child: CircleAvatar(
            radius: AppDimensions.iconMd,
            backgroundColor: AppColors.grey100,
            child: Icon(AppIcons.close, size: AppDimensions.iconSm, color: AppColors.grey600),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, ActivityTypeFilterProvider provider) {
    if (provider.isLoading) {
      return const SizedBox(height: 200, child: Loader());
    }
    if (provider.hasError) {
      return SizedBox(
        height: 200,
        child: CustomErrorWidget(
          message: provider.errorMessage ?? 'Something went wrong. Please try again.',
          onRetry: provider.retry,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryGrid<ActivityTypeFilterOption>(
          items: provider.options,
          columns: 2,
          childAspectRatio: 1.35,
          itemBuilder: (option) => _FilterOptionCard(
            option: option,
            selected: provider.isSelected(option.id),
            onTap: () => provider.toggle(option.id),
          ),
        ),
        AppSpacing.gapMd,
        Row(
          children: [
            Text(
              '${provider.selectedCount} filters active',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
            ),
            const Spacer(),
            TextButton(
              onPressed: provider.selectedCount == 0 ? null : provider.clearAll,
              child: const Text('Clear All'),
            ),
          ],
        ),
        AppSpacing.gapSm,
        PrimaryButton(
          label: 'Apply Filter',
          onPressed: () => Navigator.of(context).pop(provider.selectedIds.toList()),
        ),
      ],
    );
  }
}

/// One selectable card in the filter grid — icon badge + label, with the
/// light-blue fill/border + small top-right dot the Figma uses to mark a
/// selected option.
class _FilterOptionCard extends StatelessWidget {
  const _FilterOptionCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final ActivityTypeFilterOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.radiusMd,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: AppSpacing.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? AppColors.infoLight : surfaceColor,
          borderRadius: AppRadius.radiusMd,
          border: Border.all(color: selected ? AppColors.info : borderColor),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: AppDimensions.iconLg / 2,
                  backgroundColor: selected ? AppColors.info : AppColors.grey100,
                  child: Icon(
                    AppFeatureIcons.icon(option.iconKey),
                    size: AppDimensions.iconMd,
                    color: selected ? AppColors.white : AppColors.grey600,
                  ),
                ),
                AppSpacing.gapSm,
                Text(
                  option.label,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: selected ? AppColors.info : context.colorScheme.onSurface,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (selected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.info, shape: BoxShape.circle),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
