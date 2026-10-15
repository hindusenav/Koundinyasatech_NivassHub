import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/models/auth/auth_flow_state.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/auth/select_city_screen.dart';
import 'package:flutter_nivasshub/screens/auth/select_country_screen.dart';
import 'package:flutter_nivasshub/screens/kyc/kyc_documents_screen.dart';
import 'package:flutter_nivasshub/utils/flag_emoji.dart';
import 'package:flutter_nivasshub/utils/form_validators.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_curved_app_bar.dart';
import 'package:flutter_nivasshub/widgets/auth/section_header_badge.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';

class UserDetailsScreenArgs {
  const UserDetailsScreenArgs({
    required this.identifier,
    this.prefillFullName,
    this.prefillCountry = 'India',
    this.prefillCountryCode = 'IN',
    this.prefillState,
    this.prefillCity,
  });

  final AuthIdentifier identifier;
  final String? prefillFullName;
  final String prefillCountry;
  final String prefillCountryCode;
  final String? prefillState;
  final String? prefillCity;
}

/// Screen 4: "Complete Your Profile"
///
/// Matches Screen 4 of the new registration design mockups:
/// - Curved dark navy app bar ("Complete Your Profile")
/// - 3 Cards with vertical orange badge headers:
///   1. PERSONAL DETAILS: Name, Mobile Number (read-only/disabled), Email ID
///   2. LOCATION DETAILS: Country, State, City (with navigation links)
///   3. PROPERTY DETAILS: Society/Building Name, Wing/Tower, Floor, Flat/House No.
/// - Dark navy "Submit Details" CTA button
class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key, required this.args});

  final UserDetailsScreenArgs args;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _flatController;

  late String _selectedCountry;
  late String _selectedCountryCode;
  late String _selectedState;
  late String _selectedCity;

  String? _selectedSociety;
  String? _selectedTower;
  String? _selectedFloor;

  bool _isSubmitting = false;

  static const List<String> _statesList = [
    'Karnataka',
    'Maharashtra',
    'Delhi',
    'Tamil Nadu',
    'Telangana',
    'Gujarat',
    'West Bengal',
    'Kerala',
    'Punjab',
    'Rajasthan',
    'Uttar Pradesh',
    'Andhra Pradesh',
    'Madhya Pradesh',
  ];

  static const List<String> _societiesList = [
    'Sunrise Heights',
    'Green Valley Apartment',
    'Prestige Falcon City',
    'Sobha Dream Acres',
    'Brigade Gateway',
    'Godrej Woods',
    'Hiranandani Gardens',
    'DLF Phase 5',
  ];

  static const List<String> _towersList = [
    'Tower A',
    'Tower B',
    'Tower C',
    'Tower D',
    'Wing A',
    'Wing B',
    'Block 1',
    'Block 2',
  ];

  static const List<String> _floorsList = [
    'Ground Floor',
    '1st Floor',
    '2nd Floor',
    '3rd Floor',
    '4th Floor',
    '5th Floor',
    '6th Floor',
    '7th Floor',
    '8th Floor',
    '9th Floor',
    '10th Floor',
    '11th Floor',
    '12th Floor',
  ];

  @override
  void initState() {
    super.initState();
    final identifier = widget.args.identifier;

    _nameController = TextEditingController(
      text: widget.args.prefillFullName ?? '',
    );
    _emailController = TextEditingController(
      text: identifier.channel == AuthChannel.email ? identifier.raw : '',
    );
    _flatController = TextEditingController(text: '502');

    _selectedCountry = widget.args.prefillCountry;
    _selectedCountryCode = widget.args.prefillCountryCode;
    _selectedState = widget.args.prefillState ?? 'Karnataka';
    _selectedCity = widget.args.prefillCity ?? 'Bangalore';

    _selectedSociety = _societiesList.first;
    _selectedTower = _towersList.first;
    _selectedFloor = _floorsList[4]; // 5th Floor
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _flatController.dispose();
    super.dispose();
  }

  void _navigateToSelectCountry() {
    Navigator.of(context).pushNamed(
      AppRoutes.selectCountry,
      arguments: SelectCountryScreenArgs(identifier: widget.args.identifier),
    );
  }

  void _navigateToSelectCity() {
    Navigator.of(context).pushNamed(
      AppRoutes.selectCity,
      arguments: SelectCityScreenArgs(
        identifier: widget.args.identifier,
        selectedCountryName: _selectedCountry,
        selectedCountryCode: _selectedCountryCode,
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) return;

    if (_selectedSociety == null || _selectedSociety!.isEmpty) {
      CustomSnackbar.error(context, 'Please select a Society / Building');
      return;
    }
    if (_selectedTower == null || _selectedTower!.isEmpty) {
      CustomSnackbar.error(context, 'Please select a Wing / Tower');
      return;
    }
    if (_selectedFloor == null || _selectedFloor!.isEmpty) {
      CustomSnackbar.error(context, 'Please select a Floor');
      return;
    }
    if (_flatController.text.trim().isEmpty) {
      CustomSnackbar.error(context, 'Please enter Flat / House No.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final authState = context.read<AuthStateProvider>();
      await authState.moveTo(
        AuthFlowState.kycPending,
        context: authState.context.copyWith(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
        ),
      );
      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed(
        AppRoutes.kycDocuments,
        arguments: KycDocumentsScreenArgs(
          userId: widget.args.identifier.normalized,
        ),
      );
    } catch (e) {
      if (mounted) {
        CustomSnackbar.error(context, 'Failed to save profile: $e');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: const AuthCurvedAppBar(title: 'Complete Your Profile'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CARD 1: PERSONAL DETAILS
                const SectionHeaderBadge(title: 'PERSONAL DETAILS'),
                const SizedBox(height: 8),
                _buildCard(
                  children: [
                    _buildLabel('Name'),
                    const SizedBox(height: 6),
                    _buildInputContainer(
                      child: TextFormField(
                        controller: _nameController,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AuthColors.blueNh,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]')),
                        ],
                        decoration: _inputDecoration(
                          hintText: 'Enter your full name',
                          prefixIcon: Icons.person_outline_rounded,
                        ),
                        validator: FormValidators.fullName,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Mobile Number'),
                    const SizedBox(height: 6),
                    _buildInputContainer(
                      color: const Color(0xFFF3F4F6),
                      child: TextFormField(
                        initialValue: widget.args.identifier.formatted,
                        readOnly: true,
                        enabled: false,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B7280),
                        ),
                        decoration: _inputDecoration(
                          prefixIcon: Icons.phone_iphone_rounded,
                          suffixIcon: Icons.lock_outline_rounded,
                          suffixColor: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Email ID'),
                    const SizedBox(height: 6),
                    _buildInputContainer(
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AuthColors.blueNh,
                        ),
                        decoration: _inputDecoration(
                          hintText: 'Username@gmail.com',
                          prefixIcon: Icons.mail_outline_rounded,
                        ),
                        validator: FormValidators.email,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // CARD 2: LOCATION DETAILS
                const SectionHeaderBadge(title: 'LOCATION DETAILS'),
                const SizedBox(height: 8),
                _buildCard(
                  children: [
                    _buildLabel('Country'),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: _navigateToSelectCountry,
                      borderRadius: BorderRadius.circular(12),
                      child: _buildSelectorTile(
                        leading: Text(
                          flagEmojiFromIso(_selectedCountryCode) ?? '🌐',
                          style: const TextStyle(fontSize: 18),
                        ),
                        text: _selectedCountry,
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF9CA3AF),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('State'),
                    const SizedBox(height: 6),
                    _buildDropdownField<String>(
                      value: _selectedState,
                      items: _statesList,
                      hintText: 'Select State',
                      prefixIcon: Icons.location_on_outlined,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedState = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('City'),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: _navigateToSelectCity,
                      borderRadius: BorderRadius.circular(12),
                      child: _buildSelectorTile(
                        leading: const Icon(
                          Icons.location_city_outlined,
                          color: AuthColors.blueNh,
                          size: 20,
                        ),
                        text: _selectedCity,
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF9CA3AF),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // CARD 3: PROPERTY DETAILS
                const SectionHeaderBadge(title: 'PROPERTY DETAILS'),
                const SizedBox(height: 8),
                _buildCard(
                  children: [
                    _buildLabel('Society / Building Name'),
                    const SizedBox(height: 6),
                    _buildDropdownField<String>(
                      value: _selectedSociety,
                      items: _societiesList,
                      hintText: 'Select Society / Building',
                      prefixIcon: Icons.apartment_rounded,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedSociety = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Wing / Tower'),
                    const SizedBox(height: 6),
                    _buildDropdownField<String>(
                      value: _selectedTower,
                      items: _towersList,
                      hintText: 'Select Wing / Tower',
                      prefixIcon: Icons.domain_rounded,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedTower = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Floor'),
                    const SizedBox(height: 6),
                    _buildDropdownField<String>(
                      value: _selectedFloor,
                      items: _floorsList,
                      hintText: 'Select Floor',
                      prefixIcon: Icons.layers_outlined,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedFloor = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Flat / House No.'),
                    const SizedBox(height: 6),
                    _buildInputContainer(
                      child: TextFormField(
                        controller: _flatController,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AuthColors.blueNh,
                        ),
                        decoration: _inputDecoration(
                          hintText: 'e.g. 502',
                          prefixIcon: Icons.meeting_room_outlined,
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter Flat / House No.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Dark Navy Submit Details Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AuthColors.navyButton,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Submit Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.8),
        boxShadow: const [AuthColors.shadowCards1],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AuthColors.blueNh,
      ),
    );
  }

  Widget _buildInputContainer({
    required Widget child,
    Color color = Colors.white,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: child,
    );
  }

  InputDecoration _inputDecoration({
    String? hintText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Color? suffixColor,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF9CA3AF),
      ),
      icon: prefixIcon != null
          ? Icon(prefixIcon, color: AuthColors.blueNh, size: 18)
          : null,
      suffixIcon: suffixIcon != null
          ? Icon(suffixIcon, color: suffixColor ?? AuthColors.blueNh, size: 18)
          : null,
      border: InputBorder.none,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
    );
  }

  Widget _buildSelectorTile({
    required Widget leading,
    required String text,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AuthColors.blueNh,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required T? value,
    required List<T> items,
    required String hintText,
    required IconData prefixIcon,
    required void Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF9CA3AF),
            size: 22,
          ),
          hint: Row(
            children: [
              Icon(prefixIcon, color: const Color(0xFF9CA3AF), size: 18),
              const SizedBox(width: 10),
              Text(
                hintText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Row(
                children: [
                  Icon(prefixIcon, color: AuthColors.blueNh, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AuthColors.blueNh,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
