import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/primary_button.dart';

/// Final review step of the non-India KYC flow, shown after
/// [SocietyRegistrationNumberScreen]. Submitting reuses the existing
/// [AppRoutes.kycStatus] screen unchanged — the same terminal step the
/// India flow lands on via KYC Verification.
class KycReviewScreen extends StatefulWidget {
  final String countryName;
  final String stateName;
  final String cityName;
  final String registrationNumber;

  const KycReviewScreen({
    super.key,
    required this.countryName,
    required this.stateName,
    required this.cityName,
    required this.registrationNumber,
  });

  @override
  State<KycReviewScreen> createState() => _KycReviewScreenState();
}

class _KycReviewScreenState extends State<KycReviewScreen> {
  bool _submitting = false;

  /// Simulates the "KYC Under Verification" step as a brief loading state on
  /// the Submit button, matching KycVerificationScreen's existing pattern,
  /// before landing on the (unchanged) KYC Status screen.
  Future<void> _handleSubmit() async {
    setState(() {
      _submitting = true;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    Navigator.pushNamed(context, AppRoutes.kycStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FC),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIcon(),
                    const SizedBox(height: 16),
                    const Text(
                      'Review your details before submitting',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSummaryCard(),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      label: 'Submit KYC',
                      onPressed: _submitting ? null : _handleSubmit,
                      isLoading: _submitting,
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

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFFC7E1F8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const SizedBox(
              width: 48,
              height: 56,
              child: Icon(
                Icons.arrow_back,
                size: 20,
                color: Color(0xFF17202A),
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'KYC Review',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ICON
  // ---------------------------------------------------------------------------

  Widget _buildIcon() {
    return Center(
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.fact_check_outlined,
            color: Color(0xFF1677D2),
            size: 28,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SUMMARY CARD
  // ---------------------------------------------------------------------------

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildSummaryRow('Country', widget.countryName),
          _buildDivider(),
          // State/Province/Region is only known when the city was picked
          // from the curated list — a manually-typed city (no Select State
          // step exists any more) carries an empty state, so skip the row.
          if (widget.stateName.isNotEmpty) ...[
            _buildSummaryRow('State / Province / Region', widget.stateName),
            _buildDivider(),
          ],
          _buildSummaryRow('City', widget.cityName),
          _buildDivider(),
          _buildSummaryRow('Registration Number', widget.registrationNumber),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6));
  }
}
