import 'package:flutter/material.dart';

class QuickActionIconMapper {
  static IconData icon(String name) {
    switch (name.toLowerCase()) {
      case 'preapprove':
      case 'pre-approve':
        return Icons.person_add_alt_outlined;

      case 'payments':
        return Icons.account_balance_wallet_outlined;

      case 'posts':
        return Icons.chat_bubble_outline;

      case 'security':
        return Icons.shield_outlined;

      case 'booknow':
      case 'book now':
        return Icons.event_outlined;

      case 'directory':
        return Icons.menu_book_outlined;

      case 'free trial':
      case 'freetrial':
        return Icons.redeem_outlined;

      case 'view more':
        return Icons.add;

      default:
        return Icons.grid_view_outlined;
    }
  }
}