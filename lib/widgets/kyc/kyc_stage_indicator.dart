import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/models/kyc/kyc_status.dart';

/// Submitted → Under Review → Admin Review → Processing (spec §12).
///
/// A terminal verdict lights every step, because review is then finished
/// whichever way it went; the verdict itself is rendered separately by
/// `KycVerdictPanel` rather than being squeezed in as a fifth step.
class KycStageIndicator extends StatelessWidget {
  const KycStageIndicator({
    super.key,
    required this.stage,
    this.isComplete = false,
  });

  final KycReviewStage stage;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    final stages = KycReviewStage.values;
    final activeIndex = isComplete ? stages.length - 1 : stage.index;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (var i = 0; i < stages.length; i++) ...[
              _Dot(
                isDone: isComplete || i < activeIndex,
                isCurrent: !isComplete && i == activeIndex,
              ),
              if (i < stages.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    color: (isComplete || i < activeIndex)
                        ? AppColors.primary
                        : AppColors.grey300,
                  ),
                ),
            ],
          ],
        ),
        AppSpacing.gapSm,
        Row(
          children: [
            for (var i = 0; i < stages.length; i++)
              Expanded(
                child: Text(
                  stages[i].label,
                  textAlign: i == 0
                      ? TextAlign.start
                      : i == stages.length - 1
                      ? TextAlign.end
                      : TextAlign.center,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: (isComplete || i <= activeIndex)
                        ? AppColors.primary
                        : AppColors.grey500,
                    fontWeight: (!isComplete && i == activeIndex)
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.isDone, required this.isCurrent});

  final bool isDone;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final isActive = isDone || isCurrent;

    return Container(
      width: AppDimensions.iconSm,
      height: AppDimensions.iconSm,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDone ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.grey300,
          width: 2,
        ),
      ),
      child: isDone
          ? const Icon(AppIcons.check, size: 12, color: AppColors.white)
          : null,
    );
  }
}
