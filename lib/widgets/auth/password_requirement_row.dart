import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/models/auth/password_requirement.dart';

/// One row of the Update Password screen's live strength checklist — a
/// circle icon (filled/checked when satisfied, outlined when not) plus the
/// requirement's label. Purely presentational; [PasswordRequirementList]
/// owns the pass/fail computation.
class PasswordRequirementRow extends StatelessWidget {
  const PasswordRequirementRow({
    super.key,
    required this.requirement,
    required this.isSatisfied,
  });

  final PasswordRequirement requirement;
  final bool isSatisfied;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bodyText = isDark ? AuthColors.bodyTextDarkMode : AuthColors.bodyText;
    final border = isDark ? AuthColors.borderDarkMode : AuthColors.border;
    final success = isSatisfied ? Colors.green : bodyText;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        children: [
          Icon(
            isSatisfied ? AppIcons.checkCircle : Icons.circle_outlined,
            size: AppDimensions.iconXs,
            color: isSatisfied ? success : border,
          ),
          AppSpacing.gapWXs,
          Expanded(
            child: Text(
              requirement.label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSatisfied ? success : bodyText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
