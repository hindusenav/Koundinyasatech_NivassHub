import 'package:flutter/material.dart';
import 'kyc_verification_screen.dart';

class AddHomeScreen extends StatefulWidget {
  final String country;
  final String city;
  final String building;

  const AddHomeScreen({
    super.key,
    required this.country,
    required this.city,
    required this.building,
  });

  @override
  State<AddHomeScreen> createState() =>
      _AddHomeScreenState();
}

class _AddHomeScreenState
    extends State<AddHomeScreen> {
  final _formKey =
      GlobalKey<FormState>();

  final _flatController =
      TextEditingController();

  final _addressController =
      TextEditingController();

  final _societyController =
      TextEditingController();

  @override
  void dispose() {
    _flatController.dispose();
    _addressController.dispose();
    _societyController.dispose();
    super.dispose();
  }

  void _continueToKyc() {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            KycVerificationScreen(
          country: widget.country,
          city: widget.city,
          building: widget.building,
          flatNumber:
              _flatController.text.trim(),
          society:
              _societyController.text.trim(),
          address:
              _addressController.text.trim(),
        ),
      ),
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

    final fieldColor =
        isDark
            ? const Color(0xFF1E1E1E)
            : const Color(0xFFF8F8F8);

    const primaryBlue =
        Color(0xFF1976D2);

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
          'Add Home',
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: LayoutBuilder(
            builder: (
              context,
              constraints,
            ) {
              return Column(
                children: [
                  Expanded(
                    child:
                        SingleChildScrollView(
                      physics:
                          const BouncingScrollPhysics(),

                      padding:
                          const EdgeInsets.fromLTRB(
                        20,
                        18,
                        20,
                        20,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Center(
                            child: Container(
                              width: 72,
                              height: 72,

                              decoration:
                                  BoxDecoration(
                                shape:
                                    BoxShape.circle,
                                color: primaryBlue
                                    .withValues(
                                        alpha: 0.10),
                              ),

                              child:
                                  const Icon(
                                Icons.home_outlined,
                                size: 38,
                                color:
                                    primaryBlue,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 20),

                          Center(
                            child: Text(
                              'Add your home',
                              style:
                                  TextStyle(
                                color:
                                    textColor,
                                fontSize: 24,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 8),

                          Center(
                            child: Text(
                              'Enter your property details below.',
                              textAlign:
                                  TextAlign
                                      .center,
                              style:
                                  TextStyle(
                                color:
                                    secondaryText,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 24),

                          _infoCard(
                            textColor:
                                textColor,
                            secondaryText:
                                secondaryText,
                          ),

                          const SizedBox(
                              height: 20),

                          _field(
                            controller:
                                _flatController,
                            label:
                                'Flat / House No.',
                            hint: 'B-402',
                            icon: Icons
                                .apartment_outlined,
                            fieldColor:
                                fieldColor,
                            textColor:
                                textColor,
                            primaryBlue:
                                primaryBlue,
                            validator:
                                (value) {
                              if (value ==
                                      null ||
                                  value
                                      .trim()
                                      .isEmpty) {
                                return 'Please enter flat / house number';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(
                              height: 16),

                          _field(
                            controller:
                                _societyController,
                            label:
                                'Society / Building Name',
                            hint:
                                'Golden Residency',
                            icon: Icons
                                .business_outlined,
                            fieldColor:
                                fieldColor,
                            textColor:
                                textColor,
                            primaryBlue:
                                primaryBlue,
                            validator:
                                (value) {
                              if (value ==
                                      null ||
                                  value
                                      .trim()
                                      .isEmpty) {
                                return 'Please enter society/building name';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(
                              height: 16),

                          _field(
                            controller:
                                _addressController,
                            label: 'Address',
                            hint:
                                'Enter complete address',
                            icon: Icons
                                .location_on_outlined,
                            maxLines: 4,
                            fieldColor:
                                fieldColor,
                            textColor:
                                textColor,
                            primaryBlue:
                                primaryBlue,
                            validator:
                                (value) {
                              if (value ==
                                      null ||
                                  value
                                      .trim()
                                      .isEmpty) {
                                return 'Please enter address';
                              }
                              return null;
                            },
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

                    child:
                        SizedBox(
                      width:
                          double.infinity,
                      height: 50,

                      child:
                          ElevatedButton(
                        onPressed:
                            _continueToKyc,

                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              primaryBlue,
                          foregroundColor:
                              Colors.white,
                          elevation: 0,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    10),
                          ),
                        ),

                        child:
                            const Text(
                          'Continue',
                          style:
                              TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required Color textColor,
    required Color secondaryText,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FF),
        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Column(
        children: [
          _miniRow(
            title: 'Country',
            value: widget.country,
            textColor: textColor,
            secondaryText:
                secondaryText,
          ),

          const SizedBox(
              height: 12),

          _miniRow(
            title: 'City',
            value: widget.city,
            textColor: textColor,
            secondaryText:
                secondaryText,
          ),

          const SizedBox(
              height: 12),

          _miniRow(
            title: 'Area',
            value: widget.building,
            textColor: textColor,
            secondaryText:
                secondaryText,
          ),
        ],
      ),
    );
  }

  Widget _miniRow({
    required String title,
    required String value,
    required Color textColor,
    required Color secondaryText,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: secondaryText,
              fontSize: 12,
            ),
          ),
        ),

        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color fieldColor,
    required Color textColor,
    required Color primaryBlue,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight:
                FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(
            color: textColor,
          ),

          decoration:
              InputDecoration(
            hintText: hint,
            prefixIcon:
                Icon(
              icon,
              color: primaryBlue,
            ),
            filled: true,
            fillColor: fieldColor,
            border:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                      10),
            ),
          ),

          validator: validator,
        ),
      ],
    );
  }
}