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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryBlue = Color(0xFF0878D1);
  static const Color headerBlue = Color(0xFFC8E3FC);
  static const Color backgroundBlue = Color(0xFFF3F7FD);

  static const Color labelColor = Color(0xFF202124);
  static const Color valueColor = Color(0xFF29496F);

  static const Color borderColor = Color(0xFFD9DEE4);

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

  // ============================================================
  // INIT
  // ============================================================

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

  // ============================================================
  // DISPOSE
  // ============================================================

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
  // SAVE
  // ============================================================

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedAddress = AddressModel(
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

    context
        .read<ProfileProvider>()
        .updateAddress(updatedAddress);

    Navigator.pop(context);
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    /*
      Reference width is approximately 320px.

      This keeps the UI compact on mobile while allowing
      reasonable scaling on larger devices.
    */
    final double scale =
        (screenWidth / 320).clamp(0.95, 1.08);

    return Scaffold(
      backgroundColor: backgroundBlue,

      // ========================================================
      // HEADER
      // ========================================================

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: headerBlue,
          elevation: 0,
          scrolledUnderElevation: 0,

          leading: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          centerTitle: true,

          title: Text(
            'Add Address Details',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14 * scale,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            physics:
                const ClampingScrollPhysics(),

            padding: EdgeInsets.fromLTRB(
              13 * scale,
              10 * scale,
              13 * scale,
              5 * scale,
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

                borderRadius:
                    BorderRadius.circular(
                  13 * scale,
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.08,
                    ),
                    blurRadius: 5,
                    offset:
                        const Offset(0, 2),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  // ==================================================
                  // 1. FLAT / HOUSE
                  // ==================================================

                  _addressField(
                    scale: scale,
                    icon: Icons.home_outlined,
                    label: 'Flat/House No.',
                    hint: 'B-402',
                    controller: _flatController,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter Flat/House No.';
                      }

                      return null;
                    },
                  ),

                  // ==================================================
                  // 2. SOCIETY
                  // ==================================================

                  _addressField(
                    scale: scale,
                    icon: Icons.business_outlined,
                    label:
                        'Society/Building Name',
                    hint: 'Golden Residence',
                    controller:
                        _societyController,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return
                            'Please enter Society/Building Name';
                      }

                      return null;
                    },
                  ),

                  // ==================================================
                  // 3. WING
                  // ==================================================

                  _addressField(
                    scale: scale,
                    icon:
                        Icons.location_city_outlined,
                    label: 'Wing/Tower',
                    hint: 'Tower B',
                    controller: _wingController,
                  ),

                  // ==================================================
                  // 4. STREET
                  // ==================================================

                  _addressField(
                    scale: scale,
                    icon: Icons.map_outlined,
                    label: 'Street/Lane',
                    hint: 'MG Road',
                    controller:
                        _streetController,
                  ),

                  // ==================================================
                  // 5. AREA
                  // ==================================================

                  _addressField(
                    scale: scale,
                    icon: Icons.mail_outline,
                    label: 'Area/Locality',
                    hint: 'Andheri West',
                    controller:
                        _areaController,
                  ),

                  // ==================================================
                  // 6. LANDMARK
                  // ==================================================

                  _addressField(
                    scale: scale,
                    icon:
                        Icons.language_outlined,
                    label: 'Landmark',
                    hint: 'Near City Mall',
                    controller:
                        _landmarkController,
                  ),

                  // ==================================================
                  // 7. CITY
                  // ==================================================

                  _addressField(
                    scale: scale,
                    icon:
                        Icons.location_city_outlined,
                    label: 'City',
                    hint: 'Mumbai',
                    controller: _cityController,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter City';
                      }

                      return null;
                    },
                  ),

                  // ==================================================
                  // 8. STATE
                  // ==================================================

                  _addressField(
                    scale: scale,
                    icon: Icons.map_outlined,
                    label: 'State',
                    hint: 'Maharashtra',
                    controller:
                        _stateController,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter State';
                      }

                      return null;
                    },
                  ),

                  // ==================================================
                  // 9. PIN
                  // ==================================================

                  _addressField(
                    scale: scale,
                    icon: Icons.mail_outline,
                    label: 'PIN Code',
                    hint: '400053',
                    controller: _pinController,
                    keyboardType:
                        TextInputType.number,
                    isLast: true,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter PIN Code';
                      }

                      if (value.trim().length != 6) {
                        return
                            'PIN Code must be 6 digits';
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // ========================================================
      // BOTTOM BUTTONS
      // ========================================================

      bottomNavigationBar: SafeArea(
        top: false,

        child: Container(
          color: backgroundBlue,

          padding: EdgeInsets.fromLTRB(
            13 * scale,
            7 * scale,
            13 * scale,
            10 * scale,
          ),

          child: Row(
            children: [
              // ==================================================
              // SAVE
              // ==================================================

              Expanded(
                child: SizedBox(
                  height: 43 * scale,

                  child: ElevatedButton(
                    onPressed: _saveAddress,

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          primaryBlue,
                      foregroundColor:
                          Colors.white,
                      elevation: 0,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          8 * scale,
                        ),
                      ),

                      padding: EdgeInsets.zero,
                    ),

                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                      children: [
                        Icon(
                          Icons.save_outlined,
                          size: 15 * scale,
                        ),

                        SizedBox(
                          width: 5 * scale,
                        ),

                        Text(
                          'Save',
                          style: TextStyle(
                            fontSize:
                                13 * scale,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: 7 * scale,
              ),

              // ==================================================
              // CANCEL
              // ==================================================

              Expanded(
                child: SizedBox(
                  height: 43 * scale,

                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    style:
                        OutlinedButton.styleFrom(
                      backgroundColor:
                          Colors.white,

                      foregroundColor:
                          primaryBlue,

                      side:
                          const BorderSide(
                        color: primaryBlue,
                        width: 1,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          8 * scale,
                        ),
                      ),

                      padding: EdgeInsets.zero,
                    ),

                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                      children: [
                        Icon(
                          Icons.close,
                          size: 15 * scale,
                        ),

                        SizedBox(
                          width: 5 * scale,
                        ),

                        Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize:
                                13 * scale,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ADDRESS FIELD
  // ============================================================

  Widget _addressField({
    required double scale,
    required IconData icon,
    required String label,
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom:
            isLast ? 0 : 10 * scale,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ======================================================
          // LABEL
          // ======================================================

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,

            children: [
              Icon(
                icon,
                color: primaryBlue,
                size: 16 * scale,
              ),

              SizedBox(
                width: 7 * scale,
              ),

              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: labelColor,
                    fontSize:
                        13 * scale,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 5 * scale,
          ),

          // ======================================================
          // TEXT FIELD
          // ======================================================

          SizedBox(
            height: 38 * scale,

            child: TextFormField(
              controller: controller,

              keyboardType:
                  keyboardType,

              validator: validator,

              textAlignVertical:
                  TextAlignVertical.center,

              style: TextStyle(
                color: valueColor,
                fontSize:
                    12 * scale,
                fontWeight:
                    FontWeight.w400,
              ),

              cursorColor:
                  primaryBlue,

              decoration:
                  InputDecoration(
                hintText: hint,

                hintStyle:
                    TextStyle(
                  color:
                      const Color(
                    0xFFB5B9BE,
                  ),
                  fontSize:
                      12 * scale,
                  fontWeight:
                      FontWeight.w400,
                ),

                filled: true,

                fillColor:
                    Colors.white,

                contentPadding:
                    EdgeInsets.symmetric(
                  horizontal:
                      11 * scale,
                  vertical: 0,
                ),

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    7 * scale,
                  ),

                  borderSide:
                      const BorderSide(
                    color:
                        borderColor,
                    width: 0.8,
                  ),
                ),

                enabledBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    7 * scale,
                  ),

                  borderSide:
                      const BorderSide(
                    color:
                        borderColor,
                    width: 0.8,
                  ),
                ),

                focusedBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    7 * scale,
                  ),

                  borderSide:
                      const BorderSide(
                    color:
                        primaryBlue,
                    width: 1.2,
                  ),
                ),

                errorBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    7 * scale,
                  ),

                  borderSide:
                      const BorderSide(
                    color: Colors.red,
                    width: 0.8,
                  ),
                ),

                focusedErrorBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    7 * scale,
                  ),

                  borderSide:
                      const BorderSide(
                    color: Colors.red,
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}