import 'package:flutter/material.dart';

import '../../../data/models/address_model.dart';

class AddressDropdown extends StatelessWidget {
  const AddressDropdown({
    super.key,
    required this.addresses,
    required this.selectedAddress,
    required this.onChanged,
  });

  final List<AddressModel> addresses;
  final AddressModel? selectedAddress;
  final ValueChanged<AddressModel?> onChanged;

  @override
  Widget build(BuildContext context) {
    if (addresses.isEmpty) {
      return const SizedBox.shrink();
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton<AddressModel>(
        value: selectedAddress,
        isDense: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 15,
          color: Color(0xFF333333),
        ),
        items: addresses.map((address) {
          return DropdownMenuItem<AddressModel>(
            value: address,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.societyName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  address.flatNumber,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}