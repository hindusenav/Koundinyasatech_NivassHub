import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_provider.dart';

class PanicSosBanner extends StatefulWidget {
  const PanicSosBanner({super.key});

  @override
  State<PanicSosBanner> createState() => _PanicSosBannerState();
}

class _PanicSosBannerState extends State<PanicSosBanner> {
  Future<void> _handleTap() async {
    final provider = context.read<DashboardProvider>();

    try {
      await provider.triggerSos(
        latitude: 0.0,
        longitude: 0.0,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SOS alert triggered successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to trigger SOS: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _handleTap,
        child: Container(
          height: 72,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromARGB(255, 238, 30, 26),
                Color(0xFFFF3B30),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withValues(alpha: 0.20),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 🔴 LEFT ICON (🔥 MUCH BIGGER)
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SizedBox(
                    width: 45, // 🔥 increased
                    height: 45,
                    child: Image.asset(
                      'assets/icons/arrow_icon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// 📝 TEXT
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Slide for PANIC / SOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Loud alarm & emergency alerts will be triggered',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              /// 🔴 RIGHT ICON (🔥 MUCH BIGGER)
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(249, 229, 36, 36),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SizedBox(
                    width: 40, // 🔥 increased
                    height: 40,
                    child: Image.asset(
                      'assets/icons/panic_icon.png',
                      fit: BoxFit.contain,
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
}