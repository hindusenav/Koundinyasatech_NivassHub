import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final houseCtrl = TextEditingController();
  final buildingCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final pinCtrl = TextEditingController();

  final String baseUrl = "https://yourapi.com/api/address";

  @override
  void initState() {
    super.initState();
    fetchAddress(); // 🔥 API CALL
  }

  // ✅ GET API
  Future<void> fetchAddress() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        setState(() {
          houseCtrl.text = data['house'] ?? '';
          buildingCtrl.text = data['building'] ?? '';
          cityCtrl.text = data['city'] ?? '';
          stateCtrl.text = data['state'] ?? '';
          pinCtrl.text = data['pin'] ?? '';
        });
      }
    } catch (e) {
      print("Error fetching: $e");
    }
  }

  // ✅ POST API
  Future<void> saveAddress() async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "house": houseCtrl.text,
          "building": buildingCtrl.text,
          "city": cityCtrl.text,
          "state": stateCtrl.text,
          "pin": pinCtrl.text,
        }),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Address Saved")),
        );

        Navigator.pop(context); // go back
      } else {
        throw Exception("Failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Address Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: houseCtrl, decoration: const InputDecoration(labelText: "House")),
            TextField(controller: buildingCtrl, decoration: const InputDecoration(labelText: "Building")),
            TextField(controller: cityCtrl, decoration: const InputDecoration(labelText: "City")),
            TextField(controller: stateCtrl, decoration: const InputDecoration(labelText: "State")),
            TextField(
              controller: pinCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "PIN"),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: saveAddress, // 🔥 API SAVE
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}