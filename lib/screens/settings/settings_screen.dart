// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:flutter_nivasshub/constants/app_colors.dart';
// import 'package:flutter_nivasshub/providers/theme/theme_mode_provider.dart';
// import 'package:flutter_nivasshub/routes/app_routes.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   // ============================================================
//   // THEME
//   // ============================================================

//   bool get _isDark => Theme.of(context).brightness == Brightness.dark;

//   Color get backgroundColor => _isDark
//       ? AppColors.settingsBackgroundDark
//       : AppColors.settingsBackgroundLight;
//   Color get headerColor =>
//       _isDark ? AppColors.settingsHeaderDark : AppColors.settingsHeaderLight;
//   Color get primaryBlue => _isDark
//       ? AppColors.settingsPrimaryBlueDark
//       : AppColors.settingsPrimaryBlueLight;
//   Color get lightBlue => _isDark
//       ? AppColors.settingsLightBlueDark
//       : AppColors.settingsLightBlueLight;
//   Color get darkText =>
//       _isDark ? AppColors.textPrimaryDark : AppColors.settingsTextPrimaryLight;
//   Color get greyText => _isDark
//       ? AppColors.textSecondaryDark
//       : AppColors.settingsTextSecondaryLight;
//   Color get borderColor =>
//       _isDark ? AppColors.borderDark : AppColors.settingsBorderLight;
//   Color get sheetBackgroundColor =>
//       _isDark ? AppColors.surfaceDark : Colors.white;

//   // ============================================================
//   // LOCAL VALUES
//   // ============================================================

//   int familyCount = 1;
//   int dailyHelpCount = 0;
//   int vehicleCount = 0;
//   int petCount = 0;

//   String selectedPlan = 'Ad-Supported';

//   bool notificationEnabled = true;
//   bool securityEnabled = true;
//   bool feedEnabled = false;

//   final List<Map<String, dynamic>> properties = [
//     {'name': 'B-402, Golden Residency', 'active': true},
//   ];

//   // ============================================================
//   // MESSAGE
//   // ============================================================

//   void _message(String text) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context).hideCurrentSnackBar();

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(text),
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   // ============================================================
//   // PROFILE
//   // ============================================================

//   void _openProfile() {
//     Navigator.pushNamed(context, AppRoutes.profile);
//   }

//   // ============================================================
//   // HELP & SUPPORT
//   // ============================================================

//   void _openHelpSupport() {
//     Navigator.pushNamed(context, AppRoutes.helpSupport);
//   }

//   // ============================================================
//   // NOTIFICATION PREFERENCES
//   // ============================================================

//   void _notificationPreferences() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: sheetBackgroundColor,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Padding(
//               padding: const EdgeInsets.fromLTRB(18, 12, 18, 25),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _sheetHandle(),

//                   const SizedBox(height: 18),

