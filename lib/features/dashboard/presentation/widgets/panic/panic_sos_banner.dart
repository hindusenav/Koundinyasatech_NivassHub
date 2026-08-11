import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_provider.dart';

class PanicSosBanner extends StatelessWidget {
  const PanicSosBanner({super.key});

  Future<void> _handleTap(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final provider = context.read<DashboardProvider>();

    try {
      await provider.triggerSos(latitude: 0.0, longitude: 0.0);
      messenger.showSnackBar(
        const SnackBar(content: Text('SOS alert triggered successfully')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to trigger SOS: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: const Color(0xFFEF4444),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _handleTap(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_active_outlined,
                    color: Color(0xFFEF4444),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Slide for PANIC/SOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Loud Alarm & Alerts will be triggered',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
