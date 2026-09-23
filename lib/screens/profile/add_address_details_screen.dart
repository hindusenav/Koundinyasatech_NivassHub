import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/models/profile/address_model.dart';
import 'package:flutter_nivasshub/providers/profile/profile_provider.dart';

class AddAddressDetailsScreen extends StatefulWidget {
  final AddressModel? address;

  const AddAddressDetailsScreen({
    super.key,
    this.address,
  });

  @override
  State<AddAddressDetailsScreen> createState() =>
      _AddAddressDetailsScreenState();
}

class _AddAddressDetailsScreenState
    extends State<AddAddressDetailsScreen> {
  // ============================================================
  // FIGMA COLORS
  // ============================================================

  static const Color _primaryBlue = Color(0xFF2167A5);

  // Header blue
  static const Color _headerBlue = Color(0xFFD4E4F4);

  static const Color _screenBackground = Color(0xFFF3F6FA);

  static const Color _textDark = Color(0xFF263747);

  static const Color _labelColor = Color(0xFF344454);

  static const Color _hintColor = Color(0xFF9AA6B2);

  static const Color _borderColor = Color(0xFFD6DDE5);

  // ============================================================
  // CONTROLLERS
  // ============================================================

  late TextEditingController _flatController;
  late TextEditingController _societyController;
  late TextEditingController _wingController;
  late TextEditingController _streetController;
  late TextEditingController _areaController;
  late TextEditingController _landmarkController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pinController;

  @override
  void initState() {
    super.initState();

    final address = widget.address;

    _flatController = TextEditingController(
      text: address?.flatNo ?? '',
    );

    _societyController = TextEditingController(
      text: address?.societyName ?? '',
    );

    _wingController = TextEditingController(
      text: address?.wing ?? '',
    );

    _streetController = TextEditingController(
      text: address?.street ?? '',
    );

    _areaController = TextEditingController(
      text: address?.area ?? '',
    );

    _landmarkController = TextEditingController(
      text: address?.landmark ?? '',
    );

    _cityController = TextEditingController(
      text: address?.city ?? '',
    );

    _stateController = TextEditingController(
      text: address?.state ?? '',
    );

    _pinController = TextEditingController(
      text: address?.pinCode ?? '',
    );
  }

  @override
  void dispose() {
    _flatController.dispose();
    _societyController.dispose();
    _wingController.dispose();
    _streetController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinController.dispose();

    super.dispose();
  }

  // ============================================================
  // SAVE ADDRESS
  // ============================================================

  void _saveAddress() {
    final address = AddressModel(
      flatNo: _flatController.text.trim(),
      societyName: _societyController.text.trim(),
      wing: _wingController.text.trim(),
      street: _streetController.text.trim(),
      area: _areaController.text.trim(),
      landmark: _landmarkController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      pinCode: _pinController.text.trim(),
    );

    context.read<ProfileProvider>().updateAddress(address);

    Navigator.pop(context);
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive width without making the design too large/small
    final scale = (screenWidth / 360).clamp(0.88, 1.0);

    // ============================================================
    // DYNAMIC FIELD LIST
    // ============================================================

final fields = <_AddressFieldData>[
  _AddressFieldData(
    label: 'Flat/House No.',
    hint: 'B-402',
    iconPath: 'assets/icons/profile/address(profile).png',
    controller: _flatController,
  ),

  _AddressFieldData(
    label: 'Society/Building Name',
    hint: 'Golden Residence',
    iconPath: 'assets/icons/profile/block.png',
    controller: _societyController,
  ),

  _AddressFieldData(
    label: 'Wing/Tower',
    hint: 'Tower B',
    iconPath: 'assets/icons/profile/wing(addaddress).png',
    controller: _wingController,
  ),

  _AddressFieldData(
    label: 'Street/Lane',
    hint: 'MG Road',
    iconPath: 'assets/icons/profile/street(addaddress).png',
    controller: _streetController,
  ),

  _AddressFieldData(
    label: 'Area/Locality',
    hint: 'Andheri West',
    iconPath: 'assets/icons/profile/area(addaddress).png',
    controller: _areaController,
  ),

  _AddressFieldData(
    label: 'Landmark',
    hint: 'Near City Mall',
    iconPath: 'assets/icons/profile/landmark(addaddress).png',
    controller: _landmarkController,
  ),

  _AddressFieldData(
    label: 'City',
    hint: 'Mumbai',
    iconPath: 'assets/icons/profile/block.png',
    controller: _cityController,
  ),

  _AddressFieldData(
    label: 'State',
    hint: 'Maharashtra',
    iconPath: 'assets/icons/profile/street(addaddress).png',
    controller: _stateController,
  ),

  _AddressFieldData(
    label: 'PIN Code',
    hint: '400053',
    iconPath: 'assets/icons/profile/area(addaddress).png',
    controller: _pinController,
    keyboardType: TextInputType.number,
  ),
];
    return Scaffold(
      backgroundColor: _screenBackground,

      // ============================================================
      // HEADER
      // ============================================================

      appBar: AppBar(
        automaticallyImplyLeading: false,

        backgroundColor: _headerBlue,

        elevation: 0,

        scrolledUnderElevation: 0,

        toolbarHeight: 74 * scale,

        titleSpacing: 0,

        title: Row(
          children: [
            SizedBox(width: 10 * scale),

            IconButton(
              splashRadius: 20,

              onPressed: () {
                Navigator.pop(context);
              },

              icon: Icon(
                Icons.arrow_back,
                size: 21 * scale,
                color: _textDark,
              ),
            ),

            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 42 * scale,
                  ),
                  child: Text(
                    'Add Address Details',

                    style: TextStyle(
                      color: _textDark,
                      fontSize: 15 * scale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ============================================================
      // BODY
      // ============================================================

      body: SafeArea(
        top: false,

        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),

                padding: EdgeInsets.fromLTRB(
                  16 * scale,
                  16 * scale,
                  16 * scale,
                  10 * scale,
                ),

                child: Container(
                  width: double.infinity,

                  padding: EdgeInsets.fromLTRB(
                    12 * scale,
                    14 * scale,
                    12 * scale,
                    14 * scale,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(
                      16 * scale,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),

                  child: Column(
                    children: List.generate(
                      fields.length,
                      (index) {
                        final field = fields[index];

                        return _buildAddressField(
                          field: field,
                          scale: scale,
                          isLast: index == fields.length - 1,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // ======================================================
            // BOTTOM BUTTONS
            // ======================================================

            _buildBottomButtons(scale),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ADDRESS FIELD
  // ============================================================

  Widget _buildAddressField({
    required _AddressFieldData field,
    required double scale,
    required bool isLast,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : 11 * scale,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ========================================================
          // LABEL + ICON
          // ========================================================

          Padding(
            padding: EdgeInsets.only(
              left: 1 * scale,
              bottom: 6 * scale,
            ),

            child: Row(
              children: [
                SizedBox(
                  width: 17 * scale,
                  height: 17 * scale,

                  child: Image.asset(
                    field.iconPath,

                    width: 15 * scale,
                    height: 15 * scale,

                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(width: 8 * scale),

                Text(
                  field.label,

                  style: TextStyle(
                    color: _labelColor,
                    fontSize: 12.5 * scale,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // ========================================================
          // TEXT FIELD
          // ========================================================

          SizedBox(
            height: 39 * scale,

            child: TextFormField(
              controller: field.controller,

              keyboardType: field.keyboardType,

              style: TextStyle(
                color: _textDark,
                fontSize: 12 * scale,
                fontWeight: FontWeight.w400,
              ),

              cursorColor: _primaryBlue,

              decoration: InputDecoration(
                hintText: field.hint,

                hintStyle: TextStyle(
                  color: _hintColor,
                  fontSize: 12 * scale,
                  fontWeight: FontWeight.w400,
                ),

                filled: true,

                fillColor: const Color(0xFFFCFDFE),

                contentPadding: EdgeInsets.symmetric(
                  horizontal: 11 * scale,
                  vertical: 0,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    8 * scale,
                  ),

                  borderSide: const BorderSide(
                    color: _borderColor,
                    width: 1,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    8 * scale,
                  ),

                  borderSide: const BorderSide(
                    color: _primaryBlue,
                    width: 1.2,
                  ),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    8 * scale,
                  ),

                  borderSide: const BorderSide(
                    color: _borderColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM BUTTONS
  // ============================================================

  Widget _buildBottomButtons(double scale) {
    return Container(
      width: double.infinity,

      color: _screenBackground,

      padding: EdgeInsets.fromLTRB(
        16 * scale,
        8 * scale,
        16 * scale,
        18 * scale,
      ),

      child: Row(
        children: [
          // ========================================================
          // SAVE
          // ========================================================

          Expanded(
            child: SizedBox(
              height: 46 * scale,

              child: ElevatedButton(
                onPressed: _saveAddress,

                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryBlue,

                  foregroundColor: Colors.white,

                  elevation: 3,

                  shadowColor:
                      Colors.black.withValues(alpha: 0.18),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      8 * scale,
                    ),
                  ),
                ),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    Icon(
                      Icons.save_outlined,
                      size: 15 * scale,
                    ),

                    SizedBox(width: 6 * scale),

                    Text(
                      'Save',

                      style: TextStyle(
                        fontSize: 13 * scale,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(width: 8 * scale),

          // ========================================================
          // CANCEL
          // FIGMA = BLUE BUTTON
          // ========================================================

          Expanded(
            child: SizedBox(
              height: 46 * scale,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryBlue,

                  foregroundColor: Colors.white,

                  elevation: 3,

                  shadowColor:
                      Colors.black.withValues(alpha: 0.18),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      8 * scale,
                    ),
                  ),
                ),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    Icon(
                      Icons.close,
                      size: 16 * scale,
                    ),

                    SizedBox(width: 6 * scale),

                    Text(
                      'Cancel',

                      style: TextStyle(
                        fontSize: 13 * scale,
                        fontWeight: FontWeight.w600,
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
}

// ============================================================
// DYNAMIC FIELD DATA MODEL
// ============================================================

class _AddressFieldData {
  final String label;
  final String hint;
  final String iconPath;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  _AddressFieldData({
    required this.label,
    required this.hint,
    required this.iconPath,
    required this.controller,
    this.keyboardType,
  });
}