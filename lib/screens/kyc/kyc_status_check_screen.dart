import 'package:flutter/material.dart';

import 'kyc_status_screen.dart';
import 'select_country_screen.dart';

class KycStatusCheckScreen extends StatefulWidget {
  const KycStatusCheckScreen({
    super.key,
    this.kycAlreadyApproved = true,
  });

  final bool kycAlreadyApproved;

  @override
  State<KycStatusCheckScreen> createState() =>
      _KycStatusCheckScreenState();
}

class _KycStatusCheckScreenState
    extends State<KycStatusCheckScreen> {

  @override
  void initState() {
    super.initState();

    _checkKycStatus();
  }

  // ============================================================
  // CHECK KYC STATUS
  // ============================================================

  Future<void> _checkKycStatus() async {
    await Future.delayed(
      const Duration(milliseconds: 1200),
    );

    if (!mounted) return;

    // ==========================================================
    // EXISTING USER - KYC ALREADY APPROVED
    // ==========================================================

    if (widget.kycAlreadyApproved) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const KycStatusScreen(
            isAlreadyApproved: true,
          ),
        ),
      );

      return;
    }

    // ==========================================================
    // EXISTING USER - KYC NOT COMPLETED
    // ==========================================================

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const SelectCountryScreen(),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final background =
        isDark
            ? const Color(0xFF121212)
            : Colors.white;

    final textColor =
        isDark
            ? Colors.white
            : const Color(0xFF1A1A1A);

    final secondaryTextColor =
        isDark
            ? Colors.white70
            : Colors.black54;

    return Scaffold(
      backgroundColor: background,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ==================================================
                // ICON
                // ==================================================

                Container(
                  width: 90,
                  height: 90,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF25A969)
                        .withValues(alpha: 0.10),
                  ),

                  child: const Icon(
                    Icons.verified_user_outlined,
                    size: 48,
                    color: Color(0xFF25A969),
                  ),
                ),

                const SizedBox(height: 24),

                // ==================================================
                // TITLE
                // ==================================================

                Text(
                  'Checking KYC Status',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // DESCRIPTION
                // ==================================================

                Text(
                  'Please wait while we check your KYC status.',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 28),

                // ==================================================
                // LOADING
                // ==================================================

                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Color(0xFF1976D2),
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