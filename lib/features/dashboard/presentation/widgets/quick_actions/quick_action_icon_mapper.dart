import 'package:flutter/material.dart';

class QuickActionIconMapper {
  const QuickActionIconMapper._();

  static IconData icon(String value) {
    // Normalizing string: removing spaces, underscores, hyphens to avoid key mismatches
    final key = value.toLowerCase().replaceAll(RegExp(r'[\s_\-]'), '');

    switch (key) {
      // --- Top Devices & Locks ---
      case 'managedevices':
        return Icons.smartphone_outlined;
      case 'nivasahublocks':
      case 'hublocks':
        return Icons.lock_outline;

      // --- Visitors & Security ---
      case 'inviteguest':
      case 'guest':
        return Icons.person_outline;
      case 'cabauto':
      case 'cab':
      case 'auto':
        return Icons.directions_car_outlined;
      case 'allowdelivery':
      case 'delivery':
        return Icons.local_shipping_outlined;
      case 'visitinghelp':
        return Icons.build_outlined;
      case 'callsecurity':
        return Icons.phone_outlined;
      case 'messageguard':
        return Icons.mail_outline;
      case 'mypasses':
      case 'passes':
        return Icons.badge_outlined;
      case 'allowkidexit':
      case 'kidexit':
        return Icons.sentiment_satisfied_alt_outlined;

      // --- Community ---
      case 'residents':
        return Icons.people_outline;
      case 'searchvehicle':
        return Icons.directions_car_filled_outlined;
      case 'finddailyhelp':
      case 'dailyhelp':
        return Icons.person_search_outlined;
      case 'amenities':
        return Icons.cancel_outlined;

      // --- Feed ---
      case 'createpost':
        return Icons.grid_view_outlined;
      case 'createpoll':
        return Icons.poll_outlined;
      case 'hostanevent':
      case 'event':
        return Icons.event_outlined;
      case 'myposts':
      case 'posts':
        return Icons.article_outlined;

      // --- Marketplace ---
      case 'findhomes':
        return Icons.home_outlined;
      case 'mylistings':
        return Icons.list_alt_outlined;
      case 'createlisting':
      case 'plus':
        return Icons.add;

      // --- Household ---
      case 'myfamily':
      case 'family':
        return Icons.groups_outlined;
      case 'mydailyhelp':
        return Icons.person_outline;
      case 'homeplanner':
      case 'planner':
        return Icons.calendar_today_outlined;
      case 'myvehicles':
      case 'vehicles':
        return Icons.directions_car_outlined;

      // --- Settings ---
      case 'testnotific':
      case 'testnotification':
        return Icons.notifications_none_outlined;
      case 'myflat':
        return Icons.crop_portrait_outlined;
      case 'myplans':
      case 'plans':
        return Icons.workspace_premium_outlined;
      case 'help&support':
      case 'helpsupport':
      case 'support':
        return Icons.help_outline;

      // --- Legacy / Extra Fallbacks ---
      case 'preapprove':
        return Icons.verified_user_outlined;
      case 'payments':
        return Icons.account_balance_wallet_outlined;
      case 'security':
        return Icons.security_outlined;
      case 'book':
        return Icons.calendar_month_outlined;
      case 'directory':
        return Icons.menu_book_outlined;

      default:
        return Icons.apps_outlined;
    }
  }
}