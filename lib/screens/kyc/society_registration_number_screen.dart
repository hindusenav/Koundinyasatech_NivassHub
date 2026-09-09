import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/utils/form_validators.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/primary_button.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/custom_text_field.dart';

/// Non-India KYC step shown after Select City for any country other than
/// India (see [AppRoutes.societyRegistrationNumber]). India keeps its
/// existing Add Home / KYC Verification path untouched — this screen and
/// [AppRoutes.kycReview] are the only two new steps in the non-India flow.
class SocietyRegistrationNumberScreen extends StatefulWidget {
  final String countryName;
  final String stateName;
  final String cityName;

  const SocietyRegistrationNumberScreen({
    super.key,
    required this.countryName,
    required this.stateName,
    required this.cityName,
  });

  @override
  State<SocietyRegistrationNumberScreen> createState() =>
      _SocietyRegistrationNumberScreenState();
}

class _SocietyRegistrationNumberScreenState
    extends State<SocietyRegistrationNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _registrationController = TextEditingController();

  @override
  void dispose() {
    _registrationController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pushNamed(
      context,
      AppRoutes.kycReview,
      arguments: {
        'country': widget.countryName,
        'state': widget.stateName,
        'city': widget.cityName,
        'registrationNumber': _registrationController.text.trim(),
      },
    );
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIcon(),
                      const SizedBox(height: 16),
                      const Text(
                        'Society Registration Number',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your society registration number to continue.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        controller: _registrationController,
                        label: 'Registration Number',
                        hint: 'e.g. SRN-12345',
                        validator: (value) => FormValidators.required(
                          value,
                          message: 'Please enter your registration number',
                        ),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _onContinue(),
                      ),
                      const SizedBox(height: 28),
                      PrimaryButton(
                        label: 'Continue',
                        onPressed: _onContinue,
                      ),
                    ],
                  ),
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
                'Society Registration Number',
                textAlign: TextAlign.center,
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
            Icons.badge_outlined,
            color: Color(0xFF1677D2),
            size: 28,
          ),
        ),
      ),
    );
  }
}
