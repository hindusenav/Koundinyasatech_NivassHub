import 'package:flutter/material.dart';

class QuickActionIconMapper {
  const QuickActionIconMapper._();

  static IconData icon(String value) {
    switch (value.toLowerCase()) {
      case 'preapprove':
        return Icons.verified_user_outlined;

      case 'payments':
        return Icons.account_balance_wallet_outlined;

      case 'posts':
        return Icons.article_outlined;

      case 'security':
        return Icons.security_outlined;

      case 'book':
        return Icons.calendar_month_outlined;

      case 'directory':
        return Icons.menu_book_outlined;

      case 'gift':
        return Icons.card_giftcard_outlined;

      case 'plus':
        return Icons.add_circle_outline;

      default:
        return Icons.apps_outlined;
    }
  }
}