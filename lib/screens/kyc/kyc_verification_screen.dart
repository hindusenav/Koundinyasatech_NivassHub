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
      height: 50,
      decoration: const BoxDecoration(
        color: Color(0xFFC7E1F8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),

          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const SizedBox(
              width: 35,
              height: 40,
              child: Icon(
                Icons.arrow_back,
                size: 16,
                color: Color(0xFF17202A),
              ),
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                'KYC Verification',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ),
          ),

          const SizedBox(width: 47),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CONTENT
  // ---------------------------------------------------------------------------

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(9, 17, 9, 12),
      child: Column(
        children: [
          _buildKycIcon(),

          const SizedBox(height: 10),

          const Text(
            'Upload your documents for verification',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 7,
              color: Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: 17),

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

          const SizedBox(height: 8),

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

          const SizedBox(height: 8),

          _buildDocumentCard(
            title: 'PROPERTY DOCUMENT',
            subtitle: 'Proof of ownership or residence',
            icon: Icons.crop_square,
            pending: !propertyUploaded,
            uploadText: 'Upload ownership proof',
            onUpload: () {
              setState(() {
                propertyUploaded = true;
              });
            },
          ),

          const SizedBox(height: 18),

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
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.shield_outlined,
          size: 21,
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
      padding: const EdgeInsets.fromLTRB(7, 7, 7, 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: const Color(0xFFD5DDE7),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
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
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4FF),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Icon(
                  icon,
                  size: 12,
                  color: const Color(0xFF1478D4),
                ),
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 5.5,
                        color: Color(0xFF8A95A3),
                      ),
                    ),
                  ],
                ),
              ),

              if (pending)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5DD),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Pending',
                    style: TextStyle(
                      fontSize: 5.5,
                      color: Color(0xFFE8A300),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 6),

          // Upload area
          GestureDetector(
            onTap: onUpload,
            child: Container(
              width: double.infinity,
              height: 43,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FBFE),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: const Color(0xFFB9C8D7),
                  width: 0.8,
                ),
              ),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    pending
                        ? Icons.upload_file_outlined
                        : Icons.check_circle_outline,
                    size: 13,
                    color: pending
                        ? const Color(0xFF0876D1)
                        : Colors.green,
                  ),

                  const SizedBox(height: 2),

                  Text(
                    pending
                        ? '+ $uploadText'
                        : 'Document uploaded',
                    style: TextStyle(
                      fontSize: 6.5,
                      fontWeight: FontWeight.w700,
                      color: pending
                          ? const Color(0xFF0876D1)
                          : Colors.green,
                    ),
                  ),

                  const SizedBox(height: 1),

                  Text(
                    'PDF, JPG, JPEG up to 5MB',
                    style: TextStyle(
                      fontSize: 5,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
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
      height: 29,
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
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: _submitting
            ? const SizedBox(
                width: 14,
                height: 14,
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
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withOpacity(
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
    return Container(
      height: 53,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFC7E1F8),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(13),
          topRight: Radius.circular(13),
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
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    bool selected = false,
  }) {
    return SizedBox(
      width: 43,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 19,
            height: 19,
            decoration: selected
                ? const BoxDecoration(
                    color: Color(0xFF0876D1),
                    shape: BoxShape.circle,
                  )
                : null,
            child: Icon(
              icon,
              size: 11,
              color: selected
                  ? Colors.white
                  : const Color(0xFF526170),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 5.5,
              color: selected
                  ? const Color(0xFF0876D1)
                  : const Color(0xFF526170),
              fontWeight:
                  selected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}