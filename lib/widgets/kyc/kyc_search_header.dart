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
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            children: [
              // Header Row: Back button & Title
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: textPrimary),
                      onPressed: onBack ?? () => Navigator.of(context).pop(),
                    ),
                  ),
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Input Box
              Container(
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  style: TextStyle(color: textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: isDark ? AppColors.grey400 : AppColors.grey500,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: isDark ? AppColors.grey400 : AppColors.grey500,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
