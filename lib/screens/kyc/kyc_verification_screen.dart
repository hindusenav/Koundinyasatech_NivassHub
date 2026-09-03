import 'package:flutter/material.dart';
import 'kyc_status_screen.dart';

class KycVerificationScreen extends StatefulWidget {
  final String country;
  final String city;
  final String building;
  final String flatNumber;
  final String society;
  final String address;

  const KycVerificationScreen({
    super.key,
    required this.country,
    required this.city,
    required this.building,
    required this.flatNumber,
    required this.society,
    required this.address,
  });

  @override
  State<KycVerificationScreen> createState() =>
      _KycVerificationScreenState();
}

class _KycVerificationScreenState
    extends State<KycVerificationScreen> {
  bool _aadhaarUploaded = false;
  bool _panUploaded = false;
  bool _propertyUploaded = false;
  bool _submitting = false;

  void _uploadAadhaar() {
    setState(() {
      _aadhaarUploaded = true;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content:
            Text('Aadhaar uploaded successfully'),
      ),
    );
  }

  void _uploadPan() {
    setState(() {
      _panUploaded = true;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content:
            Text('PAN uploaded successfully'),
      ),
    );
  }

  void _uploadProperty() {
    setState(() {
      _propertyUploaded = true;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content:
            Text('Property document uploaded'),
      ),
    );
  }

  void _submitKyc() {
    if (!_aadhaarUploaded ||
        !_panUploaded ||
        !_propertyUploaded) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please upload all required documents',
          ),
        ),
      );
      return;
    }

    setState(() {
      _submitting = true;
    });

    Future.delayed(
      const Duration(milliseconds: 900),
      () {
        if (!mounted) return;

       Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => const KycStatusScreen(),
  ),
);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final background =
        isDark
            ? const Color(0xFF121212)
            : Colors.white;

    final textColor =
        isDark
            ? Colors.white
            : const Color(0xFF1A1A1A);

    final secondaryText =
        isDark
            ? Colors.white70
            : Colors.black54;

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: textColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'KYC Verification',
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child:
                  SingleChildScrollView(
                padding:
                    const EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  20,
                ),

                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration:
                          BoxDecoration(
                        shape:
                            BoxShape.circle,
                        color: const Color(
                          0xFF1976D2,
                        ).withValues(
                          alpha: 0.10,
                        ),
                      ),

                      child: const Icon(
                        Icons
                            .verified_user_outlined,
                        color:
                            Color(0xFF1976D2),
                        size: 38,
                      ),
                    ),

                    const SizedBox(
                        height: 18),

                    Text(
                      'Upload your KYC documents',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                        height: 8),

                    Text(
                      'Upload the required documents for verification.',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            secondaryText,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(
                        height: 22),

                    _documentCard(
                      title:
                          'Aadhaar Card',
                      subtitle:
                          'Upload front & back',
                      uploaded:
                          _aadhaarUploaded,
                      onTap:
                          _uploadAadhaar,
                    ),

                    const SizedBox(
                        height: 14),

                    _documentCard(
                      title:
                          'PAN Card',
                      subtitle:
                          'Upload your PAN card',
                      uploaded:
                          _panUploaded,
                      onTap: _uploadPan,
                    ),

                    const SizedBox(
                        height: 14),

                    _documentCard(
                      title:
                          'Property Document',
                      subtitle:
                          'Upload property document',
                      uploaded:
                          _propertyUploaded,
                      onTap:
                          _uploadProperty,
                    ),

                    const SizedBox(
                        height: 20),

                    Container(
                      width: double
                          .infinity,
                      padding:
                          const EdgeInsets.all(
                              15),
                      decoration:
                          BoxDecoration(
                        color:
                            const Color(
                          0xFFEAF4FF,
                        ),
                        borderRadius:
                            BorderRadius
                                .circular(
                                    10),
                      ),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(
                                0xFF1976D2),
                          ),
                          const SizedBox(
                              width: 10),
                          Expanded(
                            child: Text(
                              'Make sure all documents are clear and readable before submitting.',
                              style:
                                  TextStyle(
                                color:
                                    textColor,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                16,
              ),

              child: SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed:
                      _submitting
                          ? null
                          : _submitKyc,

                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        const Color(
                            0xFF1976D2),
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(10),
                    ),
                  ),

                  child: _submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Submit Documents',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _documentCard({
    required String title,
    required String subtitle,
    required bool uploaded,
    required VoidCallback onTap,
  }) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final textColor =
        isDark
            ? Colors.white
            : const Color(0xFF1A1A1A);

    final secondary =
        isDark
            ? Colors.white70
            : Colors.black54;

    return InkWell(
      borderRadius:
          BorderRadius.circular(12),

      onTap: onTap,

      child: Container(
        padding:
            const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1E1E1E)
              : Colors.white,

          borderRadius:
              BorderRadius.circular(12),

          border: Border.all(
            color: uploaded
                ? Colors.green
                : isDark
                    ? Colors.white24
                    : Colors.black12,
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration:
                  BoxDecoration(
                borderRadius:
                    BorderRadius.circular(10),
                color:
                    const Color(
                  0xFF1976D2,
                ).withValues(
                  alpha: 0.10,
                ),
              ),
              child: Icon(
                uploaded
                    ? Icons.check
                    : Icons.upload_file_outlined,
                color: uploaded
                    ? Colors.green
                    : const Color(
                        0xFF1976D2),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                      height: 4),

                  Text(
                    uploaded
                        ? 'Uploaded successfully'
                        : subtitle,
                    style: TextStyle(
                      color:
                          uploaded
                              ? Colors.green
                              : secondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              uploaded
                  ? Icons
                      .check_circle
                  : Icons
                      .chevron_right,
              color: uploaded
                  ? Colors.green
                  : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}