//                   const Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'Notification Preferences',
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   SwitchListTile(
//                     contentPadding: EdgeInsets.zero,
//                     title: const Text(
//                       'Notification Alerts',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     subtitle: const Text(
//                       'Manage what alerts you receive',
//                       style: TextStyle(fontSize: 11),
//                     ),
//                     value: notificationEnabled,
//                     activeThumbColor: primaryBlue,
//                     onChanged: (value) {
//                       setModalState(() {
//                         notificationEnabled = value;
//                       });

//                       setState(() {
//                         notificationEnabled = value;
//                       });
//                     },
//                   ),

//                   SwitchListTile(
//                     contentPadding: EdgeInsets.zero,
//                     title: const Text(
//                       'Security Alerts',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     subtitle: const Text(
//                       'Receive security notifications',
//                       style: TextStyle(fontSize: 11),
//                     ),
//                     value: securityEnabled,
//                     activeThumbColor: primaryBlue,
//                     onChanged: (value) {
//                       setModalState(() {
//                         securityEnabled = value;
//                       });

//                       setState(() {
//                         securityEnabled = value;
//                       });
//                     },
//                   ),

//                   SwitchListTile(
//                     contentPadding: EdgeInsets.zero,
//                     title: const Text(
//                       'Community Feed',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     subtitle: const Text(
//                       'Customize your community feed',
//                       style: TextStyle(fontSize: 11),
//                     ),
//                     value: feedEnabled,
//                     activeThumbColor: primaryBlue,
//                     onChanged: (value) {
//                       setModalState(() {
//                         feedEnabled = value;
//                       });

//                       setState(() {
//                         feedEnabled = value;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // ============================================================
//   // SECURITY ALERTS
//   // ============================================================

//   void _securityAlerts() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: sheetBackgroundColor,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.fromLTRB(18, 12, 18, 25),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _sheetHandle(),

//               const SizedBox(height: 18),

//               const Text(
//                 'Security Alert List',
//                 style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
//               ),

//               const SizedBox(height: 12),

//               _sheetItem(
//                 Icons.shield_outlined,
//                 'Visitor entry approved',
//                 'Today, 11:30 AM',
//               ),

//               _sheetItem(
//                 Icons.local_shipping_outlined,
//                 'Delivery received',
//                 'Today, 10:15 AM',
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ============================================================
//   // FEED SETTINGS
//   // ============================================================

//   void _feedSettings() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: sheetBackgroundColor,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Padding(
//               padding: const EdgeInsets.fromLTRB(18, 12, 18, 25),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _sheetHandle(),

//                   const SizedBox(height: 18),

//                   const Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'Feed Settings',
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   SwitchListTile(
//                     contentPadding: EdgeInsets.zero,
//                     title: const Text(
//                       'Community Feed',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     subtitle: const Text(
//                       'Customize your community feed',
//                       style: TextStyle(fontSize: 11),
//                     ),
//                     value: feedEnabled,
//                     activeThumbColor: primaryBlue,
//                     onChanged: (value) {
//                       setModalState(() {
//                         feedEnabled = value;
//                       });

//                       setState(() {
//                         feedEnabled = value;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // ============================================================
//   // ORDERS
//   // ============================================================

//   void _myOrders() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: sheetBackgroundColor,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.fromLTRB(18, 12, 18, 25),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _sheetHandle(),

//               const SizedBox(height: 18),

//               const Text(
//                 'My Orders',
//                 style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
//               ),

//               const SizedBox(height: 12),

//               _sheetItem(
//                 Icons.shopping_bag_outlined,
//                 'Community Store',
//                 'Completed',
//               ),

//               _sheetItem(
//                 Icons.receipt_long_outlined,
//                 'Maintenance Payment',
//                 'Completed',
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ============================================================
//   // PLANS
//   // ============================================================

//   void _myPlans() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: sheetBackgroundColor,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Padding(
//               padding: const EdgeInsets.fromLTRB(18, 12, 18, 25),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _sheetHandle(),

//                   const SizedBox(height: 18),

//                   const Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'My Plans',
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   RadioGroup<String>(
//                     groupValue: selectedPlan,
//                     onChanged: (value) {
//                       if (value == null) return;

//                       setModalState(() {
//                         selectedPlan = value;
//                       });

//                       setState(() {
//                         selectedPlan = value;
//                       });
//                     },
//                     child: Column(
//                       children: [
//                         RadioListTile<String>(
//                           contentPadding: EdgeInsets.zero,
//                           value: 'Ad-Supported',
//                           activeColor: primaryBlue,
//                           title: const Text('Ad-Supported'),
//                           subtitle: const Text('Free plan'),
//                         ),

//                         RadioListTile<String>(
//                           contentPadding: EdgeInsets.zero,
//                           value: 'Premium',
//                           activeColor: primaryBlue,
//                           title: const Text('Nivaas Premium (₹99/mo)'),
//                           subtitle: const Text('Premium'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // ============================================================
//   // THEME PICKER
//   // ============================================================

//   String _themeModeLabel(ThemeMode mode) {
//     switch (mode) {
//       case ThemeMode.system:
//         return 'System';
//       case ThemeMode.light:
//         return 'Light';
//       case ThemeMode.dark:
//         return 'Dark';
//     }
//   }

//   void _chooseTheme() {
//     showModalBottomSheet(
//       context: context,
//       // Transparent here on purpose: `sheetBackgroundColor` would be
//       // captured once at the moment this sheet opens and never update —
//       // if the user then taps a different theme option, the sheet's own
//       // background would stay frozen on the old theme's color while its
//       // text (sourced from the ambient, now-rebuilt Theme) flips to the
//       // new theme's color, risking invisible text. Painting the
//       // background inside the `Consumer` below instead keeps it reactive
//       // to the same theme change the radio tiles respond to.
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return Consumer<ThemeModeProvider>(
//           builder: (context, themeModeProvider, _) {
//             return DecoratedBox(
//               decoration: BoxDecoration(
//                 color: sheetBackgroundColor,
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(20),
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(18, 12, 18, 25),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     _sheetHandle(),

//                     const SizedBox(height: 18),

//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'Theme',
//                         style: TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     RadioGroup<ThemeMode>(
//                       groupValue: themeModeProvider.themeMode,
//                       onChanged: (mode) {
//                         if (mode == null) return;
//                         themeModeProvider.setThemeMode(mode);
//                       },
//                       child: Column(
//                         children: [
//                           RadioListTile<ThemeMode>(
//                             contentPadding: EdgeInsets.zero,
//                             value: ThemeMode.system,
//                             activeColor: primaryBlue,
//                             title: const Text('System'),
//                             subtitle: const Text('Match your device setting'),
//                           ),

//                           RadioListTile<ThemeMode>(
//                             contentPadding: EdgeInsets.zero,
//                             value: ThemeMode.light,
//                             activeColor: primaryBlue,
//                             title: const Text('Light'),
//                             subtitle: const Text('Always use light theme'),
//                           ),

//                           RadioListTile<ThemeMode>(
//                             contentPadding: EdgeInsets.zero,
//                             value: ThemeMode.dark,
//                             activeColor: primaryBlue,
//                             title: const Text('Dark'),
//                             subtitle: const Text('Always use dark theme'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // ============================================================
//   // ADD PROPERTY
//   // ============================================================

//   void _addProperty() {
//     final controller = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           title: const Text('Add Flat/Villa/Office'),
//           content: TextField(
//             controller: controller,
//             decoration: const InputDecoration(
//               hintText: 'Enter property name',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(dialogContext);
//               },
//               child: const Text('Cancel'),
//             ),

//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryBlue,
//                 foregroundColor: Colors.white,
//               ),
//               onPressed: () {
//                 final value = controller.text.trim();

//                 if (value.isNotEmpty) {
//                   setState(() {
//                     properties.add({'name': value, 'active': false});
//                   });
//                 }

//                 Navigator.pop(dialogContext);
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // ============================================================
//   // LOGOUT
//   // ============================================================

//   void _logout() {
//     showDialog(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           title: const Text('Logout'),
//           content: const Text('Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(dialogContext);
//               },
//               child: const Text('Cancel'),
//             ),

//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//               ),
//               onPressed: () {
//                 Navigator.pop(dialogContext);

//                 if (!mounted) return;

//                 Navigator.pushNamedAndRemoveUntil(
//                   context,
//                   AppRoutes.login,
//                   (route) => false,
//                 );
//               },
//               child: const Text('Logout'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // ============================================================
//   // ADD HOUSEHOLD
//   // ============================================================

//   void _addHousehold(String type) {
//     setState(() {
//       switch (type) {
//         case 'Family':
//           familyCount++;
//           break;

//         case 'Daily Help':
//           dailyHelpCount++;
//           break;

//         case 'Vehicles':
//           vehicleCount++;
//           break;

//         case 'Pets':
//           petCount++;
//           break;
//       }
//     });

//     _message('$type added successfully');
//   }

//   // ============================================================
//   // TEST NOTIFICATION
//   // ============================================================

//   void _testNotification() {
//     _message('Test notification sent successfully');
//   }

//   // ============================================================
//   // BUILD
//   // ============================================================

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,

//       // ========================================================
//       // APP BAR
//       // ========================================================
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(58),
//         child: AppBar(
//           backgroundColor: headerColor,
//           elevation: 0,
//           scrolledUnderElevation: 0,
//           centerTitle: true,
//           leadingWidth: 40,

//           leading: IconButton(
//             padding: EdgeInsets.zero,
//             icon: Icon(
//               Icons.arrow_back,
//               color: _isDark ? AppColors.textPrimaryDark : Colors.black,
//               size: 18,
//             ),
//             onPressed: () {
//               Navigator.maybePop(context);
//             },
//           ),

//           title: Text(
//             'Settings',
//             style: TextStyle(
//               color: _isDark ? AppColors.textPrimaryDark : Colors.black,
//               fontSize: 12,
//               fontWeight: FontWeight.w700,
//             ),
//           ),

//           actions: [
//             IconButton(
//               padding: const EdgeInsets.only(right: 10),
//               icon: Icon(
//                 Icons.help_outline,
//                 color: _isDark ? AppColors.textPrimaryDark : Colors.black,
//                 size: 18,
//               ),
//               onPressed: _openHelpSupport,
//             ),
//           ],
//         ),
//       ),

//       // ========================================================
//       // BODY
//       // ========================================================
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final width = constraints.maxWidth;

//             final scale = (width / 313).clamp(0.95, 1.12);

//             return ListView(
//               physics: const BouncingScrollPhysics(),

//               padding: EdgeInsets.fromLTRB(
//                 12 * scale,
//                 10 * scale,
//                 12 * scale,
//                 5 * scale,
//               ),

//               children: [
//                 // ==================================================
//                 // PROFILE
//                 // ==================================================
//                 _profileCard(scale),

//                 SizedBox(height: 8 * scale),

//                 // ==================================================
//                 // COMPLETE PROFILE
//                 // ==================================================
//                 _completeProfileCard(scale),

//                 SizedBox(height: 3 * scale),

//                 // ==================================================
//                 // HOUSEHOLD
//                 // ==================================================
//                 _sectionHeader(
//                   'Household',
//                   scale,
//                   trailing: GestureDetector(
//                     onTap: () {
//                       _message('Household details');
//                     },
//                     child: Text(
//                       'View all  ›',
//                       style: TextStyle(
//                         color: primaryBlue,
//                         fontSize: 8 * scale,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: 6 * scale),

//                 Row(
//                   children: [
//                     Expanded(
//                       child: _householdCard(
//                         icon: Icons.face_outlined,
//                         title: 'InstaHelp',
//                         subtitle: '1 Mn+ houses',
//                         rating: '4.8',
//                         showRating: true,
//                         scale: scale,
//                       ),
//                     ),

//                     SizedBox(width: 6 * scale),

//                     Expanded(
//                       child: _householdCard(
//                         icon: Icons.person_outline,
//                         title: 'Family',
//                         subtitle: '$familyCount member',
//                         showAdd: true,
//                         scale: scale,
//                         onAdd: () {
//                           _addHousehold('Family');
//                         },
//                       ),
//                     ),
//                   ],
//                 ),

//                 SizedBox(height: 3 * scale),

//                 Row(
//                   children: [
//                     Expanded(
//                       child: _householdCard(
//                         icon: Icons.person_add_alt_1_outlined,
//                         title: 'Daily Help',
//                         subtitle: dailyHelpCount == 0
//                             ? 'Add helper'
//                             : '$dailyHelpCount added',
//                         showAdd: true,
//                         scale: scale,
//                         onAdd: () {
//                           _addHousehold('Daily Help');
//                         },
//                       ),
//                     ),

//                     SizedBox(width: 6 * scale),

//                     Expanded(
//                       child: _householdCard(
//                         icon: Icons.directions_car_outlined,
//                         title: 'Vehicles',
//                         subtitle: vehicleCount == 0
//                             ? 'Add vehicle'
//                             : '$vehicleCount added',
//                         showAdd: true,
//                         scale: scale,
//                         onAdd: () {
//                           _addHousehold('Vehicles');
//                         },
//                       ),
//                     ),
//                   ],
//                 ),

//                 SizedBox(height: 3 * scale),

//                 Row(
//                   children: [
//                     Expanded(
//                       child: _householdCard(
//                         icon: Icons.pets_outlined,
//                         title: 'Pets',
//                         subtitle: petCount == 0 ? 'Add pet' : '$petCount added',
//                         showAdd: true,
//                         scale: scale,
//                         onAdd: () {
//                           _addHousehold('Pets');
//                         },
//                       ),
//                     ),

//                     const Expanded(child: SizedBox()),
//                   ],
//                 ),

//                 SizedBox(height: 10 * scale),

//                 // ==================================================
//                 // ADDRESS
//                 // ==================================================
//                 _addressCard(scale),

//                 SizedBox(height: 9 * scale),

//                 // ==================================================
//                 // NOTIFICATION
//                 // ==================================================
//                 _notificationBanner(scale),

//                 SizedBox(height: 10 * scale),

//                 // ==================================================
//                 // SECURITY & NOTIFICATIONS
//                 // ==================================================
//                 _sectionHeader('Security & Notifications', scale),

//                 SizedBox(height: 5 * scale),

//                 _settingCard(
//                   icon: Icons.notifications_none,
//                   title: 'Notification Preferences',
//                   subtitle: 'Manage what alerts you receive',
//                   scale: scale,
//                   onTap: _notificationPreferences,
//                 ),

//                 _settingCard(
//                   icon: Icons.shield_outlined,
//                   title: 'Security Alert List',
//                   subtitle: 'View and manage security alerts',
//                   scale: scale,
//                   onTap: _securityAlerts,
//                 ),

//                 _settingCard(
//                   icon: Icons.article_outlined,
//                   title: 'Feed Settings',
//                   subtitle: 'Customize your community feed',
//                   scale: scale,
//                   onTap: _feedSettings,
//                 ),

//                 SizedBox(height: 7 * scale),

//                 // ==================================================
//                 // PURCHASES
//                 // ==================================================
//                 _sectionHeader('Purchases', scale),

//                 SizedBox(height: 5 * scale),

//                 _settingCard(
//                   icon: Icons.shopping_bag_outlined,
//                   title: 'My Orders',
//                   subtitle: 'Track your purchases',
//                   scale: scale,
//                   onTap: _myOrders,
//                 ),

//                 _settingCard(
//                   icon: Icons.credit_card_outlined,
//                   title: 'My Plans',
//                   subtitle: 'Ad-Supported Active',
//                   badge: selectedPlan,
//                   scale: scale,
//                   onTap: _myPlans,
//                 ),

//                 SizedBox(height: 7 * scale),

//                 // ==================================================
//                 // MANAGE FLATS
//                 // ==================================================
//                 _sectionHeader('Manage Flats', scale),

//                 SizedBox(height: 5 * scale),

//                 ...properties.map((property) {
//                   return _settingCard(
//                     icon: Icons.home_outlined,
//                     title: property['name'] as String,
//                     badge: property['active'] == true ? 'Active' : null,
//                     badgeColor: Colors.green,
//                     scale: scale,
//                     onTap: () {
//                       setState(() {
//                         for (final item in properties) {
//                           item['active'] = false;
//                         }

//                         property['active'] = true;
//                       });

//                       _message('${property['name']} selected');
//                     },
//                   );
//                 }),

//                 _settingCard(
//                   icon: Icons.add_business_outlined,
//                   title: 'Add Flat/Villa/Office',
//                   subtitle: 'Link another property',
//                   scale: scale,
//                   onTap: _addProperty,
//                 ),

//                 SizedBox(height: 7 * scale),

//                 // ==================================================
//                 // GENERAL SETTINGS
//                 // ==================================================
//                 _sectionHeader('GENERAL SETTINGS', scale),

//                 SizedBox(height: 5 * scale),

//                 _settingCard(
//                   icon: Icons.help_outline,
//                   title: 'Support & Feedback',
//                   subtitle: 'Get help or share your thoughts',
//                   scale: scale,
//                   onTap: _openHelpSupport,
//                 ),

//                 _settingCard(
//                   icon: Icons.send_outlined,
//                   title: 'Tell a friend about mygate',
//                   subtitle: 'Invite your neighbours',
//                   scale: scale,
//                   onTap: () {
//                     _message('Share option opened');
//                   },
//                 ),

//                 _settingCard(
//                   icon: Icons.person_outline,
//                   title: 'Account Information',
//                   subtitle: 'Manage your personal details',
//                   scale: scale,
//                   onTap: _openProfile,
//                 ),

//                 Consumer<ThemeModeProvider>(
//                   builder: (context, themeModeProvider, _) {
//                     return _settingCard(
//                       icon: Icons.brightness_6_outlined,
//                       title: 'Theme',
//                       subtitle: 'Choose light, dark, or match your device',
//                       badge: _themeModeLabel(themeModeProvider.themeMode),
//                       scale: scale,
//                       onTap: _chooseTheme,
//                     );
//                   },
//                 ),

//                 _settingCard(
//                   icon: Icons.logout,
//                   title: 'Logout',
//                   subtitle: 'Sign-out of your account',
//                   iconColor: Colors.red,
//                   titleColor: Colors.red,
//                   scale: scale,
//                   onTap: _logout,
//                 ),

//                 SizedBox(height: 10 * scale),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // PROFILE CARD
//   // ============================================================

//   Widget _profileCard(double scale) {
//     return _card(
//       height: 59 * scale,
//       radius: 10 * scale,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 8 * scale),
//         child: Row(
//           children: [
//             Container(
//               width: 42 * scale,
//               height: 42 * scale,
//               decoration: const BoxDecoration(
//                 color: Color(0xFFFFA000),
//                 shape: BoxShape.circle,
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 'U',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 16 * scale,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),

//             SizedBox(width: 9 * scale),

//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'User Name',
//                     style: TextStyle(
//                       color: darkText,
//                       fontSize: 12 * scale,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),

//                   SizedBox(height: 2 * scale),

//                   Text(
//                     'Nivaas Hub ID : 00000',
//                     style: TextStyle(color: greyText, fontSize: 7.5 * scale),
//                   ),
//                 ],
//               ),
//             ),

//             Container(
//               width: 31 * scale,
//               height: 31 * scale,
//               decoration: BoxDecoration(
//                 color: lightBlue,
//                 borderRadius: BorderRadius.circular(8 * scale),
//               ),
//               child: Icon(
//                 Icons.qr_code_2,
//                 color: primaryBlue,
//                 size: 18 * scale,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // COMPLETE PROFILE
//   // ============================================================

//   Widget _completeProfileCard(double scale) {
//     return _card(
//       height: 44 * scale,
//       radius: 10 * scale,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 8 * scale),
//         child: Row(
//           children: [
//             Container(
//               width: 27 * scale,
//               height: 27 * scale,
//               decoration: BoxDecoration(
//                 color: _isDark
//                     ? AppColors.settingsProfileBadgeBgDark
//                     : AppColors.settingsProfileBadgeBgLight,
//                 shape: BoxShape.circle,
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 '0%',
//                 style: TextStyle(
//                   color: _isDark ? AppColors.noticesDangerTextDark : Colors.red,
//                   fontSize: 7 * scale,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),

//             SizedBox(width: 8 * scale),

//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Complete your profile',
//                     style: TextStyle(
//                       fontSize: 9 * scale,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),

//                   Text(
//                     'Let neighbours discover you!',
//                     style: TextStyle(fontSize: 7 * scale, color: greyText),
//                   ),
//                 ],
//               ),
//             ),

//             GestureDetector(
//               onTap: _openProfile,
//               child: Text(
//                 'View Profile',
//                 style: TextStyle(
//                   color: primaryBlue,
//                   fontSize: 8 * scale,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // SECTION HEADER
//   // ============================================================

//   Widget _sectionHeader(String title, double scale, {Widget? trailing}) {
//     return SizedBox(
//       height: 17 * scale,
//       child: Row(
//         children: [
//           Container(
//             width: 3 * scale,
//             height: 13 * scale,
//             decoration: BoxDecoration(
//               color: primaryBlue,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),

//           SizedBox(width: 5 * scale),

//           Expanded(
//             child: Text(
//               title,
//               style: TextStyle(
//                 color: darkText,
//                 fontSize: 10 * scale,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),

//           ?trailing,
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // HOUSEHOLD CARD
//   // ============================================================

//   Widget _householdCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required double scale,
//     String? rating,
//     bool showRating = false,
//     bool showAdd = false,
//     VoidCallback? onAdd,
//   }) {
//     return _card(
//       height: 64 * scale,
//       radius: 9 * scale,
//       child: Padding(
//         padding: EdgeInsets.fromLTRB(
//           7 * scale,
//           6 * scale,
//           6 * scale,
//           6 * scale,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 26 * scale,
//                   height: 26 * scale,
//                   decoration: BoxDecoration(
//                     color: lightBlue,
//                     borderRadius: BorderRadius.circular(7 * scale),
//                   ),
//                   child: Icon(icon, color: primaryBlue, size: 14 * scale),
//                 ),

//                 const Spacer(),

//                 if (showRating)
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.star,
//                         color: const Color(0xFFFF9800),
//                         size: 9 * scale,
//                       ),

//                       SizedBox(width: 1 * scale),

//                       Text(
//                         rating ?? '',
//                         style: TextStyle(
//                           fontSize: 7 * scale,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ],
//                   ),

//                 if (showAdd)
//                   GestureDetector(
//                     onTap: onAdd,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 5 * scale,
//                         vertical: 2 * scale,
//                       ),
//                       decoration: BoxDecoration(
//                         color: _isDark ? AppColors.surfaceDark : Colors.white,
//                         borderRadius: BorderRadius.circular(5 * scale),
//                         border: Border.all(
//                           color: _isDark
//                               ? AppColors.settingsAddBorderDark
//                               : AppColors.settingsAddBorderLight,
//                         ),
//                       ),
//                       child: Text(
//                         '+ Add',
//                         style: TextStyle(
//                           color: primaryBlue,
//                           fontSize: 6.5 * scale,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),

//             const Spacer(),

//             Text(
//               title,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 color: darkText,
//                 fontSize: 9 * scale,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),

//             SizedBox(height: 1 * scale),

//             Text(
//               subtitle,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(color: greyText, fontSize: 7 * scale),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // ADDRESS CARD
//   // ============================================================

//   Widget _addressCard(double scale) {
//     return _card(
//       height: 54 * scale,
//       radius: 10 * scale,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 9 * scale),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'My Address',
//                     style: TextStyle(
//                       color: darkText,
//                       fontSize: 9 * scale,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),

//                   SizedBox(height: 2 * scale),

//                   Text(
//                     'Address Details',
//                     style: TextStyle(color: greyText, fontSize: 7 * scale),
//                   ),
//                 ],
//               ),
//             ),

//             Icon(Icons.share_outlined, color: primaryBlue, size: 15 * scale),
//           ],
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // NOTIFICATION BANNER
//   // ============================================================

//   Widget _notificationBanner(double scale) {
//     return Container(
//       height: 48 * scale,
//       padding: EdgeInsets.symmetric(horizontal: 8 * scale),
//       decoration: BoxDecoration(
//         color: _isDark
//             ? AppColors.settingsNotifyBgDark
//             : AppColors.settingsNotifyBgLight,
//         borderRadius: BorderRadius.circular(9 * scale),
//         border: Border.all(
//           color: _isDark
//               ? AppColors.settingsNotifyBorderDark
//               : AppColors.settingsNotifyBorderLight,
//           width: 0.8,
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               'Not Getting Notifications?',
//               style: TextStyle(
//                 color: _isDark
//                     ? AppColors.settingsNotifyTextDark
//                     : AppColors.settingsNotifyTextLight,
//                 fontSize: 7 * scale,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),

//           SizedBox(
//             height: 26 * scale,
//             child: ElevatedButton(
//               onPressed: _testNotification,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFFF8A00),
//                 foregroundColor: Colors.white,
//                 elevation: 0,
//                 padding: EdgeInsets.symmetric(horizontal: 10 * scale),
//                 minimumSize: Size.zero,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(6 * scale),
//                 ),
//               ),
//               child: Text(
//                 'Test Now',
//                 style: TextStyle(
//                   fontSize: 7 * scale,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // SETTINGS CARD
//   // ============================================================

//   Widget _settingCard({
//     required IconData icon,
//     required String title,
//     String? subtitle,
//     String? badge,
//     Color? badgeColor,
//     Color? iconColor,
//     Color? titleColor,
//     required double scale,
//     required VoidCallback onTap,
//   }) {
//     final bool hasSubtitle = subtitle != null && subtitle.isNotEmpty;

//     return Container(
//       height: (hasSubtitle ? 52 : 48) * scale,
//       margin: EdgeInsets.only(bottom: 6 * scale),
//       decoration: BoxDecoration(
//         color: _isDark ? AppColors.surfaceDark : Colors.white,
//         borderRadius: BorderRadius.circular(9 * scale),
//         border: Border.all(color: borderColor, width: 0.5),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: _isDark ? 0.4 : 0.08),
//             blurRadius: 3,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(9 * scale),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 7 * scale),
//             child: Row(
//               children: [
//                 Container(
//                   width: 29 * scale,
//                   height: 29 * scale,
//                   decoration: BoxDecoration(
//                     color: iconColor == Colors.red
//                         ? (_isDark
//                               ? AppColors.settingsDangerIconBgDark
//                               : AppColors.settingsDangerIconBgLight)
//                         : lightBlue,
//                     borderRadius: BorderRadius.circular(7 * scale),
//                   ),
//                   child: Icon(
//                     icon,
//                     color: iconColor == Colors.red
//                         ? (_isDark
//                               ? AppColors.noticesDangerTextDark
//                               : Colors.red)
//                         : (iconColor ?? primaryBlue),
//                     size: 15 * scale,
//                   ),
//                 ),

//                 SizedBox(width: 8 * scale),

//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           color: titleColor == Colors.red
//                               ? (_isDark
//                                     ? AppColors.noticesDangerTextDark
//                                     : Colors.red)
//                               : (titleColor ?? darkText),
//                           fontSize: 9.5 * scale,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),

//                       if (hasSubtitle) ...[
//                         SizedBox(height: 2 * scale),
//                         Text(
//                           subtitle,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             color: greyText,
//                             fontSize: 7 * scale,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),

//                 if (badge != null)
//                   Container(
//                     margin: EdgeInsets.only(right: 5 * scale),
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 5 * scale,
//                       vertical: 2 * scale,
//                     ),
//                     decoration: BoxDecoration(
//                       color: (badgeColor ?? primaryBlue).withValues(
//                         alpha: 0.10,
//                       ),
//                       borderRadius: BorderRadius.circular(5 * scale),
//                     ),
//                     child: Text(
//                       badge,
//                       style: TextStyle(
//                         color: badgeColor ?? primaryBlue,
//                         fontSize: 6 * scale,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),

//                 Icon(
//                   Icons.chevron_right,
//                   color: _isDark
//                       ? AppColors.textSecondaryDark
//                       : AppColors.settingsChevronLight,
//                   size: 17 * scale,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // GENERIC CARD
//   // ============================================================

//   Widget _card({
//     required double height,
//     required double radius,
//     required Widget child,
//   }) {
//     return Container(
//       height: height,
//       decoration: BoxDecoration(
//         color: _isDark ? AppColors.surfaceDark : Colors.white,
//         borderRadius: BorderRadius.circular(radius),
//         border: Border.all(color: borderColor, width: 0.5),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: _isDark ? 0.4 : 0.08),
//             blurRadius: 3,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }

//   // ============================================================
//   // SHEET HANDLE
//   // ============================================================

//   Widget _sheetHandle() {
//     return Container(
//       width: 38,
//       height: 4,
//       decoration: BoxDecoration(
//         color: _isDark ? AppColors.borderDark : Colors.grey.shade300,
//         borderRadius: BorderRadius.circular(10),
//       ),
//     );
//   }

//   // ============================================================
//   // SHEET ITEM
//   // ============================================================

//   Widget _sheetItem(IconData icon, String title, String subtitle) {
//     return ListTile(
//       contentPadding: EdgeInsets.zero,
//       leading: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: lightBlue,
//           borderRadius: BorderRadius.circular(9),
//         ),
//         child: Icon(icon, color: primaryBlue, size: 20),
//       ),
//       title: Text(
//         title,
//         style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
//       ),
//       subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: greyText)),
//     );
//   }
// }

//////////////////////////////////////

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
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ============================================================
  // THEME
  // ============================================================

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get backgroundColor => _isDark
      ? AppColors.settingsBackgroundDark
      : AppColors.settingsBackgroundLight;
  Color get headerColor =>
      _isDark ? AppColors.settingsHeaderDark : AppColors.settingsHeaderLight;
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
      _isDark ? AppColors.surfaceDark : Colors.white;

  // ============================================================
  // LOCAL VALUES
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

  // ============================================================
  // PROFILE
  // ============================================================

  void _openProfile() {
    Navigator.pushNamed(context, AppRoutes.profile);
  }

  // ============================================================
  // HELP & SUPPORT
  // ============================================================

  void _openHelpSupport() {
    Navigator.pushNamed(context, AppRoutes.helpSupport);
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
                  Column(
                    children: [
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        value: 'Ad-Supported',
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
                        activeColor: primaryBlue,
                        title: const Text('Ad-Supported'),
                        subtitle: const Text('Free plan'),
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        value: 'Premium',
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
                        activeColor: primaryBlue,
                        title: const Text('Nivaas Premium (₹99/mo)'),
                        subtitle: const Text('Premium'),
                      ),
                    ],
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
                    Column(
                      children: [
                        RadioListTile<ThemeMode>(
                          contentPadding: EdgeInsets.zero,
                          value: ThemeMode.system,
                          groupValue: themeModeProvider.themeMode,
                          onChanged: (mode) {
                            if (mode == null) return;
                            themeModeProvider.setThemeMode(mode);
                          },
                          activeColor: primaryBlue,
                          title: const Text('System'),
                          subtitle: const Text('Match your device setting'),
                        ),
                        RadioListTile<ThemeMode>(
                          contentPadding: EdgeInsets.zero,
                          value: ThemeMode.light,
                          groupValue: themeModeProvider.themeMode,
                          onChanged: (mode) {
                            if (mode == null) return;
                            themeModeProvider.setThemeMode(mode);
                          },
                          activeColor: primaryBlue,
                          title: const Text('Light'),
                          subtitle: const Text('Always use light theme'),
                        ),
                        RadioListTile<ThemeMode>(
                          contentPadding: EdgeInsets.zero,
                          value: ThemeMode.dark,
                          groupValue: themeModeProvider.themeMode,
                          onChanged: (mode) {
                            if (mode == null) return;
                            themeModeProvider.setThemeMode(mode);
                          },
                          activeColor: primaryBlue,
                          title: const Text('Dark'),
                          subtitle: const Text('Always use dark theme'),
                        ),
                      ],
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
                foregroundColor: Colors.white,
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
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                // Read providers before the first `await` — avoids using
                // `context` across an async gap.
                final storage = context.read<SecureStorageService>();
                final auth = context.read<AuthProvider>();
                final dashboard = context.read<DashboardProvider>();

                Navigator.pop(dialogContext);
                debugPrint('[Session] Logout initiated by user');

                // Clear the persisted session (tokens + isLoggedIn flag) so
                // a relaunch/force-restart doesn't auto-navigate back to
                // Dashboard — this is the fix for that exact bug.
                await storage.clearSession();
                debugPrint(
                  '[Session] Storage cleared (tokens + isLoggedIn removed)',
                );

                if (!mounted) return;

                // Reset in-memory state so a subsequent login doesn't
                // inherit stale auth/dashboard data from this session.
                auth.logout();
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
  // ADD HOUSEHOLD
  // ============================================================

  void _addHousehold(String type) {
    setState(() {
      switch (type) {
        case 'Family':
          familyCount++;
          break;
        case 'Daily Help':
          dailyHelpCount++;
          break;
        case 'Vehicles':
          vehicleCount++;
          break;
        case 'Pets':
          petCount++;
          break;
      }
    });
    _message('$type added successfully');
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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: headerColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: _isDark ? AppColors.textPrimaryDark : Colors.black,
              size: 22,
            ),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
          title: Text(
            'Settings',
            style: TextStyle(
              color: _isDark ? AppColors.textPrimaryDark : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.help_outline,
                color: _isDark ? AppColors.textPrimaryDark : Colors.black,
                size: 22,
              ),
              onPressed: _openHelpSupport,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // Profile
            _profileCard(),
            const SizedBox(height: 10),

            // Complete Profile
            _completeProfileCard(),
            const SizedBox(height: 16),

            // Household
            _sectionHeader('Household'),
            const SizedBox(height: 10),

            // Household Grid - 2 columns
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,

                // Screenshot card height ≈ 90 px
                mainAxisExtent: 90,
              ),
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return _householdCard(
                      icon: Icons.face_outlined,
                      title: 'InstaHelp',
                      subtitle: '1 Mn+ houses',
                      rating: '4.8',
                      showRating: true,
                    );

                  case 1:
                    return _householdCard(
                      icon: Icons.person_outline,
                      title: 'Family',
                      subtitle: '$familyCount member',
                      showAdd: true,
                      onAdd: () => _addHousehold('Family'),
                    );

                  case 2:
                    return _householdCard(
                      icon: Icons.person_add_alt_1_outlined,
                      title: 'Daily Help',
                      subtitle: dailyHelpCount == 0
                          ? 'Add helper'
                          : '$dailyHelpCount added',
                      showAdd: true,
                      onAdd: () => _addHousehold('Daily Help'),
                    );

                  case 3:
                    return _householdCard(
                      icon: Icons.directions_car_outlined,
                      title: 'Vehicles',
                      subtitle: vehicleCount == 0
                          ? 'Add vehicle'
                          : '$vehicleCount added',
                      showAdd: true,
                      onAdd: () => _addHousehold('Vehicles'),
                    );

                  case 4:
                    return _householdCard(
                      icon: Icons.pets_outlined,
                      title: 'Pets',
                      subtitle: petCount == 0 ? 'Add pet' : '$petCount added',
                      showAdd: true,
                      onAdd: () => _addHousehold('Pets'),
                    );

                  default:
                    return const SizedBox.shrink();
                }
              },
            ),

            const SizedBox(height: 16),

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
                badgeColor: Colors.green,
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
              onTap: _openProfile,
            ),
            Consumer<ThemeModeProvider>(
              builder: (context, themeModeProvider, _) {
                return _settingCard(
                  icon: Icons.brightness_6_outlined,
                  title: 'Theme',
                  subtitle: 'Choose light, dark, or match your device',
                  badge: _themeModeLabel(themeModeProvider.themeMode),
                  onTap: _chooseTheme,
                );
              },
            ),
            _settingCard(
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Sign-out of your account',
              iconColor: Colors.red,
              titleColor: Colors.red,
              onTap: _logout,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE CARD
  // ============================================================

  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _isDark ? 0.4 : 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFFFA000),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              'U',
              style: const TextStyle(
                color: Colors.black,
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
                  style: TextStyle(
                    color: darkText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Nivaas Hub ID : 00000',
                  style: TextStyle(color: greyText, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.qr_code_2, color: primaryBlue, size: 18),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMPLETE PROFILE
  // ============================================================

  Widget _completeProfileCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _isDark ? 0.4 : 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _isDark
                  ? AppColors.settingsProfileBadgeBgDark
                  : AppColors.settingsProfileBadgeBgLight,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '0%',
              style: TextStyle(
                color: _isDark ? AppColors.noticesDangerTextDark : Colors.red,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete your profile',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Let neighbours discover you!',
                  style: TextStyle(fontSize: 11, color: greyText),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _openProfile,
            child: Text(
              'View Profile',
              style: TextStyle(
                color: primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
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
  // HOUSEHOLD CARD
  // ============================================================
  Widget _householdCard({
    required IconData icon,
    required String title,
    required String subtitle,
    String? rating,
    bool showRating = false,
    bool showAdd = false,
    VoidCallback? onAdd,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: _isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _isDark ? 0.4 : 0.04),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ───────── Top Row ─────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: primaryBlue, size: 18),
              ),

              const Spacer(),

              // Rating
              if (showRating)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFF9800),
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        rating ?? '',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: darkText,
                        ),
                      ),
                    ],
                  ),
                ),

              // + Add button
              if (showAdd)
                GestureDetector(
                  onTap: onAdd,
                  child: Container(
                    height: 22,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFFD9DDE3),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      '+ Add',
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 7),

          // ───────── Title ─────────
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: darkText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 2),

          // ───────── Subtitle ─────────
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: greyText, fontSize: 9.5, height: 1.1),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ADDRESS CARD
  // ============================================================

  Widget _addressCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _isDark ? 0.4 : 0.06),
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
        borderRadius: BorderRadius.circular(12),
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
                backgroundColor: const Color(0xFFFF8A00),
                foregroundColor: Colors.white,
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
        color: _isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _isDark ? 0.4 : 0.04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: iconColor == Colors.red
                        ? (_isDark
                              ? AppColors.settingsDangerIconBgDark
                              : AppColors.settingsDangerIconBgLight)
                        : lightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor == Colors.red
                        ? (_isDark
                              ? AppColors.noticesDangerTextDark
                              : Colors.red)
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
                          color: titleColor == Colors.red
                              ? (_isDark
                                    ? AppColors.noticesDangerTextDark
                                    : Colors.red)
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
        color: _isDark ? AppColors.borderDark : Colors.grey.shade300,
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
