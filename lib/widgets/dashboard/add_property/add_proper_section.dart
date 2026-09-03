import 'package:flutter/material.dart';

class AddPropertySection extends StatelessWidget {
  const AddPropertySection({
    super.key,
  });

  // ============================================================
  // COLORS
  // ============================================================

  static const Color _headerBlue = Color(0xFFC6E1FA);
  static const Color _textColor = Color(0xFF111111);
  static const Color _orange = Color(0xFFFF9800);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    // ==========================================================
    // RESPONSIVE VALUES
    // ==========================================================

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

      // Same blue as the header so there is no visible
      // background break between the header and property section.
      color: _headerBlue,

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
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
                color: _textColor,
                height: 1.2,
              ),
            ),

            // ======================================================
            // ORANGE DIVIDER
            // ====================================================== 

            const SizedBox(
              height: 9,
            ),

            Container(
              width: double.infinity,
              height: 1.2,
              color: _orange,
            ),

            // ======================================================
            // ADD PROPERTY ROW
            // ======================================================

            const SizedBox(
              height: 10,
            ),

            SizedBox(
              height: 42,
              child: InkWell(
                onTap: () {
                  // Add Flat / Villa / Office navigation here.
                },
                borderRadius: BorderRadius.circular(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ============================================
                    // PLUS CIRCLE
                    // ============================================

                    Container(
                      width: addCircleSize,
                      height: addCircleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _textColor,
                          width: 1.2,
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: _textColor,
                        size: 28,
                      ),
                    ),

                    // ============================================
                    // SPACE
                    // ============================================

                    const SizedBox(
                      width: 14,
                    ),

                    // ============================================
                    // ADD PROPERTY TEXT
                    // ============================================

                    Expanded(
                      child: Text(
                        'Add Flat/Villa/Office',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: addTextFontSize,
                          fontWeight: FontWeight.w500,
                          color: _textColor,
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