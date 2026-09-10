import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/providers/auth/auth_provider.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/providers/theme/theme_mode_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ------------------------------------------------------------
  // COLORS
  // ------------------------------------------------------------

  static const blue = Color(0xFF0878D1);
  static const lightBlue = Color(0xFFEAF5FF);
  static const backgroundBlue = Color(0xFFF3F9FF);
  static const headerBlue = Color(0xFFDDF0FF);

  static const orange = Color(0xFFFF9800);
  static const notificationOrange = Color(0xFFFF8A00);
  static const green = Color(0xFF22A447);
  static const red = Color(0xFFE53935);

  // ------------------------------------------------------------
  // STATE
  // ------------------------------------------------------------

  int familyCount = 1;
  int dailyHelpCount = 0;
  int vehicleCount = 0;
  int petCount = 0;

  bool notificationEnabled = true;
  bool securityEnabled = true;
  bool feedEnabled = false;

  String selectedPlan = 'Ad-Supported';

  final List<Map<String, dynamic>> properties = [
    {
      'name': 'B-402, Golden Residency',
      'active': true,
    },
  ];

  // ------------------------------------------------------------
  // THEME / COLORS
  // ------------------------------------------------------------

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get bg => isDark ? AppColors.settingsBackgroundDark : backgroundBlue;

  Color get header => isDark ? AppColors.settingsHeaderDark : headerBlue;

  Color get surface => isDark ? AppColors.surfaceDark : Colors.white;

  Color get primary => isDark ? AppColors.settingsPrimaryBlueDark : blue;

  Color get iconBackground =>
      isDark ? AppColors.settingsLightBlueDark : lightBlue;

  Color get mainText =>
      isDark ? AppColors.textPrimaryDark : const Color(0xFF171717);

  Color get secondaryText =>
      isDark ? AppColors.textSecondaryDark : const Color(0xFF757575);

  Color get borderColor =>
      isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);

  // ------------------------------------------------------------
  // ASSETS
  // ------------------------------------------------------------

  String asset(String name) {
    return 'assets/icons/settings/$name';
  }

  Widget svg(
    String name, {
    double size = 18,
  }) {
    return SvgPicture.asset(
      asset(name),
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }

  // ------------------------------------------------------------
  // COMMON HELPERS
  // ------------------------------------------------------------

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  BoxDecoration cardDecoration([double radius = 12]) {
    return BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderColor,
        width: 0.8,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(
            alpha: isDark ? .20 : .03,
          ),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const double screenPadding = 16.0;

        return Scaffold(
          backgroundColor: bg,

          // ----------------------------------------------------
          // APP BAR
          // ----------------------------------------------------

          appBar: AppBar(
            toolbarHeight: 52,
            backgroundColor: header,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 20,
                color: mainText,
              ),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                color: mainText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.help_outline,
                  size: 22,
                  color: mainText,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.helpSupport,
                  );
                },
              ),
              const SizedBox(width: 4),
            ],
          ),

          // ----------------------------------------------------
          // BODY
          // ----------------------------------------------------

          body: SafeArea(
            child: ListView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: screenPadding,
                vertical: 12,
              ),
              children: [
                // Profile
                _profileCard(width),

                const SizedBox(height: 10),

                // Complete profile
                _completeProfile(),

                const SizedBox(height: 16),

                // Household
                _householdHeader(),

                const SizedBox(height: 8),

                _householdGrid(width),

                const SizedBox(height: 16),

                // Address
                _addressCard(),

                const SizedBox(height: 10),

                // Notification
                _notificationBanner(),

                const SizedBox(height: 18),

                // Security & Notifications
                _section('Security & Notifications'),

                const SizedBox(height: 8),

                _settingTile(
                  'notification.svg',
                  'Notification Preferences',
                  'Manage what alerts you receive',
                  _notificationSheet,
                ),

                _settingTile(
                  'security_alert.svg',
                  'Security Alert List',
                  'View and manage security alerts',
                  _securitySheet,
                ),

                _settingTile(
                  'feed.svg',
                  'Feed Settings',
                  'Customize your community feed',
                  _feedSheet,
                ),

                const SizedBox(height: 18),

                // Purchases
                _section('Purchases'),

                const SizedBox(height: 8),

                _settingTile(
                  'my_orders.svg',
                  'My Orders',
                  'Track your purchases',
                  _ordersSheet,
                ),

                _settingTile(
                  'my_plans.svg',
                  'My Plans',
                  'Ad-Supported Active',
                  _plansSheet,
                  badge: selectedPlan,
                ),

                const SizedBox(height: 18),

                // Manage Flats
                _section('Manage Flats'),

                const SizedBox(height: 8),

                ...properties.map(
                  (property) => _settingTile(
                    'residence.svg',
                    property['name'] as String,
                    null,
                    () => _selectProperty(property),
                    badge: property['active'] == true ? 'Active' : null,
                    badgeColor: green,
                  ),
                ),

                _settingTile(
                  'add_flat(settings).svg',
                  'Add Flat/Villa/Office',
                  'Link another property',
                  _addProperty,
                ),

                const SizedBox(height: 18),

                // General Settings
                _section('GENERAL SETTINGS'),

                const SizedBox(height: 8),

                _settingTile(
                  'support.svg',
                  'Support & Feedback',
                  'Get help or share your thoughts',
                  () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.helpSupport,
                    );
                  },
                ),

                _settingTile(
                  'tell_about_nivass.svg',
                  'Tell a friend about mygate',
                  'Invite your neighbours',
                  () {
                    showMessage('Share option opened');
                  },
                ),

                _settingTile(
                  'family.svg',
                  'Account Information',
                  'Manage your personal details',
                  () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.profile,
                    );
                  },
                ),

                Consumer<ThemeModeProvider>(
                  builder: (_, provider, __) {
                    return _settingTile(
                      'theme.svg',
                      'Theme',
                      'Choose light, dark, or match your device',
                      () => _themeSheet(provider),
                      badge: _themeName(provider.themeMode),
                    );
                  },
                ),

                _settingTile(
                  'logout.svg',
                  'Logout',
                  'Sign out of your account',
                  _logout,
                  danger: true,
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // PROFILE
  // ============================================================

  Widget _profileCard(double width) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: cardDecoration(12),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: orange,
              shape: BoxShape.circle,
            ),
            child: const Text(
              'A',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Name',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: mainText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Nivaas Hub ID : 000000',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              showMessage('QR scanner opened');
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 36,
              height: 36,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: svg(
                'qr_scanner(settings).svg',
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMPLETE PROFILE
  // ============================================================

  Widget _completeProfile() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.profile,
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: cardDecoration(12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.settingsProfileBadgeBgDark
                    : const Color(0xFFFFEAEA),
                shape: BoxShape.circle,
              ),
              child: const Text(
                '0%',
                style: TextStyle(
                  color: red,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complete your profile',
                    style: TextStyle(
                      color: mainText,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Let neighbours discover you!',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'View Profile',
              style: TextStyle(
                color: primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SECTION
  // ============================================================

  Widget _section(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: mainText,
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HOUSEHOLD HEADER
  // ============================================================

  Widget _householdHeader() {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Household',
            style: TextStyle(
              color: mainText,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            showMessage('Household list opened');
          },
          child: Row(
            children: [
              Text(
                'View all',
                style: TextStyle(
                  color: primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                Icons.chevron_right,
                color: primary,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HOUSEHOLD GRID
  // ============================================================

  Widget _householdGrid(double width) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.55,
      children: [
        _instaHelpCard(width),
        _householdCard(
          width,
          'family.svg',
          'Family',
          '$familyCount member${familyCount == 1 ? '' : 's'}',
          add: () => _addHousehold('Family'),
        ),
        _householdCard(
          width,
          'daily_help(settings).svg',
          'Daily Help',
          dailyHelpCount == 0 ? 'Add helper' : '$dailyHelpCount added',
          add: () => _addHousehold('Daily Help'),
        ),
        _householdCard(
          width,
          'vehicles.svg',
          'Vehicles',
          vehicleCount == 0 ? 'Add vehicle' : '$vehicleCount added',
          add: () => _addHousehold('Vehicles'),
        ),
        _householdCard(
          width,
          'pets.svg',
          'Pets',
          petCount == 0 ? 'Add pet' : '$petCount added',
          add: () => _addHousehold('Pets'),
        ),
      ],
    );
  }

  // ============================================================
  // INSTAHELP CARD
  // ============================================================

  Widget _instaHelpCard(double width) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: cardDecoration(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/icons/settings/insta_help.png',
                  width: 34,
                  height: 34,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 34,
                    height: 34,
                    color: iconBackground,
                    child: const Icon(Icons.person, size: 20, color: blue),
                  ),
                ),
              ),
              const Spacer(),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, size: 12, color: orange),
                  SizedBox(width: 2),
                  Text(
                    '4.8',
                    style: TextStyle(
                      color: Color(0xFF171717),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Text(
            'InstaHelp',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: mainText,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '1 Mn+ houses',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: secondaryText,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NORMAL HOUSEHOLD CARD
  // ============================================================

  Widget _householdCard(
    double width,
    String iconName,
    String title,
    String subtitle, {
    VoidCallback? add,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: cardDecoration(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: svg(iconName, size: 20),
              ),
              const Spacer(),
              if (add != null)
                GestureDetector(
                  onTap: add,
                  child: Container(
                    height: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor, width: 0.8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '+ Add',
                      style: TextStyle(
                        color: primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: mainText,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: secondaryText,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ADDRESS
  // ============================================================

Widget _addressCard() {
  return InkWell(
    onTap: () {
      showMessage('Share option opened');
    },
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: cardDecoration(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Address',
                  style: TextStyle(
                    color: mainText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Address Details',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          svg(
            'share.svg', // Replace with your exact SVG file name if different (e.g., 'share_outlined.svg')
            size: 18,
          ),
        ],
      ),
    ),
  );
}

  // ============================================================
  // NOTIFICATION BANNER
  // ============================================================

  Widget _notificationBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.settingsNotifyBgDark
            : const Color(0xFFFFF8E7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? AppColors.settingsNotifyBorderDark
              : const Color(0xFFFFE5B4),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Not Getting Notifications?',
              style: TextStyle(
                color: isDark
                    ? AppColors.settingsNotifyTextDark
                    : const Color(0xFFD97706),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 28,
            child: ElevatedButton(
              onPressed: () {
                showMessage('Test notification sent successfully');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: notificationOrange,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Test Now',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SETTING TILE
  // ============================================================

  Widget _settingTile(
    String iconName,
    String title,
    String? subtitle,
    VoidCallback onTap, {
    String? badge,
    Color? badgeColor,
    bool danger = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: cardDecoration(12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 11,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: danger
                        ? const Color(0xFFFFEEEE)
                        : iconBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: svg(
                    iconName,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: danger ? red : mainText,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (badge != null) ...[
                  if (badgeColor != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    Text(
                      badge,
                      style: TextStyle(
                        color: primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(width: 4),
                ],
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Color(0xFF9E9E9E),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PLACEHOLDER ACTIONS
  // ============================================================

  void _notificationSheet() => showMessage('Notification preferences clicked');
  void _securitySheet() => showMessage('Security alert list clicked');
  void _feedSheet() => showMessage('Feed settings clicked');
  void _ordersSheet() => showMessage('My orders clicked');
  void _plansSheet() => showMessage('My plans clicked');

  void _addHousehold(String category) {
    showMessage('Add $category clicked');
  }

  void _selectProperty(Map<String, dynamic> property) {
    showMessage('Selected ${property['name']}');
  }

  void _addProperty() {
    showMessage('Add property clicked');
  }

  void _themeSheet(ThemeModeProvider provider) {
    showMessage('Theme settings clicked');
  }

  String _themeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _logout() {
    showMessage('Logging out...');
  }
}