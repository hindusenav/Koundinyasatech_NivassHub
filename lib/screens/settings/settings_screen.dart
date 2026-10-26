import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/widgets/household/household_sections.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/providers/theme/theme_mode_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';
import 'package:flutter_nivasshub/providers/auth/auth_state_provider.dart';
import 'package:flutter_nivasshub/providers/kyc/kyc_provider.dart';
import 'package:flutter_nivasshub/providers/notifications/mock_notification_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    // The KYC flow writes to the mock notification log without anyone
    // having read it, so load it here — otherwise the unread badge below
    // stays at zero until the log screen is opened, which is exactly when
    // the badge stops being useful.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MockNotificationProvider>().load();
    });
  }

  // ============================================================
  // THEME
  // ============================================================

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  // White page; blue accents (orange is reserved for buttons).
  Color get backgroundColor =>
      _isDark ? AppColors.settingsBackgroundDark : AppColors.background;
  Color get primaryBlue => _isDark
      ? AppColors.settingsPrimaryBlueDark
      : AppColors.settingsPrimaryBlueLight;
  Color get lightBlue => _isDark
      ? AppColors.settingsLightBlueDark
      : AppColors.settingsLightBlueLight;
  Color get darkText =>
      _isDark ? AppColors.textPrimaryDark : AppColors.settingsTextPrimaryLight;
  Color get greyText => _isDark
      ? AppColors.textSecondaryDark
      : AppColors.settingsTextSecondaryLight;
  Color get borderColor =>
      _isDark ? AppColors.borderDark : AppColors.settingsBorderLight;
  Color get sheetBackgroundColor =>
      _isDark ? AppColors.surfaceDark : AppColors.cardBg;

  // ============================================================
  // LOCAL VALUES
  // ============================================================

  /// 0 = Household Hub, 1 = Account Settings.
  int _tab = 0;

  String selectedPlan = 'Ad-Supported';

  bool notificationEnabled = true;
  bool securityEnabled = true;
  bool feedEnabled = false;

  final List<Map<String, dynamic>> properties = [
    {'name': 'B-402, Golden Residency', 'active': true},
  ];

  // ============================================================
  // MESSAGE
  // ============================================================

  void _message(String text) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // HELP & SUPPORT
  // ============================================================

  void _openHelpSupport() {
    Navigator.pushNamed(context, AppRoutes.helpSupport);
  }

  // ============================================================
  // MOCK NOTIFICATION LOG
  // ============================================================

  /// The KYC status emails from spec §16 are not actually sent — the mail
  /// service is not connected — so they are logged to the console and
  /// listed here instead.
  void _openNotificationLog() {
    Navigator.pushNamed(context, AppRoutes.mockNotificationLog);
  }

  // ============================================================
  // NOTIFICATION PREFERENCES
  // ============================================================

  void _notificationPreferences() {
    showModalBottomSheet(
      context: context,
      backgroundColor: sheetBackgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _sheetHandle(),
                  const SizedBox(height: 18),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Notification Preferences',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Notification Alerts',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      'Manage what alerts you receive',
                      style: TextStyle(fontSize: 11),
                    ),
                    value: notificationEnabled,
                    activeThumbColor: primaryBlue,
                    onChanged: (value) {
                      setModalState(() {
                        notificationEnabled = value;
                      });
                      setState(() {
                        notificationEnabled = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Security Alerts',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      'Receive security notifications',
                      style: TextStyle(fontSize: 11),
                    ),
                    value: securityEnabled,
                    activeThumbColor: primaryBlue,
                    onChanged: (value) {
                      setModalState(() {
                        securityEnabled = value;
                      });
                      setState(() {
                        securityEnabled = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Community Feed',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      'Customize your community feed',
                      style: TextStyle(fontSize: 11),
                    ),
                    value: feedEnabled,
                    activeThumbColor: primaryBlue,
                    onChanged: (value) {
                      setModalState(() {
                        feedEnabled = value;
                      });
                      setState(() {
                        feedEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // SECURITY ALERTS
  // ============================================================

  void _securityAlerts() {
    showModalBottomSheet(
      context: context,
      backgroundColor: sheetBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sheetHandle(),
              const SizedBox(height: 18),
              const Text(
                'Security Alert List',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _sheetItem(
                Icons.shield_outlined,
                'Visitor entry approved',
                'Today, 11:30 AM',
              ),
              _sheetItem(
                Icons.local_shipping_outlined,
                'Delivery received',
                'Today, 10:15 AM',
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // FEED SETTINGS
  // ============================================================

  void _feedSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: sheetBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _sheetHandle(),
                  const SizedBox(height: 18),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Feed Settings',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Community Feed',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      'Customize your community feed',
                      style: TextStyle(fontSize: 11),
                    ),
                    value: feedEnabled,
                    activeThumbColor: primaryBlue,
                    onChanged: (value) {
                      setModalState(() {
                        feedEnabled = value;
                      });
                      setState(() {
                        feedEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // ORDERS
  // ============================================================

  void _myOrders() {
    showModalBottomSheet(
      context: context,
      backgroundColor: sheetBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sheetHandle(),
              const SizedBox(height: 18),
              const Text(
                'My Orders',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _sheetItem(
                Icons.shopping_bag_outlined,
                'Community Store',
                'Completed',
              ),
              _sheetItem(
                Icons.receipt_long_outlined,
                'Maintenance Payment',
                'Completed',
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // PLANS
  // ============================================================

  void _myPlans() {
    showModalBottomSheet(
      context: context,
      backgroundColor: sheetBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _sheetHandle(),
                  const SizedBox(height: 18),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'My Plans',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  RadioGroup<String>(
                    groupValue: selectedPlan,
                    onChanged: (value) {
                      if (value == null) return;
                      setModalState(() {
                        selectedPlan = value;
                      });
                      setState(() {
                        selectedPlan = value;
                      });
                    },
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          value: 'Ad-Supported',
                          activeColor: primaryBlue,
                          title: const Text('Ad-Supported'),
                          subtitle: const Text('Free plan'),
                        ),
                        RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          value: 'Premium',
                          activeColor: primaryBlue,
                          title: const Text('Nivaas Premium (₹99/mo)'),
                          subtitle: const Text('Premium'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // THEME PICKER
  // ============================================================

  String _themeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  void _chooseTheme() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer<ThemeModeProvider>(
          builder: (context, themeModeProvider, _) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: sheetBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _sheetHandle(),
                    const SizedBox(height: 18),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Theme',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RadioGroup<ThemeMode>(
                      groupValue: themeModeProvider.themeMode,
                      onChanged: (mode) {
                        if (mode == null) return;
                        themeModeProvider.setThemeMode(mode);
                      },
                      child: Column(
                        children: [
                          RadioListTile<ThemeMode>(
                            contentPadding: EdgeInsets.zero,
                            value: ThemeMode.system,
                            activeColor: primaryBlue,
                            title: const Text('System'),
                            subtitle: const Text('Match your device setting'),
                          ),
                          RadioListTile<ThemeMode>(
                            contentPadding: EdgeInsets.zero,
                            value: ThemeMode.light,
                            activeColor: primaryBlue,
                            title: const Text('Light'),
                            subtitle: const Text('Always use light theme'),
                          ),
                          RadioListTile<ThemeMode>(
                            contentPadding: EdgeInsets.zero,
                            value: ThemeMode.dark,
                            activeColor: primaryBlue,
                            title: const Text('Dark'),
                            subtitle: const Text('Always use dark theme'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // ADD PROPERTY
  // ============================================================

  void _addProperty() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Flat/Villa/Office'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter property name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: AppColors.white,
              ),
              onPressed: () {
                final value = controller.text.trim();
                if (value.isNotEmpty) {
                  setState(() {
                    properties.add({'name': value, 'active': false});
                  });
                }
                Navigator.pop(dialogContext);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  void _logout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
              ),
              onPressed: () async {
                // Read providers before the first `await` — avoids using
                // `context` across an async gap.
                final authState = context.read<AuthStateProvider>();
                final kyc = context.read<KycProvider>();
                final dashboard = context.read<DashboardProvider>();

                Navigator.pop(dialogContext);
                debugPrint('[Session] Logout initiated by user');

                // `AuthStateProvider.clear()` rather than
                // `SecureStorageService.clearSession()` directly: the
                // latter predates the KYC flow and knows nothing about
                // the auth-flow state, the kycToken or the uploaded
                // documents, so a second user on this device would
                // otherwise inherit the first user's half-finished
                // application and land mid-flow. `clear()` calls
                // `clearSession()` itself and drops the rest with it.
                await authState.clear();
                await kyc.reset();
                debugPrint(
                  '[Session] Storage cleared (tokens, session and KYC state)',
                );

                if (!mounted) return;

                // Reset in-memory state so a subsequent login doesn't
                // inherit stale dashboard data from this session.
                dashboard.reset();

                debugPrint(
                  '[Nav] Logout complete -> redirecting to Login, '
                  'nav stack cleared',
                );
                NavigationService.logoutAndRedirectToLogin();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // TEST NOTIFICATION
  // ============================================================

  void _testNotification() {
    _message('Test notification sent successfully');
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return HouseholdScope(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            _header(),
            Expanded(
              child: SafeArea(
                top: false,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  children: [
                    _tabSwitcher(),
                    const SizedBox(height: 16),

                    if (_tab == 0)
                      // Family, pets, vehicles, daily help
                      const HouseholdSections()
                    else ...[
                      // Address
                      _addressCard(),
                      const SizedBox(height: 12),

                      // Notification Banner
                      _notificationBanner(),
                      const SizedBox(height: 16),

                      // Security & Notifications
                      _sectionHeader('Security & Notifications'),
                      const SizedBox(height: 6),
                      _settingCard(
                        icon: Icons.notifications_none,
                        title: 'Notification Preferences',
                        subtitle: 'Manage what alerts you receive',
                        onTap: _notificationPreferences,
                      ),
                      _settingCard(
                        icon: Icons.shield_outlined,
                        title: 'Security Alert List',
                        subtitle: 'View and manage security alerts',
                        onTap: _securityAlerts,
                      ),
                      _settingCard(
                        icon: Icons.article_outlined,
                        title: 'Feed Settings',
                        subtitle: 'Customize your community feed',
                        onTap: _feedSettings,
                      ),
                      const SizedBox(height: 16),

                      // Purchases
                      _sectionHeader('Purchases'),
                      const SizedBox(height: 6),
                      _settingCard(
                        icon: Icons.shopping_bag_outlined,
                        title: 'My Orders',
                        subtitle: 'Track your purchases',
                        onTap: _myOrders,
                      ),
                      _settingCard(
                        icon: Icons.credit_card_outlined,
                        title: 'My Plans',
                        subtitle: 'Ad-Supported Active',
                        badge: selectedPlan,
                        onTap: _myPlans,
                      ),
                      const SizedBox(height: 16),

                      // Manage Flats
                      _sectionHeader('Manage Flats'),
                      const SizedBox(height: 6),
                      ...properties.map((property) {
                        return _settingCard(
                          icon: Icons.home_outlined,
                          title: property['name'] as String,
                          badge: property['active'] == true ? 'Active' : null,
                          badgeColor: AppColors.badgeGreen,
                          onTap: () {
                            setState(() {
                              for (final item in properties) {
                                item['active'] = false;
                              }
                              property['active'] = true;
                            });
                            _message('${property['name']} selected');
                          },
                        );
                      }),
                      _settingCard(
                        icon: Icons.add_circle_outline,
                        title: 'Add Flat/Villa/Office',
                        subtitle: 'Link another property',
                        onTap: _addProperty,
                      ),
                      const SizedBox(height: 16),

                      // General Settings
                      _sectionHeader('General Settings'),
                      const SizedBox(height: 6),
                      _settingCard(
                        icon: Icons.help_outline,
                        title: 'Support & Feedback',
                        subtitle: 'Get help or share your thoughts',
                        onTap: _openHelpSupport,
                      ),
                      _settingCard(
                        icon: Icons.send_outlined,
                        title: 'Tell a friend about mygate',
                        subtitle: 'Invite your neighbours',
                        onTap: () {
                          _message('Share option opened');
                        },
                      ),
                      _settingCard(
                        icon: Icons.person_outline,
                        title: 'Account Information',
                        subtitle: 'Manage your personal details',
                        onTap: () =>
                            _message('Account details are coming soon'),
                      ),
                      Consumer<MockNotificationProvider>(
                        builder: (context, notifications, _) {
                          return _settingCard(
                            icon: Icons.mark_email_unread_outlined,
                            title: 'Notification Log (Mock)',
                            subtitle: 'KYC emails that would have been sent',
                            badge: notifications.unreadCount > 0
                                ? '${notifications.unreadCount}'
                                : null,
                            onTap: _openNotificationLog,
                          );
                        },
                      ),
                      Consumer<ThemeModeProvider>(
                        builder: (context, themeModeProvider, _) {
                          return _settingCard(
                            icon: Icons.brightness_6_outlined,
                            title: 'Theme',
                            subtitle:
                                'Choose light, dark, or match your device',
                            badge: _themeModeLabel(themeModeProvider.themeMode),
                            onTap: _chooseTheme,
                          );
                        },
                      ),
                      _settingCard(
                        icon: Icons.logout,
                        title: 'Logout',
                        subtitle: 'Sign-out of your account',
                        iconColor: AppColors.error,
                        titleColor: AppColors.error,
                        onTap: _logout,
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE CARD
  // ============================================================

  Widget _header() {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(20, topPadding + 12, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.headerStart, AppColors.headerEnd],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (Navigator.of(context).canPop())
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.white,
                    size: 18,
                  ),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              const Expanded(
                child: Text(
                  'Settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.help_outline, color: AppColors.white),
                onPressed: _openHelpSupport,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'U',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Name',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Nivaas Hub ID : 00000',
                      style: TextStyle(color: AppColors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.35),
                  ),
                ),
                child: const Icon(
                  Icons.qr_code_2,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TAB SWITCHER
  // ============================================================

  Widget _tabSwitcher() {
    Widget segment(int index, IconData icon, String label) {
      final selected = _tab == index;
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _tab = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 42,
            decoration: BoxDecoration(
              color: selected ? AppColors.primaryOrange : Colors.transparent,
              borderRadius: BorderRadius.circular(21),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: selected ? AppColors.white : AppColors.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? AppColors.white : AppColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          segment(0, Icons.groups_2_outlined, 'Household Hub'),
          segment(1, Icons.settings_outlined, 'Account Settings'),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _sectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: primaryBlue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: darkText,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ADDRESS CARD
  // ============================================================

  Widget _addressCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _isDark ? AppColors.surfaceDark : AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: _isDark
                ? AppColors.black.withValues(alpha: 0.4)
                : AppColors.shadowSoft,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Address',
                  style: TextStyle(
                    color: darkText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Address Details',
                  style: TextStyle(color: greyText, fontSize: 11),
                ),
              ],
            ),
          ),
          Icon(Icons.share_outlined, color: primaryBlue, size: 20),
        ],
      ),
    );
  }

  // ============================================================
  // NOTIFICATION BANNER
  // ============================================================

  Widget _notificationBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _isDark
            ? AppColors.settingsNotifyBgDark
            : AppColors.settingsNotifyBgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isDark
              ? AppColors.settingsNotifyBorderDark
              : AppColors.settingsNotifyBorderLight,
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Not Getting Notifications?',
              style: TextStyle(
                color: _isDark
                    ? AppColors.settingsNotifyTextDark
                    : AppColors.settingsNotifyTextLight,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 28,
            child: ElevatedButton(
              onPressed: _testNotification,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                'Test Now',
                style: const TextStyle(
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
  // SETTINGS CARD
  // ============================================================

  Widget _settingCard({
    required IconData icon,
    required String title,
    String? subtitle,
    String? badge,
    Color? badgeColor,
    Color? iconColor,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    final bool hasSubtitle = subtitle != null && subtitle.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _isDark ? AppColors.surfaceDark : AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: _isDark
                ? AppColors.black.withValues(alpha: 0.4)
                : AppColors.shadowSoft,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: iconColor == AppColors.error
                        ? (_isDark
                              ? AppColors.settingsDangerIconBgDark
                              : AppColors.settingsDangerIconBgLight)
                        : lightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor == AppColors.error
                        ? (_isDark
                              ? AppColors.noticesDangerTextDark
                              : AppColors.error)
                        : (iconColor ?? primaryBlue),
                    size: 17,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: titleColor == AppColors.error
                              ? (_isDark
                                    ? AppColors.noticesDangerTextDark
                                    : AppColors.error)
                              : (titleColor ?? darkText),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (hasSubtitle) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: greyText, fontSize: 11),
                        ),
                      ],
                    ],
                  ),
                ),
                if (badge != null)
                  Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: (badgeColor ?? primaryBlue).withValues(
                        alpha: 0.10,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        color: badgeColor ?? primaryBlue,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                Icon(
                  Icons.chevron_right,
                  color: _isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.settingsChevronLight,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SHEET HANDLE
  // ============================================================

  Widget _sheetHandle() {
    return Container(
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: _isDark ? AppColors.borderDark : AppColors.cardBorder,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // ============================================================
  // SHEET ITEM
  // ============================================================

  Widget _sheetItem(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, color: primaryBlue, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: greyText)),
    );
  }
}
