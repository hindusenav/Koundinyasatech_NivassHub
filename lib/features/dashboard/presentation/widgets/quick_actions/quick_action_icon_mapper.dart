import 'package:flutter/material.dart';

class QuickActionIconMapper {
  const QuickActionIconMapper._();

  static IconData icon(String value) {
    switch (value.toLowerCase()) {
      case 'preapprove':
        return Icons.person_add_alt_1_outlined;

      case 'payments':
        return Icons.account_balance_wallet_outlined;

      case 'pass':
      case 'posts':
        return Icons.chat_bubble_outline;

      case 'security':
        return Icons.shield_outlined;

      case 'book':
        return Icons.campaign_outlined;

      case 'buysell':
      case 'directory':
        return Icons.phone_android_outlined;

      case 'gift':
        return Icons.card_giftcard_outlined;

      case 'plus':
        return Icons.add;

      default:
        return Icons.apps_outlined;
    }
  }
}