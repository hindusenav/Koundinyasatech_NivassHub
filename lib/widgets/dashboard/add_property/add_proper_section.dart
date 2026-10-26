import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';

class AddPropertySection extends StatelessWidget {
  const AddPropertySection({super.key, required this.isExpanded});

  final bool isExpanded;

  // ============================================================
  // COLORS
  // ============================================================

  static const Color _panelLight = Colors.white;
  static const Color _textColor = AppColors.textPrimaryLight;
  static const Color _divider = AppColors.borderLight;
  static const Color _accent = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // HIDE SECTION WHEN DROPDOWN IS CLOSED
    // ============================================================

    if (!isExpanded) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final panelColor = isDark ? AppColors.surfaceDark : _panelLight;
    final textColor = isDark ? Colors.white : _textColor;

    final screenWidth = MediaQuery.sizeOf(context).width;

    // ============================================================
    // RESPONSIVE VALUES
    // ============================================================

    final horizontalPadding = screenWidth < 360
        ? 14.0
        : screenWidth < 600
        ? 16.0
        : 22.0;

    final titleFontSize = screenWidth < 360 ? 14.0 : 15.0;

    final addTextFontSize = screenWidth < 360 ? 14.0 : 15.0;

    final addCircleSize = screenWidth < 360 ? 38.0 : 40.0;

    return Container(
      width: double.infinity,
      color: panelColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          8,
          horizontalPadding,
          10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================================================
            // PROPERTY NAME
            // ======================================================
            Text(
              'B - 402 Golden Residency',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
                color: textColor,
                height: 1.2,
              ),
            ),

            // ======================================================
            // ORANGE DIVIDER
            // ======================================================
            const SizedBox(height: 9),

            Container(
              width: double.infinity,
              height: 1,
              color: isDark ? AppColors.borderDark : _divider,
            ),

            // ======================================================
            // ADD PROPERTY ROW
            // ======================================================
            const SizedBox(height: 10),

            SizedBox(
              height: 42,
              child: InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.addProperty),
                borderRadius: BorderRadius.circular(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ==================================================
                    // PLUS CIRCLE
                    // ==================================================
                    Container(
                      width: addCircleSize,
                      height: addCircleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppColors.iconDark : _accent,
                          width: 1.2,
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: isDark ? AppColors.iconDark : _accent,
                        size: 28,
                      ),
                    ),

                    // ==================================================
                    // SPACE
                    // ==================================================
                    const SizedBox(width: 14),

                    // ==================================================
                    // ADD PROPERTY TEXT
                    // ==================================================
                    Expanded(
                      child: Text(
                        'Add Flat/Villa/Office',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: addTextFontSize,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
