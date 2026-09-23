import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Where a Figma-exported SVG for a Quick Actions icon lives, and whether it
/// should be tinted to the caller's color.
///
/// [tinted] defaults to true, matching today's single-color
/// `Icon(..., color: ...)` behavior. Set it to false only for an icon that is
/// intentionally flat/multi-color in Figma — a [ColorFilter] would wrongly
/// flatten that kind of icon to a silhouette.
class _SvgIconSpec {
  // Every current registry entry below is a single-color outline export
  // (stroke="#3E3E3E"), so none pass `tinted: false` explicitly today.
  // ignore: unused_element_parameter
  const _SvgIconSpec(this.assetPath, {this.tinted = true});

  final String assetPath;
  final bool tinted;
}

/// Maps an [AppFeatureModel.iconKey] to a Material icon. Central lookup so
/// the Quick Actions grid and Search results always render the same icon for
/// the same feature. Unrecognized keys fall back to a generic grid icon
/// rather than crashing.
class AppFeatureIcons {
  AppFeatureIcons._();

  /// Figma-exported SVG registry, keyed by iconKey. Every icon here renders
  /// via [iconWidget] from the exact asset in `assets/icons/quick_actions/`
  /// instead of the Material fallback below. Add a new line the same way
  /// for any further icon (filename = iconKey, e.g. `invite_guest.svg`).
  static const Map<String, _SvgIconSpec> _svgIcons = {
    'manage_devices': _SvgIconSpec('assets/icons/quick_actions/manage_devices.svg'),
    'nivaas_hub_locks': _SvgIconSpec('assets/icons/quick_actions/nivaas_hub_locks.svg'),
    'invite_guest': _SvgIconSpec('assets/icons/quick_actions/invite_guest.svg'),
    'cab_auto': _SvgIconSpec('assets/icons/quick_actions/cab_auto.svg'),
    'allow_delivery': _SvgIconSpec('assets/icons/quick_actions/allow_delivery.svg'),
    'visiting_help': _SvgIconSpec('assets/icons/quick_actions/visiting_help.svg'),
    'call_security': _SvgIconSpec('assets/icons/quick_actions/call_security.svg'),
    'message_guard': _SvgIconSpec('assets/icons/quick_actions/message_guard.svg'),
    'my_passes': _SvgIconSpec('assets/icons/quick_actions/my_passes.svg'),
    'allow_kid_exit': _SvgIconSpec('assets/icons/quick_actions/allow_kid_exit.svg'),
    'residents': _SvgIconSpec('assets/icons/quick_actions/residents.svg'),
    'search_vehicle': _SvgIconSpec('assets/icons/quick_actions/search_vehicle.svg'),
    'daily_help': _SvgIconSpec('assets/icons/quick_actions/daily_help.svg'),
    'amenities': _SvgIconSpec('assets/icons/quick_actions/amenities.svg'),
  };

  /// Preferred call-site API: renders the registered Figma SVG for [key] if
  /// present, otherwise falls back to `Icon(icon(key), ...)`. With no
  /// entries registered, output is identical to the plain [icon] lookup.
  ///
  /// The SVG is always constrained to exactly [size] x [size] (via
  /// `BoxFit.contain`), so a non-square export is letterboxed rather than
  /// resizing its box — layout can never shift once real assets land.
  static Widget iconWidget(String key, {required double size, required Color color}) {
    final spec = _svgIcons[key];
    if (spec == null) {
      return Icon(icon(key), size: size, color: color);
    }
    return SvgPicture.asset(
      spec.assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter: spec.tinted ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

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
