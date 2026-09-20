import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/selection_bottom_sheet.dart';

/// Tappable dial-code chip that sits left of a mobile field.
///
/// The existing [CountryCodeBadge] is fixed at `+91` and its own dartdoc
/// records that no picker is wired to it; rather than change a widget the
/// previous auth screens still use, this is a separate, selectable
/// version backed by the same country list as the property cascade.
class CountryCodeSelector extends StatelessWidget {
  const CountryCodeSelector({
    super.key,
    required this.countries,
    required this.selected,
    required this.onSelected,
    this.isLoading = false,
    this.enabled = true,
  });

  final List<LocationNode> countries;
  final LocationNode? selected;
  final ValueChanged<LocationNode> onSelected;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textDisabled = isDark
        ? AppColors.textDisabledDark
        : AppColors.textDisabledLight;

    final isInteractive = enabled && !isLoading && countries.isNotEmpty;

    return InkWell(
      onTap: isInteractive ? () => _openPicker(context) : null,
      borderRadius: AppRadius.radiusSm,
      child: Container(
        height: AppDimensions.inputHeight,
        padding: AppSpacing.horizontal(AppSpacing.sm),
        decoration: BoxDecoration(
          borderRadius: AppRadius.radiusSm,
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected?.flagEmoji != null) ...[
              Text(selected!.flagEmoji!, style: AppTextStyles.bodyLarge),
              AppSpacing.gapWXs,
            ],
            Text(
              selected?.dialCode ?? '—',
              style: AppTextStyles.bodyLarge.copyWith(
                color: isInteractive ? textPrimary : textDisabled,
                fontWeight: FontWeight.w500,
              ),
            ),
            AppSpacing.gapWXs,
            if (isLoading)
              const SizedBox(
                width: AppDimensions.iconXs,
                height: AppDimensions.iconXs,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(
                AppIcons.chevronDown,
                size: AppDimensions.iconXs,
                color: isInteractive ? textPrimary : textDisabled,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final choice = await SelectionBottomSheet.show<LocationNode>(
      context,
      title: KycStrings.countryCodeSheetTitle,
      items: countries,
      selected: selected,
      labelOf: (country) => country.name,
      subtitleOf: (country) => country.dialCode,
      leadingOf: (country) => country.flagEmoji == null
          ? null
          : Text(country.flagEmoji!, style: AppTextStyles.titleMedium),
    );
    if (choice != null) onSelected(choice);
  }
}
