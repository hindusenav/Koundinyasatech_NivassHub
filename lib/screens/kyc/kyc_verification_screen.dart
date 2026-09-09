import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/routes/app_routes.dart';

class KycVerificationScreen extends StatefulWidget {
  const KycVerificationScreen({super.key});

  @override
  State<KycVerificationScreen> createState() =>
      _KycVerificationScreenState();
}

class _KycVerificationScreenState
    extends State<KycVerificationScreen> {
  bool aadhaarUploaded = false;
  bool panUploaded = false;
  bool propertyUploaded = false;
  bool _submitting = false;

  /// Simulates the "KYC Under Verification" step as a brief loading state
  /// on the Submit button (no dedicated screen exists for it) before
  /// landing on the KYC Approved screen.
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
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: _buildContent(),
                    ),
                  ),
                  _buildBottomNavigation(),
                ],
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
                'KYC Verification',
                style: TextStyle(
                  fontSize: 18,
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
  // CONTENT
  // ---------------------------------------------------------------------------

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
      child: Column(
        children: [
          _buildKycIcon(),

          const SizedBox(height: 16),

          const Text(
            'Upload your documents for verification',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: 28),

          _buildDocumentCard(
            title: 'AADHAAR CARD',
            subtitle: 'Government issued National ID',
            icon: Icons.description_outlined,
            pending: !aadhaarUploaded,
            uploadText: 'Upload Front & Back',
            onUpload: () {
              setState(() {
                aadhaarUploaded = true;
              });
            },
          ),

          const SizedBox(height: 12),

          _buildDocumentCard(
            title: 'PAN CARD',
            subtitle: 'Permanent Account Number',
            icon: Icons.article_outlined,
            pending: !panUploaded,
            uploadText: 'Tap to upload PAN Front',
            onUpload: () {
              setState(() {
                panUploaded = true;
              });
            },
          ),

          const SizedBox(height: 12),

          _buildDocumentCard(
            title: 'PROPERTY DOCUMENT',
            subtitle: 'Proof of ownership or rental lease',
            icon: Icons.chat_bubble_outline,
            pending: !propertyUploaded,
            uploadText: 'Upload ownership proof',
            onUpload: () {
              setState(() {
                propertyUploaded = true;
              });
            },
          ),

          const SizedBox(height: 28),

          _buildSubmitButton(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // KYC ICON
  // ---------------------------------------------------------------------------

  Widget _buildKycIcon() {
    return Container(
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
          Icons.shield_outlined,
          size: 28,
          color: Color(0xFF1677D2),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DOCUMENT CARD
  // ---------------------------------------------------------------------------

  Widget _buildDocumentCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool pending,
    required String uploadText,
    required VoidCallback onUpload,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E9F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title row
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: const Color(0xFF1478D4),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8A95A3),
                      ),
                    ),
                  ],
                ),
              ),

              if (pending)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5DD),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Pending',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFE8A300),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Upload area
          GestureDetector(
            onTap: onUpload,
            child: CustomPaint(
              painter: _DashedRoundedRectPainter(
                color: const Color(0xFFB9C8D7),
                radius: 10,
                strokeWidth: 1.2,
              ),
              child: Container(
                width: double.infinity,
                height: 76,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FBFE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      pending
                          ? Icons.upload_file_outlined
                          : Icons.check_circle_outline,
                      size: 20,
                      color: pending
                          ? const Color(0xFF0876D1)
                          : Colors.green,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      pending
                          ? '+ $uploadText'
                          : 'Document uploaded',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: pending
                            ? const Color(0xFF0876D1)
                            : Colors.green,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'PDF, JPG, JPEG up to 5MB',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SUBMIT BUTTON
  // ---------------------------------------------------------------------------

  Widget _buildSubmitButton() {
    final bool canSubmit =
        aadhaarUploaded &&
        panUploaded &&
        propertyUploaded &&
        !_submitting;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: canSubmit ? _handleSubmit : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF006FCB),
          disabledBackgroundColor:
              const Color(0xFF006FCB),
          foregroundColor: Colors.white,
          elevation: 2,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _submitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              )
            : Text(
                'Submit Documents',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(
                    alpha:
                        aadhaarUploaded && panUploaded && propertyUploaded
                            ? 1
                            : 0.85,
                  ),
                ),
              ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM NAVIGATION
  // ---------------------------------------------------------------------------

  Widget _buildBottomNavigation() {
    return SafeArea(
      top: false,
      child: Container(
        height: 84,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFC7E3FF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,
          children: [
            _navItem(
              icon: Icons.home,
              label: 'Home',
              selected: true,
            ),
            _navItem(
              icon: Icons.person_outline,
              label: 'Visitors',
            ),
            _navItem(
              icon: Icons.apartment_outlined,
              label: 'Community',
            ),
            _navItem(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Payments',
            ),
            _navItem(
              icon: Icons.menu,
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    bool selected = false,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: selected
                ? const BoxDecoration(
                    color: Color(0xFF0060BD),
                    shape: BoxShape.circle,
                  )
                : null,
            child: Icon(
              icon,
              size: 22,
              color: selected
                  ? Colors.white
                  : const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: selected
                  ? const Color(0xFF0060BD)
                  : const Color(0xFF475569),
              fontWeight:
                  selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// DASHED ROUNDED-RECT BORDER PAINTER
// ---------------------------------------------------------------------------

/// Paints a dashed rounded-rectangle outline around its child, matching the
/// dashed upload-drop-zone border in the Figma design (plain [Border.all]
/// only supports solid strokes).
class _DashedRoundedRectPainter extends CustomPainter {
  const _DashedRoundedRectPainter({
    required this.color,
    required this.radius,
    this.strokeWidth = 1.2,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  static const double dashWidth = 5;
  static const double dashGap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedRectPainter oldDelegate) {
    return color != oldDelegate.color ||
        radius != oldDelegate.radius ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
