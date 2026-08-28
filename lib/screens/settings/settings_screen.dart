import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ============================================================
  // COLORS
  // ============================================================

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

  // ============================================================
  // ASSET PATH
  // ============================================================

  static const String settingsPath =
      'assets/icons/settings';

  // ============================================================
  // HOUSEHOLD ASSETS
  // ============================================================

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

  // ============================================================
  // SETTINGS ASSETS
  // ============================================================

  static const String notifications =
      '$settingsPath/notifications.png';

  static const String security =
      '$settingsPath/security.png';

  static const String feed =
      '$settingsPath/feed.png';

  static const String orders =
      '$settingsPath/my orders.png';

  static const String plans =
      '$settingsPath/my plans.png';

  static const String home =
      '$settingsPath/home.png';

  static const String addVilla =
      '$settingsPath/add villa.png';

  static const String support =
      '$settingsPath/support.png';

  static const String send =
      '$settingsPath/share(tell a friend).png';

  static const String logout =
      '$settingsPath/logout.png';

  static const String scanner =
      '$settingsPath/profile scanner.png';

  static const String shareAction =
      '$settingsPath/Share Action.png';

  static const String user =
      '$settingsPath/user.png';

  // ============================================================
  // STATE
  // ============================================================

  int familyCount = 1;
  int dailyHelpCount = 0;
  int vehicleCount = 0;
  int petCount = 0;

  String selectedPlan = 'Ad-Supported';

  bool notificationEnabled = true;
  bool securityEnabled = true;
  bool feedEnabled = false;

  final List<Map<String, dynamic>> properties = [
    {
      'name': 'B-402, Golden Residency',
      'active': true,
    },
  ];

  // ============================================================
  // COMMON MESSAGE
  // ============================================================

  void _message(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          duration:
              const Duration(seconds: 2),
          margin: const EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10),
          ),
        ),
      );
  }

  // ============================================================
  // PROFILE
  // ============================================================

  void _openProfile() {
    Navigator.pushNamed(
      context,
      AppRoutes.profile,
    );
  }

  // ============================================================
  // HELP
  // ============================================================

  void _openHelpSupport() {
    Navigator.pushNamed(
      context,
      AppRoutes.helpSupport,
    );
  }

  // ============================================================
  // SCANNER
  // ============================================================

  void _openScanner() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),
          title: const Text(
            'Nivaas Hub ID',
            style: TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Image.asset(
                scanner,
                width: 190,
                height: 190,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 12),
              const Text(
                'Nivaas Hub ID : 00000',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // NOTIFICATION PREFERENCES
  // ============================================================

  void _notificationPreferences() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setModalState) {
            return Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                28,
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  _sheetHandle(),

                  const SizedBox(
                    height: 18,
                  ),

                  const Align(
                    alignment:
                        Alignment.centerLeft,
                    child: Text(
                      'Notification Preferences',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  _switchTile(
                    'Notification Alerts',
                    'Manage what alerts you receive',
                    notificationEnabled,
                    (value) {
                      setModalState(() {
                        notificationEnabled =
                            value;
                      });

                      setState(() {
                        notificationEnabled =
                            value;
                      });
                    },
                  ),

                  _switchTile(
                    'Security Alerts',
                    'Receive security notifications',
                    securityEnabled,
                    (value) {
                      setModalState(() {
                        securityEnabled =
                            value;
                      });

                      setState(() {
                        securityEnabled =
                            value;
                      });
                    },
                  ),

                  _switchTile(
                    'Community Feed',
                    'Show community feed updates',
                    feedEnabled,
                    (value) {
                      setModalState(() {
                        feedEnabled =
                            value;
                      });

                      setState(() {
                        feedEnabled =
                            value;
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
      backgroundColor: Colors.white,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return Padding(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            28,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _sheetHandle(),

              const SizedBox(height: 18),

              const Text(
                'Security Alert List',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              _sheetItem(
                security,
                'Visitor entry approved',
                'Today, 11:30 AM',
              ),

              _sheetItem(
                vehicles,
                'Delivery received',
                'Today, 10:15 AM',
              ),

              _sheetItem(
                security,
                'Security check completed',
                'Yesterday, 8:20 PM',
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
      backgroundColor: Colors.white,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setModalState) {
            return Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                28,
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  _sheetHandle(),

                  const SizedBox(
                    height: 18,
                  ),

                  const Align(
                    alignment:
                        Alignment.centerLeft,
                    child: Text(
                      'Feed Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  const Align(
                    alignment:
                        Alignment.centerLeft,
                    child: Text(
                      'Customize your community feed',
                      style: TextStyle(
                        fontSize: 13,
                        color: greyText,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  SwitchListTile(
                    contentPadding:
                        EdgeInsets.zero,
                    title: const Text(
                      'Community Feed',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    subtitle:
                        const Text(
                      'Show community posts and updates',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    value: feedEnabled,
                    activeThumbColor:
                        primaryBlue,
                    onChanged: (value) {
                      setModalState(() {
                        feedEnabled =
                            value;
                      });

                      setState(() {
                        feedEnabled =
                            value;
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
  // MY ORDERS
  // ============================================================

  void _myOrders() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return Padding(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            28,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _sheetHandle(),

              const SizedBox(height: 18),

              const Text(
                'My Orders',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              _sheetItem(
                orders,
                'Community Store',
                'Completed',
              ),

              _sheetItem(
                orders,
                'Maintenance Payment',
                'Completed',
              ),

              _sheetItem(
                orders,
                'Household Service',
                'Completed',
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // MY PLANS
  // ============================================================

  void _myPlans() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setModalState) {
            return Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                28,
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  _sheetHandle(),

                  const SizedBox(
                    height: 18,
                  ),

                  const Align(
                    alignment:
                        Alignment.centerLeft,
                    child: Text(
                      'My Plans',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  RadioListTile<String>(
                    contentPadding:
                        EdgeInsets.zero,
                    activeColor:
                        primaryBlue,
                    value:
                        'Ad-Supported',
                    groupValue:
                        selectedPlan,
                    title:
                        const Text(
                      'Ad-Supported',
                      style:
                          TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    subtitle:
                        const Text(
                      'Free plan',
                      style:
                          TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    onChanged:
                        (value) {
                      if (value ==
                          null) {
                        return;
                      }

                      setModalState(() {
                        selectedPlan =
                            value;
                      });

                      setState(() {
                        selectedPlan =
                            value;
                      });
                    },
                  ),

                  RadioListTile<String>(
                    contentPadding:
                        EdgeInsets.zero,
                    activeColor:
                        primaryBlue,
                    value: 'Premium',
                    groupValue:
                        selectedPlan,
                    title:
                        const Text(
                      'Nivaas Premium',
                      style:
                          TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    subtitle:
                        const Text(
                      'Premium plan',
                      style:
                          TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    onChanged:
                        (value) {
                      if (value ==
                          null) {
                        return;
                      }

                      setModalState(() {
                        selectedPlan =
                            value;
                      });

                      setState(() {
                        selectedPlan =
                            value;
                      });

                      _message(
                        'Premium plan selected',
                      );
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
  // VIEW ALL HOUSEHOLD
  // ============================================================

  void _viewAllHousehold() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return Padding(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            28,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              _sheetHandle(),

              const SizedBox(height: 18),

              const Align(
                alignment:
                    Alignment.centerLeft,
                child: Text(
                  'Household',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              _summaryItem(
                family,
                'Family',
                familyCount == 1
                    ? '1 member'
                    : '$familyCount members',
              ),

              _summaryItem(
                dailyHelp,
                'Daily Help',
                '$dailyHelpCount added',
              ),

              _summaryItem(
                vehicles,
                'Vehicles',
                '$vehicleCount added',
              ),

              _summaryItem(
                pets,
                'Pets',
                '$petCount added',
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // ADD FAMILY
  // ============================================================

  void _addFamily() {
    _addTextDialog(
      title: 'Add Family Member',
      hint: 'Enter member name',
      onAdd: () {
        setState(() {
          familyCount++;
        });

        _message(
          'Family member added',
        );
      },
    );
  }

  // ============================================================
  // ADD DAILY HELP
  // ============================================================

  void _addDailyHelp() {
    _addTextDialog(
      title: 'Add Daily Help',
      hint: 'Enter helper name',
      onAdd: () {
        setState(() {
          dailyHelpCount++;
        });

        _message(
          'Daily help added',
        );
      },
    );
  }

  // ============================================================
  // ADD VEHICLE
  // ============================================================

  void _addVehicle() {
    _addTextDialog(
      title: 'Add Vehicle',
      hint: 'Enter vehicle number',
      onAdd: () {
        setState(() {
          vehicleCount++;
        });

        _message(
          'Vehicle added',
        );
      },
    );
  }

  // ============================================================
  // ADD PET
  // ============================================================

  void _addPet() {
    _addTextDialog(
      title: 'Add Pet',
      hint: 'Enter pet name',
      onAdd: () {
        setState(() {
          petCount++;
        });

        _message(
          'Pet added',
        );
      },
    );
  }

  // ============================================================
  // COMMON ADD DIALOG
  // ============================================================

  void _addTextDialog({
    required String title,
    required String hint,
    required VoidCallback onAdd,
  }) {
    final controller =
        TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              18,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
          content: TextField(
            controller: controller,
            textCapitalization:
                TextCapitalization.words,
            style: const TextStyle(
              fontSize: 14,
            ),
            decoration:
                InputDecoration(
              hintText: hint,
              hintStyle:
                  const TextStyle(
                fontSize: 13,
              ),
              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: greyText,
                  fontSize: 14,
                ),
              ),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    primaryBlue,
                foregroundColor:
                    Colors.white,
              ),
              onPressed: () {
                if (controller.text
                    .trim()
                    .isEmpty) {
                  _message(
                    'Please enter a value',
                  );
                  return;
                }

                onAdd();

                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Add',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // ADD PROPERTY
  // ============================================================

  void _addProperty() {
    final controller =
        TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              18,
            ),
          ),
          title: const Text(
            'Add Flat/Villa/Office',
            style: TextStyle(
              fontSize: 19,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(
              fontSize: 14,
            ),
            decoration:
                InputDecoration(
              hintText:
                  'Enter property name',
              hintStyle:
                  const TextStyle(
                fontSize: 13,
              ),
              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: greyText,
                  fontSize: 14,
                ),
              ),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    primaryBlue,
                foregroundColor:
                    Colors.white,
              ),
              onPressed: () {
                final value =
                    controller.text
                        .trim();

                if (value.isEmpty) {
                  _message(
                    'Please enter property name',
                  );
                  return;
                }

                setState(() {
                  properties.add({
                    'name': value,
                    'active': false,
                  });
                });

                Navigator.pop(
                  dialogContext,
                );

                _message(
                  'Property added successfully',
                );
              },
              child: const Text(
                'Add',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // SELECT PROPERTY
  // ============================================================

  void _selectProperty(
    Map<String, dynamic> property,
  ) {
    setState(() {
      for (final item in properties) {
        item['active'] = false;
      }

      property['active'] = true;
    });

    _message(
      '${property['name']} selected',
    );
  }

  // ============================================================
  // ADDRESS
  // ============================================================

  void _openAddress() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return Padding(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            28,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _sheetHandle(),

              const SizedBox(height: 18),

              const Text(
                'My Address',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                'B-402, Golden Residency',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Address Details',
                style: TextStyle(
                  fontSize: 12,
                  color: greyText,
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 46,
                child:
                    ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(
                      const ClipboardData(
                        text:
                            'B-402, Golden Residency',
                      ),
                    );

                    Navigator.pop(
                      context,
                    );

                    _message(
                      'Address copied',
                    );
                  },
                  icon: const Icon(
                    Icons.copy_outlined,
                    size: 17,
                  ),
                  label: const Text(
                    'Copy Address',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        primaryBlue,
                    foregroundColor:
                        Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // TEST NOTIFICATION
  // ============================================================

  void _testNotification() {
    _message(
      'Test notification sent successfully',
    );
  }

  // ============================================================
  // TELL A FRIEND
  // ============================================================

  void _tellFriend() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return Padding(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            28,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              _sheetHandle(),

              const SizedBox(height: 18),

              const Align(
                alignment:
                    Alignment.centerLeft,
                child: Text(
                  'Tell a Friend',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Align(
                alignment:
                    Alignment.centerLeft,
                child: Text(
                  'Invite your neighbours to join Nivaas.',
                  style: TextStyle(
                    fontSize: 13,
                    color: greyText,
                  ),
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              SizedBox(
                width: double.infinity,
                height: 46,
                child:
                    ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(
                      const ClipboardData(
                        text:
                            'Join me on Nivaas and connect with your neighbourhood.',
                      ),
                    );

                    Navigator.pop(
                      context,
                    );

                    _message(
                      'Invite message copied',
                    );
                  },
                  icon: const Icon(
                    Icons.copy_outlined,
                    size: 17,
                  ),
                  label: const Text(
                    'Copy Invite Message',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        primaryBlue,
                    foregroundColor:
                        Colors.white,
                  ),
                ),
              ),
            ],
          ),
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
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              18,
            ),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: greyText,
                  fontSize: 14,
                ),
              ),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
                foregroundColor:
                    Colors.white,
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          backgroundColor,

      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(50),
        child: AppBar(
          backgroundColor:
              headerColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leadingWidth: 42,
          titleSpacing: 0,

          leading: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.arrow_back,
              size: 21,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.maybePop(
                context,
              );
            },
          ),

          title: const Text(
            'Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w700,
              color: Colors.black,
            ),
          ),

          actions: [
            IconButton(
              padding:
                  const EdgeInsets.only(
                right: 8,
              ),
              icon: const Icon(
                Icons.help_outline,
                size: 21,
                color: Colors.black,
              ),
              onPressed:
                  _openHelpSupport,
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder:
              (context, constraints) {
            final scale =
                (constraints.maxWidth /
                        342)
                    .clamp(
              0.95,
              1.08,
            );

            return ListView(
              physics:
                  const ClampingScrollPhysics(),

              padding:
                  EdgeInsets.fromLTRB(
                10 * scale,
                8 * scale,
                10 * scale,
                14 * scale,
              ),

              children: [
                // ==================================================
                // PROFILE
                // ==================================================

                _profileCard(scale),

                SizedBox(
                  height: 8 * scale,
                ),

                // ==================================================
                // COMPLETE PROFILE
                // ==================================================

                _completeProfileCard(
                  scale,
                ),

                SizedBox(
                  height: 10 * scale,
                ),

                // ==================================================
                // HOUSEHOLD HEADER
                // ==================================================

                _sectionHeader(
                  'Household',
                  scale,
                  trailing:
                      GestureDetector(
                    onTap:
                        _viewAllHousehold,
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Text(
                          'View all',
                          style:
                              TextStyle(
                            color:
                                primaryBlue,
                            fontSize:
                                10.5 *
                                    scale,
                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                        ),
                        Icon(
                          Icons
                              .chevron_right,
                          color:
                              primaryBlue,
                          size:
                              17 * scale,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 7 * scale,
                ),

                // ==================================================
                // HOUSEHOLD ROW 1
                // ==================================================

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Expanded(
                      child:
                          _householdCard(
                        imagePath:
                            instaHelp,
                        title:
                            'InstaHelp',
                        subtitle:
                            '1 Mn+ houses',
                        rating:
                            '4.8',
                        showRating:
                            true,
                        scale:
                            scale,
                        onTap: () {
                          _message(
                            'InstaHelp selected',
                          );
                        },
                      ),
                    ),

                    SizedBox(
                      width:
                          8 * scale,
                    ),

                    Expanded(
                      child:
                          _householdCard(
                        imagePath:
                            family,
                        title:
                            'Family',
                        subtitle:
                            familyCount ==
                                    1
                                ? '1 member'
                                : '$familyCount members',
                        showAdd:
                            true,
                        scale:
                            scale,
                        onAdd:
                            _addFamily,
                        onTap:
                            _addFamily,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 7 * scale,
                ),

                // ==================================================
                // HOUSEHOLD ROW 2
                // ==================================================

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Expanded(
                      child:
                          _householdCard(
                        imagePath:
                            dailyHelp,
                        title:
                            'Daily Help',
                        subtitle:
                            dailyHelpCount ==
                                    0
                                ? 'Add helper'
                                : '$dailyHelpCount added',
                        showAdd:
                            true,
                        scale:
                            scale,
                        onAdd:
                            _addDailyHelp,
                        onTap:
                            _addDailyHelp,
                      ),
                    ),

                    SizedBox(
                      width:
                          8 * scale,
                    ),

                    Expanded(
                      child:
                          _householdCard(
                        imagePath:
                            vehicles,
                        title:
                            'Vehicles',
                        subtitle:
                            vehicleCount ==
                                    0
                                ? 'Add vehicle'
                                : '$vehicleCount added',
                        showAdd:
                            true,
                        scale:
                            scale,
                        onAdd:
                            _addVehicle,
                        onTap:
                            _addVehicle,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 7 * scale,
                ),

                // ==================================================
                // PETS
                // ==================================================

                Row(
                  children: [
                    SizedBox(
                      width:
                          (constraints.maxWidth -
                                  28 *
                                      scale) /
                              2,
                      child:
                          _householdCard(
                        imagePath:
                            pets,
                        title:
                            'Pets',
                        subtitle:
                            petCount == 0
                                ? 'Add pet'
                                : '$petCount added',
                        showAdd:
                            true,
                        scale:
                            scale,
                        onAdd:
                            _addPet,
                        onTap:
                            _addPet,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 10 * scale,
                ),

                // ==================================================
                // MY ADDRESS
                // ==================================================

                _addressCard(scale),

                SizedBox(
                  height: 9 * scale,
                ),

                // ==================================================
                // NOTIFICATION BANNER
                // ==================================================

                _notificationBanner(
                  scale,
                ),

                SizedBox(
                  height: 10 * scale,
                ),

                // ==================================================
                // SECURITY & NOTIFICATIONS
                // ==================================================

                _sectionHeader(
                  'Security & Notifications',
                  scale,
                ),

                SizedBox(
                  height: 7 * scale,
                ),

                _settingCard(
                  assetPath:
                      notifications,
                  title:
                      'Notification Preferences',
                  subtitle:
                      'Manage what alerts you receive',
                  scale:
                      scale,
                  onTap:
                      _notificationPreferences,
                ),

                _settingCard(
                  assetPath:
                      security,
                  title:
                      'Security Alert List',
                  subtitle:
                      'View and manage security alerts',
                  scale:
                      scale,
                  onTap:
                      _securityAlerts,
                ),

                _settingCard(
                  assetPath:
                      feed,
                  title:
                      'Feed Settings',
                  subtitle:
                      'Customize your community feed',
                  scale:
                      scale,
                  onTap:
                      _feedSettings,
                ),

                SizedBox(
                  height: 8 * scale,
                ),

                // ==================================================
                // PURCHASES
                // ==================================================

                _sectionHeader(
                  'Purchases',
                  scale,
                ),

                SizedBox(
                  height: 7 * scale,
                ),

                _settingCard(
                  assetPath:
                      orders,
                  title:
                      'My Orders',
                  subtitle:
                      'Track your purchases',
                  scale:
                      scale,
                  onTap:
                      _myOrders,
                ),

                _settingCard(
                  assetPath:
                      plans,
                  title:
                      'My Plans',
                  subtitle:
                      '$selectedPlan Active',
                  badge:
                      selectedPlan,
                  scale:
                      scale,
                  onTap:
                      _myPlans,
                ),

                SizedBox(
                  height: 8 * scale,
                ),

                // ==================================================
                // MANAGE FLATS
                // ==================================================

                _sectionHeader(
                  'Manage Flats',
                  scale,
                ),

                SizedBox(
                  height: 7 * scale,
                ),

                ...properties.map(
                  (property) {
                    return _settingCard(
                      assetPath:
                          home,
                      title:
                          property[
                              'name'] as String,
                      badge:
                          property[
                                      'active'] ==
                                  true
                              ? 'Active'
                              : null,
                      badgeColor:
                          Colors.green,
                      scale:
                          scale,
                      onTap: () {
                        _selectProperty(
                          property,
                        );
                      },
                    );
                  },
                ),

                _settingCard(
                  assetPath:
                      addVilla,
                  title:
                      'Add Flat/Villa/Office',
                  subtitle:
                      'Link another property',
                  scale:
                      scale,
                  onTap:
                      _addProperty,
                ),

                SizedBox(
                  height: 8 * scale,
                ),

                // ==================================================
                // GENERAL SETTINGS
                // ==================================================

                _sectionHeader(
                  'GENERAL SETTINGS',
                  scale,
                ),

                SizedBox(
                  height: 7 * scale,
                ),

                _settingCard(
                  assetPath:
                      support,
                  title:
                      'Support & Feedback',
                  subtitle:
                      'Get help or share your thoughts',
                  scale:
                      scale,
                  onTap:
                      _openHelpSupport,
                ),

                _settingCard(
                  assetPath:
                      send,
                  title:
                      'Tell a friend about Nivaas',
                  subtitle:
                      'Invite your neighbours',
                  scale:
                      scale,
                  onTap:
                      _tellFriend,
                ),

                _settingCard(
                  assetPath:
                      user,
                  title:
                      'Account Information',
                  subtitle:
                      'Manage your personal details',
                  scale:
                      scale,
                  onTap:
                      _openProfile,
                ),

                _settingCard(
                  assetPath:
                      logout,
                  title:
                      'Logout',
                  subtitle:
                      'Sign out of your account',
                  titleColor:
                      Colors.red,
                  scale:
                      scale,
                  onTap:
                      _logout,
                ),

                SizedBox(
                  height: 12 * scale,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE CARD
  // ============================================================

  Widget _profileCard(
    double scale,
  ) {
    return _card(
      height: 72 * scale,
      radius: 11 * scale,
      child: Padding(
        padding:
            EdgeInsets.symmetric(
          horizontal: 11 * scale,
        ),
        child: Row(
          children: [
            // PROFILE LETTER
            Container(
              width: 46 * scale,
              height: 46 * scale,
              decoration:
                  const BoxDecoration(
                color:
                    Color(0xFFFFA000),
                shape: BoxShape.circle,
              ),
              alignment:
                  Alignment.center,
              child: Text(
                'A',
                style: TextStyle(
                  fontSize:
                      18 * scale,
                  color:
                      Colors.black,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ),

            SizedBox(
              width: 11 * scale,
            ),

            // USER DETAILS
            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    'User Name',
                    style: TextStyle(
                      fontSize:
                          15 * scale,
                      fontWeight:
                          FontWeight.w700,
                      color:
                          darkText,
                    ),
                  ),

                  SizedBox(
                    height: 4 * scale,
                  ),

                  Text(
                    'Nivaas Hub ID : 00000',
                    style: TextStyle(
                      fontSize:
                          10 * scale,
                      color:
                          greyText,
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // SCANNER
            //
            // DIRECT IMAGE.
            // NO EXTRA CARD.
            // ==================================================

            GestureDetector(
              onTap:
                  _openScanner,
              child: Image.asset(
                scanner,
                width: 35 * scale,
                height: 35 * scale,
                fit:
                    BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // COMPLETE PROFILE
  // ============================================================

  Widget _completeProfileCard(
    double scale,
  ) {
    return _card(
      height: 52 * scale,
      radius: 10 * scale,
      child: Padding(
        padding:
            EdgeInsets.symmetric(
          horizontal: 9 * scale,
        ),
        child: Row(
          children: [
            Container(
              width: 31 * scale,
              height: 31 * scale,
              decoration:
                  const BoxDecoration(
                color:
                    Color(0xFFFFEEF0),
                shape:
                    BoxShape.circle,
              ),
              alignment:
                  Alignment.center,
              child: Text(
                '0%',
                style: TextStyle(
                  color:
                      Colors.red,
                  fontSize:
                      8.5 * scale,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),

            SizedBox(
              width: 9 * scale,
            ),

            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    'Complete your profile',
                    style: TextStyle(
                      fontSize:
                          12 * scale,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                  SizedBox(
                    height: 3 * scale,
                  ),

                  Text(
                    'Let neighbours discover you!',
                    style: TextStyle(
                      fontSize:
                          9 * scale,
                      color:
                          greyText,
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap:
                  _openProfile,
              child: Text(
                'View Profile',
                style: TextStyle(
                  color:
                      primaryBlue,
                  fontSize:
                      9.5 * scale,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HOUSEHOLD CARD
  //
  // IMPORTANT:
  // ONE WHITE CARD ONLY.
  //
  // LOGO IS DIRECTLY INSIDE.
  // NO EXTRA ICON CARD.
  // ============================================================

  Widget _householdCard({
    required String imagePath,
    required String title,
    required String subtitle,
    required double scale,
    String? rating,
    bool showRating = false,
    bool showAdd = false,
    VoidCallback? onAdd,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(
          10 * scale,
        ),
        child: Container(
          // ==================================================
          // INCREASED HEIGHT
          // ==================================================

          height: 82 * scale,

          padding:
              EdgeInsets.fromLTRB(
            8 * scale,
            6 * scale,
            7 * scale,
            6 * scale,
          ),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(
              10 * scale,
            ),
            border: Border.all(
              color:
                  borderColor,
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(
                  alpha: 0.08,
                ),
                blurRadius: 3,
                offset:
                    const Offset(
                  0,
                  2,
                ),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              // ==================================================
              // TOP ROW
              // ==================================================

              SizedBox(
                height: 32 * scale,
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    // DIRECT LOGO
                    Image.asset(
                      imagePath,
                      width:
                          32 * scale,
                      height:
                          32 * scale,
                      fit:
                          BoxFit.contain,
                    ),

                    const Spacer(),

                    // ==================================================
                    // RATING
                    // ==================================================

                    if (showRating)
                      Padding(
                        padding:
                            EdgeInsets.only(
                          top:
                              3 * scale,
                          right:
                              3 * scale,
                        ),
                        child: Row(
                          mainAxisSize:
                              MainAxisSize
                                  .min,
                          children: [
                            Icon(
                              Icons.star,
                              color:
                                  const Color(
                                0xFFFF9800,
                              ),
                              size:
                                  11 * scale,
                            ),

                            SizedBox(
                              width:
                                  2 * scale,
                            ),

                            Text(
                              rating ??
                                  '',
                              style:
                                  TextStyle(
                                fontSize:
                                    9 *
                                        scale,
                                fontWeight:
                                    FontWeight
                                        .w700,
                                color:
                                    darkText,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // ==================================================
                    // ADD BUTTON
                    // ==================================================

                    if (showAdd)
                      GestureDetector(
                        onTap:
                            onAdd,
                        child:
                            Container(
                          height:
                              20 * scale,
                          padding:
                              EdgeInsets.symmetric(
                            horizontal:
                                5 * scale,
                          ),
                          alignment:
                              Alignment
                                  .center,
                          decoration:
                              BoxDecoration(
                            color:
                                Colors.white,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              5 * scale,
                            ),
                            border:
                                Border.all(
                              color:
                                  const Color(
                                0xFFD9DEE3,
                              ),
                              width:
                                  0.7,
                            ),
                          ),
                          child:
                              Text(
                            '+ Add',
                            style:
                                TextStyle(
                              color:
                                  primaryBlue,
                              fontSize:
                                  8.5 *
                                      scale,
                              fontWeight:
                                  FontWeight
                                      .w600,
                              height:
                                  1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(
                height: 3 * scale,
              ),

              // ==================================================
              // TITLE
              // ==================================================

              Text(
                title,
                maxLines: 1,
                overflow:
                    TextOverflow
                        .ellipsis,
                style: TextStyle(
                  color:
                      darkText,
                  fontSize:
                      12.5 * scale,
                  fontWeight:
                      FontWeight
                          .w700,
                  height: 1,
                ),
              ),

              SizedBox(
                height: 3 * scale,
              ),

              // ==================================================
              // SUBTITLE
              // ==================================================

              Text(
                subtitle,
                maxLines: 1,
                overflow:
                    TextOverflow
                        .ellipsis,
                style: TextStyle(
                  color:
                      greyText,
                  fontSize:
                      9 * scale,
                  fontWeight:
                      FontWeight
                          .w400,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ADDRESS CARD
  // ============================================================

  Widget _addressCard(
    double scale,
  ) {
    return _card(
      height: 62 * scale,
      radius: 10 * scale,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              _openAddress,
          borderRadius:
              BorderRadius.circular(
            10 * scale,
          ),
          child: Padding(
            padding:
                EdgeInsets.symmetric(
              horizontal:
                  11 * scale,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        'My Address',
                        style:
                            TextStyle(
                          fontSize:
                              13.5 *
                                  scale,
                          fontWeight:
                              FontWeight
                                  .w700,
                          color:
                              darkText,
                        ),
                      ),

                      SizedBox(
                        height:
                            4 * scale,
                      ),

                      Text(
                        'Address Details',
                        style:
                            TextStyle(
                          fontSize:
                              9.5 *
                                  scale,
                          color:
                              greyText,
                        ),
                      ),
                    ],
                  ),
                ),

                // ==================================================
                // SMALL SHARE ICON
                // ==================================================

                Image.asset(
                  shareAction,
                  width:
                      18 * scale,
                  height:
                      18 * scale,
                  fit:
                      BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // NOTIFICATION BANNER
  // ============================================================

  Widget _notificationBanner(
    double scale,
  ) {
    return Container(
      height: 44 * scale,
      padding:
          EdgeInsets.symmetric(
        horizontal:
            10 * scale,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(0xFFFFFAEE),
        borderRadius:
            BorderRadius.circular(
          9 * scale,
        ),
        border: Border.all(
          color:
              const Color(
            0xFFFFD477,
          ),
          width: 0.7,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Not Getting Notifications?',
              style:
                  TextStyle(
                color:
                    const Color(
                  0xFFFF8A00,
                ),
                fontSize:
                    9.5 * scale,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),

          SizedBox(
            height:
                28 * scale,
            child:
                ElevatedButton(
              onPressed:
                  _testNotification,
              style:
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    const Color(
                  0xFFFF8A00,
                ),
                foregroundColor:
                    Colors.white,
                elevation: 0,
                padding:
                    EdgeInsets.symmetric(
                  horizontal:
                      10 * scale,
                ),
                minimumSize:
                    Size.zero,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                    7 * scale,
                  ),
                ),
              ),
              child:
                  Text(
                'Test Now',
                style:
                    TextStyle(
                  fontSize:
                      8.5 * scale,
                  fontWeight:
                      FontWeight
                          .w700,
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
  //
  // ONE WHITE CARD.
  // DIRECT PNG.
  // NO EXTRA ICON CARD.
  // ============================================================

  Widget _settingCard({
    required String assetPath,
    required String title,
    String? subtitle,
    String? badge,
    Color? badgeColor,
    Color? titleColor,
    required double scale,
    required VoidCallback onTap,
  }) {
    return Container(
      height:
          59 * scale,
      margin:
          EdgeInsets.only(
        bottom:
            7 * scale,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(
          10 * scale,
        ),
        border: Border.all(
          color:
              borderColor,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
              alpha: 0.07,
            ),
            blurRadius: 3,
            offset:
                const Offset(
              0,
              2,
            ),
          ),
        ],
      ),
      child: Material(
        color:
            Colors.transparent,
        child: InkWell(
          onTap:
              onTap,
          borderRadius:
              BorderRadius.circular(
            10 * scale,
          ),
          child: Padding(
            padding:
                EdgeInsets.symmetric(
              horizontal:
                  10 * scale,
            ),
            child: Row(
              children: [
                // DIRECT IMAGE
                Image.asset(
                  assetPath,
                  width:
                      30 * scale,
                  height:
                      30 * scale,
                  fit:
                      BoxFit.contain,
                ),

                SizedBox(
                  width:
                      11 * scale,
                ),

                // TEXT
                Expanded(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style:
                            TextStyle(
                          color:
                              titleColor ??
                                  darkText,
                          fontSize:
                              14 *
                                  scale,
                          fontWeight:
                              FontWeight
                                  .w600,
                          height:
                              1.05,
                        ),
                      ),

                      if (subtitle !=
                          null) ...[
                        SizedBox(
                          height:
                              3 * scale,
                        ),

                        Text(
                          subtitle,
                          maxLines:
                              1,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                          style:
                              TextStyle(
                            color:
                                greyText,
                            fontSize:
                                9.5 *
                                    scale,
                            fontWeight:
                                FontWeight
                                    .w400,
                            height:
                                1.05,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // BADGE
                if (badge !=
                    null)
                  Container(
                    margin:
                        EdgeInsets.only(
                      right:
                          6 * scale,
                    ),
                    padding:
                        EdgeInsets.symmetric(
                      horizontal:
                          6 * scale,
                      vertical:
                          3 * scale,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          (badgeColor ??
                                  primaryBlue)
                              .withValues(
                        alpha:
                            0.10,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        7 * scale,
                      ),
                    ),
                    child:
                        Text(
                      badge,
                      style:
                          TextStyle(
                        color:
                            badgeColor ??
                                primaryBlue,
                        fontSize:
                            7.5 *
                                scale,
                        fontWeight:
                            FontWeight
                                .w700,
                      ),
                    ),
                  ),

                // CHEVRON
                Icon(
                  Icons
                      .chevron_right,
                  color:
                      const Color(
                    0xFF55595D,
                  ),
                  size:
                      19 * scale,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _sectionHeader(
    String title,
    double scale, {
    Widget? trailing,
  }) {
    return SizedBox(
      height:
          20 * scale,
      child: Row(
        children: [
          Container(
            width:
                3 * scale,
            height:
                15 * scale,
            decoration:
                BoxDecoration(
              color:
                  primaryBlue,
              borderRadius:
                  BorderRadius
                      .circular(
                2,
              ),
            ),
          ),

          SizedBox(
            width:
                6 * scale,
          ),

          Expanded(
            child: Text(
              title,
              style:
                  TextStyle(
                color:
                    darkText,
                fontSize:
                    14 * scale,
                fontWeight:
                    FontWeight
                        .w700,
                height:
                    1,
              ),
            ),
          ),

          ?trailing,
        ],
      ),
    );
  }

  // ============================================================
  // GENERIC CARD
  // ============================================================

  Widget _card({
    required double height,
    required double radius,
    required Widget child,
  }) {
    return Container(
      height:
          height,
      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(
          radius,
        ),
        border: Border.all(
          color:
              borderColor,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
              alpha: 0.07,
            ),
            blurRadius: 3,
            offset:
                const Offset(
              0,
              2,
            ),
          ),
        ],
      ),
      child:
          child,
    );
  }

  // ============================================================
  // SHEET HANDLE
  // ============================================================

  Widget _sheetHandle() {
    return Container(
      width: 38,
      height: 4,
      decoration:
          BoxDecoration(
        color:
            Colors.grey.shade300,
        borderRadius:
            BorderRadius.circular(
          10,
        ),
      ),
    );
  }

  // ============================================================
  // SHEET ITEM
  // ============================================================

  Widget _sheetItem(
    String imagePath,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 30,
            height: 30,
            fit:
                BoxFit.contain,
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(
                    fontSize:
                        14,
                    fontWeight:
                        FontWeight
                            .w600,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  subtitle,
                  style:
                      const TextStyle(
                    fontSize:
                        11,
                    color:
                        greyText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUMMARY ITEM
  // ============================================================

  Widget _summaryItem(
    String imagePath,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 30,
            height: 30,
            fit:
                BoxFit.contain,
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(
                    fontSize:
                        14,
                    fontWeight:
                        FontWeight
                            .w600,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  subtitle,
                  style:
                      const TextStyle(
                    fontSize:
                        11,
                    color:
                        greyText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SWITCH TILE
  // ============================================================

  Widget _switchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool>
        onChanged,
  ) {
    return SwitchListTile(
      contentPadding:
          EdgeInsets.zero,
      title: Text(
        title,
        style:
            const TextStyle(
          fontSize: 15,
          fontWeight:
              FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style:
            const TextStyle(
          fontSize: 12,
          color:
              greyText,
        ),
      ),
      value:
          value,
      activeThumbColor:
          primaryBlue,
      onChanged:
          onChanged,
    );
  }
}