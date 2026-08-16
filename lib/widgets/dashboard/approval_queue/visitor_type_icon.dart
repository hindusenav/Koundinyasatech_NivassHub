import 'package:flutter/material.dart';

class VisitorTypeIcon {
  const VisitorTypeIcon._();

  static IconData icon(String type) {
    switch (type.toLowerCase()) {
      case 'delivery':
        return Icons.local_shipping_outlined;

      case 'guest':
        return Icons.person_outline;

      case 'maid':
        return Icons.cleaning_services_outlined;

      case 'cab':
        return Icons.local_taxi_outlined;

      default:
        return Icons.person_outline;
    }
  }
}