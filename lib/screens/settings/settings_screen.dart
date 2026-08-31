import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/providers/auth/auth_provider.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/providers/theme/theme_mode_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';
import 'package:flutter_nivasshub/services/core/secure_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Color backgroundColor =
      Color(0xFFF3F7FD);

  static const Color headerColor =
      Color(0xFFC7E1FB);

  static const Color primaryBlue =
      Color(0xFF0878D1);

  static const Color darkText =
      Color(0xFF17191C);

  static const Color greyText =
      Color(0xFF858585);

  static const Color borderColor =
      Color(0xFFE3E7EB);

  static const String settingsPath =
      'assets/icons/settings';

  static const String instaHelp =
      '$settingsPath/instahelp.png';

  static const String family =
      '$settingsPath/user.png';

  static const String dailyHelp =
      '$settingsPath/dailyhelp.png';

  static const String vehicles =
      '$settingsPath/vehicles.png';

  static const String pets =
      '$settingsPath/pets.png';

  static const String notifications =
      '$settingsPath/notifications.png';

  static const String security =
      '$settingsPath/security.png';

  static const String feed =
      '$settingsPath/feed.png';

  // ... complete remaining code is in the file above
}