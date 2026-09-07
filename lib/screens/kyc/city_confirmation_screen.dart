import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';

class CityConfirmationScreen extends StatefulWidget {
  final String cityName;
  final String stateName;
  final String countryName;
  final String subRegion;
  final VoidCallback? onConfirm;

  const CityConfirmationScreen({
    super.key,
    this.cityName = 'Bangalore',
    this.stateName = 'Karnataka',
    this.countryName = 'India',
    this.subRegion = 'Bengaluru Urban',
    this.onConfirm,
  });

  /// Static helper to display this screen as a Modal Bottom Sheet
  static Future<T?> showModal<T>(
    BuildContext context, {
    required String cityName,
    required String stateName,
    required String countryName,
    String subRegion = 'Bengaluru Urban',
    VoidCallback? onConfirm,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CityConfirmationScreen(
        cityName: cityName,
        stateName: stateName,
        countryName: countryName,
        subRegion: subRegion,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<CityConfirmationScreen> createState() => _CityConfirmationScreenState();
}

class _CityConfirmationScreenState extends State<CityConfirmationScreen> {
  late String _selectedSubRegion;

  @override
  void initState() {
    super.initState();
    _selectedSubRegion = widget.subRegion;
  }

  void _handleConfirm() {
    if (widget.onConfirm != null) {
      widget.onConfirm!();
    } else {
      Navigator.of(context).pop({
        'city': widget.cityName,
        'state': widget.stateName,
        'country': widget.countryName,
        'subRegion': _selectedSubRegion,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final sheetBgColor = isDark ? AppColors.surfaceDark : AppColors.white;
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF1F2937);
    final textSecondary = isDark ? AppColors.grey400 : AppColors.grey600;
    final cardBorderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final subCardBorderColor = isDark ? AppColors.grey700 : const Color(0xFFD1D5DB);

    return Container(
      decoration: BoxDecoration(
        color: sheetBgColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Drag Handle Indicator
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.grey600 : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              'Select City',
              style: AppTextStyles.titleLarge.copyWith(
                color: textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),

            // Subtitle
            Text(
              'Confirm the selected region to continue',
              style: TextStyle(
                color: textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),

            // Selected City Card Container
            Container(
              decoration: BoxDecoration(
                color: sheetBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cardBorderColor, width: 1.5),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Top Row: Pin icon, City, State/Country, Checkmark
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Location Pin Icon in Circle
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E3547)
                              : const Color(0xFFEAF4FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_outlined,
                          size: 22,
                          color: Color(0xFF006FC9),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // City & State details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.cityName,
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${widget.stateName}, ${widget.countryName}',
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Blue Checkmark Icon
                      const Icon(
                        Icons.check,
                        color: Color(0xFF006FC9),
                        size: 22,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Sub-region selector field box
                  InkWell(
                    onTap: () {
                      // Sub-region selection callback if needed
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: subCardBorderColor, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedSubRegion,
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: isDark ? AppColors.grey400 : AppColors.grey600,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Confirm City Primary Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006FC9),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirm City',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
