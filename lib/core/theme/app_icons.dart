import 'package:flutter/material.dart';

/// Central icon registry. Widgets should reference `AppIcons.xxx` instead of
/// `Icons.xxx` directly, so a design change (e.g. switching an icon set) only
/// touches this file.
class AppIcons {
  AppIcons._();

  // -----------------------------------------------------------------------
  // Navigation / structure
  // -----------------------------------------------------------------------
  static const IconData home = Icons.home_rounded;
  static const IconData dashboard = Icons.dashboard_rounded;
  static const IconData menu = Icons.menu_rounded;
  static const IconData back = Icons.arrow_back_ios_new_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData more = Icons.more_vert_rounded;
  static const IconData arrowForward = Icons.arrow_forward_ios_rounded;
  static const IconData chevronRight = Icons.chevron_right_rounded;
  static const IconData chevronDown = Icons.keyboard_arrow_down_rounded;

  // -----------------------------------------------------------------------
  // Domain — property/society hierarchy
  // -----------------------------------------------------------------------
  static const IconData society = Icons.location_city_rounded;
  static const IconData tower = Icons.apartment_rounded;
  static const IconData unit = Icons.door_front_door_rounded;
  static const IconData resident = Icons.people_alt_rounded;
  static const IconData visitor = Icons.badge_rounded;
  static const IconData complaint = Icons.report_problem_rounded;
  static const IconData notice = Icons.campaign_rounded;
  static const IconData profile = Icons.person_rounded;
  static const IconData settings = Icons.settings_rounded;

  // -----------------------------------------------------------------------
  // Actions
  // -----------------------------------------------------------------------
  static const IconData add = Icons.add_rounded;
  static const IconData edit = Icons.edit_outlined;
  static const IconData delete = Icons.delete_outline_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData filter = Icons.filter_list_rounded;
  static const IconData refresh = Icons.refresh_rounded;
  static const IconData upload = Icons.upload_file_rounded;
  static const IconData download = Icons.download_rounded;
  static const IconData attach = Icons.attach_file_rounded;
  static const IconData camera = Icons.camera_alt_rounded;
  static const IconData share = Icons.share_rounded;
  static const IconData logout = Icons.logout_rounded;
  static const IconData check = Icons.check_rounded;
  static const IconData checkCircle = Icons.check_circle_rounded;

  // -----------------------------------------------------------------------
  // Feedback / status
  // -----------------------------------------------------------------------
  static const IconData warning = Icons.warning_amber_rounded;
  static const IconData error = Icons.error_outline_rounded;
  static const IconData info = Icons.info_outline_rounded;
  static const IconData success = Icons.check_circle_outline_rounded;
  static const IconData empty = Icons.inbox_rounded;
  static const IconData noConnection = Icons.wifi_off_rounded;
  static const IconData shield = Icons.gpp_good_rounded;

  // -----------------------------------------------------------------------
  // Contact / forms
  // -----------------------------------------------------------------------
  static const IconData phone = Icons.phone_rounded;
  static const IconData email = Icons.email_outlined;
  static const IconData location = Icons.location_on_outlined;
  static const IconData calendar = Icons.calendar_today_rounded;
  static const IconData clock = Icons.access_time_rounded;
  static const IconData lock = Icons.lock_outline_rounded;
  static const IconData visibilityOn = Icons.visibility_rounded;
  static const IconData visibilityOff = Icons.visibility_off_rounded;
  static const IconData notification = Icons.notifications_none_rounded;

  // -----------------------------------------------------------------------
  // Custom asset icons (SVG/PNG under assets/icons/)
  // -----------------------------------------------------------------------
  // Register paths here once custom icon assets are added, e.g.:
  // static const String customLogo = 'assets/icons/logo.svg';
}
