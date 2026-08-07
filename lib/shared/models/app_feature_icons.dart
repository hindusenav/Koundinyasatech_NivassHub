import 'package:flutter/material.dart';

/// Maps an [AppFeatureModel.iconKey] to a Material icon. Central lookup so
/// the Quick Actions grid and Search results always render the same icon for
/// the same feature. Unrecognized keys fall back to a generic grid icon
/// rather than crashing.
class AppFeatureIcons {
  AppFeatureIcons._();

  static IconData icon(String key) {
    switch (key) {
      case 'manage_devices':
        return Icons.devices_other_outlined;
      case 'nivaas_hub_locks':
        return Icons.lock_outline_rounded;
      case 'invite_guest':
        return Icons.person_add_alt_outlined;
      case 'cab_auto':
        return Icons.local_taxi_outlined;
      case 'allow_delivery':
        return Icons.local_shipping_outlined;
      case 'visiting_help':
        return Icons.emoji_people_outlined;
      case 'call_security':
        return Icons.support_agent_outlined;
      case 'message_guard':
        return Icons.chat_bubble_outline;
      case 'my_passes':
        return Icons.badge_outlined;
      case 'allow_kid_exit':
        return Icons.child_care_outlined;
      case 'residents':
        return Icons.groups_outlined;
      case 'search_vehicle':
        return Icons.directions_car_filled_outlined;
      case 'daily_help':
        return Icons.home_repair_service_outlined;
      case 'amenities':
        return Icons.pool_outlined;
      case 'create_post':
        return Icons.edit_note_outlined;
      case 'create_poll':
        return Icons.poll_outlined;
      case 'host_event':
        return Icons.event_outlined;
      case 'my_posts':
        return Icons.article_outlined;
      case 'find_homes':
        return Icons.home_work_outlined;
      case 'my_listings':
        return Icons.list_alt_outlined;
      case 'create_listing':
        return Icons.add_circle_outline;
      case 'my_family':
        return Icons.family_restroom_outlined;
      case 'my_daily_help':
        return Icons.cleaning_services_outlined;
      case 'home_planner':
        return Icons.event_note_outlined;
      case 'my_vehicles':
        return Icons.directions_car_outlined;
      case 'test_notifications':
        return Icons.notifications_active_outlined;
      case 'my_flat':
        return Icons.home_outlined;
      case 'my_plans':
        return Icons.workspace_premium_outlined;
      case 'help_support':
        return Icons.help_outline_rounded;
      case 'society_dues':
        return Icons.receipt_long_outlined;
      case 'visitor_pre_approve':
        return Icons.verified_user_outlined;
      case 'resident_directory':
        return Icons.menu_book_outlined;
      case 'services':
        return Icons.miscellaneous_services_outlined;
      case 'parcel':
        return Icons.inventory_2_outlined;
      case 'others':
        return Icons.more_horiz_outlined;
      default:
        return Icons.apps_outlined;
    }
  }
}
