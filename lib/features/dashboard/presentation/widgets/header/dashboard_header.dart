import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_provider.dart';
import 'address_dropdown.dart';
import 'notification_icon.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    final addresses = provider.addresses;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: addresses.isEmpty
                  ? const Text(
                      'Select Address',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    )
                  : AddressDropdown(
                      addresses: addresses,
                      selectedAddress: addresses.firstWhere(
                        (e) => e.isDefault,
                        orElse: () => addresses.first,
                      ),
                      onChanged: (_) {
                        // Will connect in Step 7.3
                      },
                    ),
            ),
            const SizedBox(width: 12),
            const NotificationIcon(
              count: 3,
            ),
          ],
        ),
      ),
    );
  }
}