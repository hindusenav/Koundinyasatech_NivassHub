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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _handleTap,
          child: Container(
            height: 73,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
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
                // Panic Icon Container (48px x 48px circle with red siren beacon icon)
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x20000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(28, 28),
                      painter: _SirenBeaconPainter(
                        color: const Color(0xFFEE1E1A),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Panic Alert Text Container (Vertical column, 4px gap, 46px height)
                const Expanded(
                  child: SizedBox(
                    height: 46,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Slide for PANIC/SOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            height: 1.0,
                            letterSpacing: 0,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Loud Alarm & Alerts will be triggered',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Panic Alert Arrow Icon (Width: 42.67px, Height: 24px)
                SizedBox(
                  width: 42.67,
                  height: 24,
                  child: Center(
                    child: CustomPaint(
                      size: const Size(28, 18),
                      painter: _RightArrowPainter(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SirenBeaconPainter extends CustomPainter {
  final Color color;

  _SirenBeaconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2 + 3;

    // Base horizontal bar
    canvas.drawLine(
      Offset(cx - 9, cy + 5),
      Offset(cx + 9, cy + 5),
      paint,
    );

    // Siren Light Dome
    final path = Path()
      ..moveTo(cx - 6, cy + 5)
      ..lineTo(cx - 4, cy - 2)
      ..quadraticBezierTo(cx - 3, cy - 6, cx, cy - 6)
      ..quadraticBezierTo(cx + 3, cy - 6, cx + 4, cy - 2)
      ..lineTo(cx + 6, cy + 5);
    canvas.drawPath(path, paint);

    // 5 Radiating Rays
    // Top vertical ray
    canvas.drawLine(
      Offset(cx, cy - 9),
      Offset(cx, cy - 13),
      paint,
    );
    // Top-Left diagonal ray
    canvas.drawLine(
      Offset(cx - 6, cy - 7),
      Offset(cx - 10, cy - 11),
      paint,
    );
    // Top-Right diagonal ray
    canvas.drawLine(
      Offset(cx + 6, cy - 7),
      Offset(cx + 10, cy - 11),
      paint,
    );
    // Left horizontal ray
    canvas.drawLine(
      Offset(cx - 9, cy),
      Offset(cx - 13, cy),
      paint,
    );
    // Right horizontal ray
    canvas.drawLine(
      Offset(cx + 9, cy),
      Offset(cx + 13, cy),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _SirenBeaconPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _RightArrowPainter extends CustomPainter {
  final Color color;

  _RightArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cy = size.height / 2;

    // Main horizontal stem
    canvas.drawLine(
      Offset(2, cy),
      Offset(size.width - 2, cy),
      paint,
    );

    // Top diagonal ray of V-head
    canvas.drawLine(
      Offset(size.width - 2, cy),
      Offset(size.width - 10, cy - 7),
      paint,
    );

    // Bottom diagonal ray of V-head
    canvas.drawLine(
      Offset(size.width - 2, cy),
      Offset(size.width - 10, cy + 7),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RightArrowPainter oldDelegate) =>
      oldDelegate.color != color;
}