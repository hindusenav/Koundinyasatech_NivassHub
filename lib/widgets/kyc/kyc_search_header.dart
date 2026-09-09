import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';

/// Shared sky-blue header used across the KYC location-selection flow
/// (Select Country / Select State / Select City): back button + title on a
/// rounded-bottom container, followed by a search input box.
class KycSearchHeader extends StatelessWidget {
  final String title;
  final TextEditingController searchController;
  final String hintText;
  final VoidCallback? onBack;

  const KycSearchHeader({
    super.key,
    required this.title,
    required this.searchController,
    required this.hintText,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final headerBgColor = isDark
        ? AppColors.dashboardHeaderDark
        : const Color(0xFFC7E3FF);
    final cardBgColor = isDark ? AppColors.surfaceDark : AppColors.white;
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF1F2937);

    return Container(
      decoration: BoxDecoration(
        color: headerBgColor,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: SizedBox(
            height: 38,
            child: Row(
              children: [
                // Navigation back button (24x24px, Gap 12px)
                GestureDetector(
                  onTap: onBack ?? () => Navigator.of(context).pop(),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Greeting Container (Pill capsule: height 38px, radius 40px, border #CCDFF2)
                Expanded(
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: isDark
                            ? AppColors.borderDark
                            : const Color(0xFFCCDFF2),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 16, right: 12),
                    child: Center(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          height: 1.0,
                          letterSpacing: 0,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : const Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
