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
    required String subRegion,
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
          top: Radius.circular(32),
        ),
        boxShadow: isDark
            ? null
            : const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.15),
                  offset: Offset(-4, -4),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
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

            // SheetTitle: DM Sans 700 Bold 18px #10213D
            Text(
              'Select City',
              style: TextStyle(
                fontFamily: 'DM Sans',
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF10213D),
                fontWeight: FontWeight.w700,
                fontSize: 18,
                height: 1.0,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 6),

            // SheetSubtitle: DM Sans 400 Regular 13px #3E3E3E
            Text(
              'Confirm the selected region to continue',
              style: TextStyle(
                fontFamily: 'DM Sans',
                color: isDark ? AppColors.grey400 : const Color(0xFF3E3E3E),
                fontWeight: FontWeight.w400,
                fontSize: 13,
                height: 1.0,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 24),

            // SelectedCityBox: Radius 16px, Border 1px #3E3E3E, Padding 16px, Gap 12px
            Container(
              decoration: BoxDecoration(
                color: sheetBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : const Color(0xFF3E3E3E),
                  width: 1.0,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // LabelRow: MainAxisAlignment.spaceBetween, CityDetails gap 12px
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Location Pin Icon in icon-container (38x38px, radius 10px, padding 10px)
                      Container(
                        width: 38,
                        height: 38,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E3547)
                              : const Color(0xFFE8F4FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: Color(0xFF006FC9),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // City & State details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.cityName,
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF000000),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                height: 1.0,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${widget.stateName}, ${widget.countryName}',
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                color: isDark ? AppColors.grey400 : const Color(0xFF3E3E3E),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1.0,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Blue Checkmark Icon
                      const Icon(
                        Icons.check,
                        color: Color(0xFF006FC9),
                        size: 20,
                      ),
                    ],
                  ),
                  // Inner Divider line
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark ? AppColors.grey800 : const Color(0xFF9AA7B5),
                    ),
                  ),

                  // SubOptionRow: Flow Horizontal, Justify space-between
                  InkWell(
                    onTap: () {
                      // Sub-region selection callback if needed
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _selectedSubRegion,
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : const Color(0xFF10213D),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: isDark ? AppColors.grey400 : const Color(0xFF10213D),
                          size: 16,
                        ),
                      ],
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
