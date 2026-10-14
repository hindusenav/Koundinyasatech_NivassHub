import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
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
    this.onRetry,
  });

  final List<LocationNode> countries;
  final LocationNode? selected;
  final ValueChanged<LocationNode> onSelected;
  final bool isLoading;
  final bool enabled;

  /// Called instead of opening the (empty) picker when [countries] is
  /// empty and this is non-null — lets the chip recover from a failed
  /// load without the screen needing its own retry button.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.borderDark : AuthColors.inputBorder;
    final bgColor = isDark ? AppColors.surfaceDark : AuthColors.inputBackground;
    final textColor = isDark ? AppColors.textPrimaryDark : AuthColors.blueNh;

    final canRetry = enabled && !isLoading && countries.isEmpty && onRetry != null;
    final isInteractive = enabled && !isLoading && (countries.isNotEmpty || canRetry);

    return InkWell(
      onTap: isInteractive
          ? (canRetry ? onRetry : () => _openPicker(context))
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  selected?.dialCode ?? '+91',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    color: isInteractive ? textColor : textColor.withValues(alpha: 0.5),
                  ),
                ),
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
