import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/address_model.dart';
// Import your model file path here:
// import 'address_model.dart'; 

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  // All 9 Controllers matching AddressModel
  final flatNoCtrl = TextEditingController();
  final societyCtrl = TextEditingController();
  final wingCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final areaCtrl = TextEditingController();
  final landmarkCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final pinCtrl = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAddress();
  }

  @override
  void dispose() {
    flatNoCtrl.dispose();
    societyCtrl.dispose();
    wingCtrl.dispose();
    streetCtrl.dispose();
    areaCtrl.dispose();
    landmarkCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    pinCtrl.dispose();
    super.dispose();
  }

  // ✅ LOAD FROM LOCAL ASSET JSON
  Future<void> fetchAddress() async {
    try {
      final String response = await rootBundle.loadString('assets/json/address.json');
      final Map<String, dynamic> decoded = jsonDecode(response);

      // Handle both direct JSON object or wrapped {"data": {...}}
      final jsonMap = decoded.containsKey('data') ? decoded['data'] : decoded;
      final address = AddressModel.fromJson(jsonMap);

      if (mounted) {
        setState(() {
          flatNoCtrl.text = address.flatNo;
          societyCtrl.text = address.society;
          wingCtrl.text = address.wing;
          streetCtrl.text = address.street;
          areaCtrl.text = address.area;
          landmarkCtrl.text = address.landmark;
          cityCtrl.text = address.city;
          stateCtrl.text = address.state;
          pinCtrl.text = address.pincode;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading address asset: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // ✅ SAVE DATA USING MODEL
  void saveAddress() {
    final updatedAddress = AddressModel(
      flatNo: flatNoCtrl.text,
      society: societyCtrl.text,
      wing: wingCtrl.text,
      street: streetCtrl.text,
      area: areaCtrl.text,
      landmark: landmarkCtrl.text,
      city: cityCtrl.text,
      state: stateCtrl.text,
      pincode: pinCtrl.text,
    );

    // Convert model to JSON map
    final Map<String, dynamic> payload = updatedAddress.toJson();
    debugPrint("Saving address data: $payload");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Address Saved Successfully")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0061C3);
    const bgLightBlue = Color(0xFFD6E8FA);

    return Scaffold(
      backgroundColor: bgLightBlue,
      appBar: AppBar(
        backgroundColor: bgLightBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Address Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    // Form Card Container
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildInputField('Flat/House No.', Icons.location_on_outlined, flatNoCtrl),
                          _buildInputField('Society/Building Name', Icons.apartment_outlined, societyCtrl),
                          _buildInputField('Wing/Tower', Icons.grid_view_rounded, wingCtrl),
                          _buildInputField('Street/Lane', Icons.alt_route_rounded, streetCtrl),
                          _buildInputField('Area/Locality', Icons.mail_outline_rounded, areaCtrl),
                          _buildInputField('Landmark', Icons.language_rounded, landmarkCtrl),
                          _buildInputField('City', Icons.location_city_rounded, cityCtrl),
                          _buildInputField('State', Icons.map_outlined, stateCtrl),
                          _buildInputField('PIN Code', Icons.email_outlined, pinCtrl, isNumber: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Bottom Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: saveAddress,
                            icon: const Icon(Icons.assignment_turned_in_outlined, size: 18),
                            label: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, size: 18),
                            label: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInputField(
    String label,
    IconData icon,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    const primaryBlue = Color(0xFF0061C3);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryBlue, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: const TextStyle(
              fontSize: 14,
              color: primaryBlue,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              isDense: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: primaryBlue, width: 1.5),
              ),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ],
      ),
    );
  }
}