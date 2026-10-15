import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';

/// Renders a distinctive landmark / monument line art icon for the
/// 9 major Indian metropolitan cities in the Select City grid.
class CityMonumentIcon extends StatelessWidget {
  const CityMonumentIcon({
    super.key,
    required this.cityName,
    this.size = 32.0,
    this.color = const Color(0xFF94A3B8),
  });

  final String cityName;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final normalized = cityName.trim().toLowerCase();

    IconData fallbackIcon = Icons.location_city_rounded;
    if (normalized.contains('bangalore') || normalized.contains('bengaluru')) {
      fallbackIcon = Icons.account_balance_rounded; // Vidhana Soudha / Assembly
    } else if (normalized.contains('mumbai')) {
      fallbackIcon = Icons.apartment_rounded; // Gateway of India / Metropolis
    } else if (normalized.contains('delhi')) {
      fallbackIcon = Icons.temple_buddhist_rounded; // India Gate / Red Fort
    } else if (normalized.contains('pune')) {
      fallbackIcon = Icons.castle_rounded; // Shaniwar Wada
    } else if (normalized.contains('chennai')) {
      fallbackIcon = Icons.domain_rounded; // Central / Ripon Building
    } else if (normalized.contains('hyderabad')) {
      fallbackIcon = Icons.mosque_rounded; // Charminar
    } else if (normalized.contains('ahmedabad')) {
      fallbackIcon = Icons.temple_hindu_rounded; // Sidi Saiyyed / Heritage
    } else if (normalized.contains('kolkata')) {
      fallbackIcon = Icons.museum_rounded; // Victoria Memorial
    } else if (normalized.contains('kochi')) {
      fallbackIcon = Icons.sailing_rounded; // Backwaters / Chinese Fishing Nets
    }

    return CustomPaint(
      size: Size(size, size),
      painter: _CityMonumentPainter(
        cityName: normalized,
        color: color,
        fallbackIcon: fallbackIcon,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Icon(
            fallbackIcon,
            size: size * 0.75,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _CityMonumentPainter extends CustomPainter {
  const _CityMonumentPainter({
    required this.cityName,
    required this.color,
    required this.fallbackIcon,
  });

  final String cityName;
  final Color color;
  final IconData fallbackIcon;

  @override
  void paint(Canvas canvas, Size size) {
    // Subtle circular background pad behind the monument icon
    final bgPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.45,
      bgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CityMonumentPainter oldDelegate) =>
      oldDelegate.cityName != cityName || oldDelegate.color != color;
}
