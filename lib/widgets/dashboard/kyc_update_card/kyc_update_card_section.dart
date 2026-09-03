import 'package:flutter/material.dart';

class KycUpdateCardSection extends StatelessWidget {
  const KycUpdateCardSection({
    super.key,
    required this.onUpdatePressed,
  });

  /// Called when the user taps "Update Now".
  /// The dashboard decides which KYC screen to open.
  final VoidCallback onUpdatePressed;

  // ============================================================
  // COLORS
  // ============================================================

  static const Color _cardColor = Colors.white;
  static const Color _titleColor = Color(0xFF111111);
  static const Color _bodyColor = Color(0xFF555555);
  static const Color _buttonBlue = Color(0xFF0066CC);
  static const Color _borderColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Responsive values
        final horizontalPadding = width < 360
            ? 14.0
            : width < 600
                ? 16.0
                : 20.0;

        final verticalPadding = width < 360
            ? 16.0
            : 18.0;

        final titleFontSize = width < 360
            ? 16.0
            : 17.0;

        final bodyFontSize = width < 360
            ? 13.0
            : 14.0;

        final buttonHeight = width < 360
            ? 44.0
            : 46.0;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _borderColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              verticalPadding,
              horizontalPadding,
              verticalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // TITLE
                // ==================================================

                Text(
                  'KYC Update',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                    color: _titleColor,
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 9),

                // ==================================================
                // DESCRIPTION
                // ==================================================

                Text(
                  'Please update your KYC details\nto continue.',
                  style: TextStyle(
                    fontSize: bodyFontSize,
                    fontWeight: FontWeight.w400,
                    color: _bodyColor,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 16),

                // ==================================================
                // UPDATE NOW BUTTON
                // ==================================================

                SizedBox(
                  width: double.infinity,
                  height: buttonHeight,
                  child: ElevatedButton(
                    onPressed: onUpdatePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _buttonBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: width < 360 ? 12 : 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Update Now',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}