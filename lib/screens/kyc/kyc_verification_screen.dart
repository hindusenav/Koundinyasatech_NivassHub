import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';

class KycVerificationScreen extends StatefulWidget {
  const KycVerificationScreen({super.key});

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  bool aadhaarUploaded = false;
  bool panUploaded = false;
  bool propertyUploaded = false;
  bool _submitting = false;

  // ===========================================================================
  // ONLY KYC ASSETS
  // ===========================================================================

  static const String aadhaarIcon = 'assets/icons/aadaarcardimg.png';
  static const String panIcon = 'assets/icons/pancardimg.png';
  static const String propertyIcon = 'assets/icons/propertyimg.png';
  static const String uploadIcon = 'assets/icons/uploadimg.png';
  static const String verificationIcon = 'assets/icons/verificationimg.png';

  // ===========================================================================
  // COLORS
  // ===========================================================================

  static const Color backgroundColor = Color(0xFFF4F8FC);
  static const Color headerColor = Color(0xFFC7E1F8);
  static const Color bottomNavColor = Color(0xFFC7E3FF);
  static const Color primaryBlue = Color(0xFF006FCB);
  static const Color darkText = Color(0xFF27364A);
  static const Color greyText = Color(0xFF7A8795);
  static const Color lightGreyText = Color(0xFFA2ACB7);
  static const Color borderColor = Color(0xFFD8E1EA);
  static const Color uploadBackground = Color(0xFFF8FBFE);
  static const Color pendingBackground = Color(0xFFFFF4D9);
  static const Color pendingText = Color(0xFFE5A000);

  // ===========================================================================
  // SUBMIT
  // ===========================================================================

  Future<void> _handleSubmit() async {
    if (!aadhaarUploaded || !panUploaded || !propertyUploaded || _submitting) {
      return;
    }

    setState(() {
      _submitting = true;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    Navigator.pushNamed(context, AppRoutes.kycStatus);
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildContent(),
                  ],
                ),
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 56,
      color: headerColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 4,
            top: 0,
            bottom: 0,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(30),
              child: const SizedBox(
                width: 48,
                height: 56,
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    size: 22,
                    color: Color(0xFF17202A),
                  ),
                ),
              ),
            ),
          ),
          const Center(
            child: Text(
              'KYC Verification',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
                letterSpacing: 0.15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // CONTENT
  // ===========================================================================

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        children: [
          _buildVerificationHeader(),
          const SizedBox(height: 24),

          // AADHAAR CARD
          _buildDocumentCard(
            title: 'AADHAAR CARD',
            subtitle: 'Government issued National ID',
            iconPath: aadhaarIcon,
            uploadText: 'Upload Front & Back',
            uploaded: aadhaarUploaded,
            onUpload: () {
              setState(() {
                aadhaarUploaded = true;
              });
            },
          ),

          const SizedBox(height: 16),

          // PAN CARD
          _buildDocumentCard(
            title: 'PAN CARD',
            subtitle: 'Permanent Account Number',
            iconPath: panIcon,
            uploadText: 'Tap to upload PAN Front',
            uploaded: panUploaded,
            onUpload: () {
              setState(() {
                panUploaded = true;
              });
            },
          ),

          const SizedBox(height: 16),

          // PROPERTY DOCUMENT
          _buildDocumentCard(
            title: 'PROPERTY DOCUMENT',
            subtitle: 'Proof of ownership or rental lease',
            iconPath: propertyIcon,
            uploadText: 'Upload ownership proof',
            uploaded: propertyUploaded,
            onUpload: () {
              setState(() {
                propertyUploaded = true;
              });
            },
          ),

          const SizedBox(height: 32),

          _buildSubmitButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ===========================================================================
  // VERIFICATION ICON
  // ===========================================================================

  Widget _buildVerificationHeader() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Image.asset(
            verificationIcon,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.verified_outlined,
                size: 40,
                color: primaryBlue,
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Upload your documents for verification',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: greyText,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // DOCUMENT CARD
  // ===========================================================================

  Widget _buildDocumentCard({
    required String title,
    required String subtitle,
    required String iconPath,
    required String uploadText,
    required bool uploaded,
    required VoidCallback onUpload,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===================================================================
          // DOCUMENT HEADER
          // ===================================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // DOCUMENT ICON
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.description_outlined,
                      size: 24,
                      color: primaryBlue,
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              // TITLE + SUBTITLE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: darkText,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: lightGreyText,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // PENDING / UPLOADED
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: uploaded ? const Color(0xFFE7F8ED) : pendingBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  uploaded ? 'Uploaded' : 'Pending',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: uploaded ? const Color(0xFF159447) : pendingText,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ===================================================================
          // UPLOAD BOX with dashed border
          // ===================================================================

          GestureDetector(
            onTap: onUpload,
            child: Container(
              width: double.infinity,
              height: 76,
              decoration: BoxDecoration(
                color: uploadBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFB7C7D8),
                  width: 1.2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    uploadIcon,
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.cloud_upload_outlined,
                        size: 22,
                        color: primaryBlue,
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(
                    uploaded ? 'Document uploaded' : '+ $uploadText',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: uploaded ? const Color(0xFF159447) : primaryBlue,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'PDF, JPG, JPEG up to 5MB',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w400,
                      color: lightGreyText,
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

  // ===========================================================================
  // SUBMIT BUTTON
  // ===========================================================================

  Widget _buildSubmitButton() {
    final bool canSubmit =
        aadhaarUploaded && panUploaded && propertyUploaded && !_submitting;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: canSubmit ? _handleSubmit : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          disabledBackgroundColor: primaryBlue.withValues(alpha: 0.5),
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.12),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: _submitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              )
            : const Text(
                'Submit Documents',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
      ),
    );
  }

  // ===========================================================================
  // BOTTOM NAVIGATION (Fixed at bottom)
  // ===========================================================================

  Widget _buildBottomNavigation() {
    return Container(
      width: double.infinity,
      height: 76,
      decoration: const BoxDecoration(
        color: bottomNavColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          _buildBottomItem(
            iconPath: verificationIcon,
            label: 'Home',
            selected: true,
          ),
          _buildBottomItem(
            iconPath: aadhaarIcon,
            label: 'Visitors',
          ),
          _buildBottomItem(
            iconPath: propertyIcon,
            label: 'Community',
          ),
          _buildBottomItem(
            iconPath: panIcon,
            label: 'Payments',
          ),
          _buildBottomItem(
            iconPath: uploadIcon,
            label: 'More',
          ),
        ],
      ),
    );
  }

  Widget _buildBottomItem({
    required String iconPath,
    required String label,
    bool selected = false,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          // Navigation logic here
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: selected
                    ? const BoxDecoration(
                        color: Color(0xFF0068C9),
                        shape: BoxShape.circle,
                      )
                    : null,
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.circle_outlined,
                      size: 22,
                      color: selected ? Colors.white : const Color(0xFF475569),
                    );
                  },
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? const Color(0xFF0068C9) : const Color(0xFF475569),
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}