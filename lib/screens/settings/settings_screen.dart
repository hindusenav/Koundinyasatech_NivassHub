import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/providers/settings/settings_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/services/core/secure_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Theme Colors
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color bgLightBlue = Color(0xFFF4F7FC);

  // Local State Variables
  final String _hubId = "NH-88492";
  int _selectedNavIndex = 4;

  int _familyCount = 3;
  int _dailyHelpCount = 1;
  int _vehicleCount = 2;
  int _petCount = 0;

  bool _gateAlerts = true;
  bool _deliveryAlerts = true;
  bool _communityPosts = false;

  String _activePlan = "Ad-Supported";

  final List<Map<String, dynamic>> _flats = [
    {'name': 'Flat 402, Block A', 'isActive': true},
    {'name': 'Flat 101, Block B', 'isActive': false},
  ];

  // --- MODALS & DIALOGS ---

  void _openProfileScreen() {
    final settingsProvider = context.read<SettingsProvider>();

    final String currentName = settingsProvider.userName;
    final String currentPhone = settingsProvider.phone;
    final String currentEmail = settingsProvider.email;

    final nameController = TextEditingController(text: currentName);
    final phoneController = TextEditingController(text: currentPhone);
    final emailController = TextEditingController(text: currentEmail);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(modalContext).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    await context.read<SettingsProvider>().updateProfile(
                          name: nameController.text,
                          phone: phoneController.text,
                          email: emailController.text,
                        );

                    if (!modalContext.mounted) return;
                    Navigator.pop(modalContext);

                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                      ),
                    );
                  },
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openHouseholdViewAll() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Household Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.person, color: primaryBlue),
              title: const Text("Family Members"),
              trailing: Text("$_familyCount", style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.badge, color: primaryBlue),
              title: const Text("Daily Helpers"),
              trailing: Text("$_dailyHelpCount", style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.directions_car, color: primaryBlue),
              title: const Text("Vehicles Registered"),
              trailing: Text("$_vehicleCount", style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.pets, color: primaryBlue),
              title: const Text("Pets Registered"),
              trailing: Text("$_petCount", style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _shareAddress() {
    final activeFlat = _flats.firstWhere((f) => f['isActive'] == true, orElse: () => _flats.first);
    final userName = context.read<SettingsProvider>().userName;
    final addressText = "My Address: ${activeFlat['name']}, Nivaas Hub Society. Contact: $userName";

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Share Address via", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShareOption(Icons.message, "WhatsApp", Colors.green, addressText),
                _buildShareOption(Icons.sms, "Messages", Colors.blue, addressText),
                _buildShareOption(Icons.copy, "Copy Link", Colors.grey, addressText),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label, Color color, String shareContent) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Shared via $label: "$shareContent"')),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _openNotificationPreferences() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Notification Preferences", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SwitchListTile(
                title: const Text("Gate Security Alerts"),
                subtitle: const Text("Visitor approvals, cab arrivals"),
                value: _gateAlerts,
                activeThumbColor: primaryBlue,
                onChanged: (val) {
                  setSheetState(() => _gateAlerts = val);
                  setState(() => _gateAlerts = val);
                },
              ),
              SwitchListTile(
                title: const Text("Delivery Notifications"),
                subtitle: const Text("Parcels at gate, OTPs"),
                value: _deliveryAlerts,
                activeThumbColor: primaryBlue,
                onChanged: (val) {
                  setSheetState(() => _deliveryAlerts = val);
                  setState(() => _deliveryAlerts = val);
                },
              ),
              SwitchListTile(
                title: const Text("Community Feed Updates"),
                subtitle: const Text("Announcements and notices"),
                value: _communityPosts,
                activeThumbColor: primaryBlue,
                onChanged: (val) {
                  setSheetState(() => _communityPosts = val);
                  setState(() => _communityPosts = val);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openSecurityAlerts() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Recent Security Alerts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.verified, color: Colors.green),
              title: Text("Visitor Entry Approved"),
              subtitle: Text("Guest Entry - 2:15 PM"),
            ),
            ListTile(
              leading: Icon(Icons.local_shipping, color: Colors.orange),
              title: Text("Parcel Delivered at Gate"),
              subtitle: Text("Amazon Package - 11:30 AM"),
            ),
          ],
        ),
      ),
    );
  }

  void _openMyOrders() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("My Orders", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const ListTile(
                leading: Icon(Icons.receipt_long, color: primaryBlue),
                title: Text("Maintenance Fee Payment", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Paid ₹2,500 • Aug 01, 2026"),
                trailing: Text("Completed", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const ListTile(
                leading: Icon(Icons.confirmation_number, color: primaryBlue),
                title: Text("Clubhouse Pass", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Paid ₹150 • Jul 28, 2026"),
                trailing: Text("Completed", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openMyPlans() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Subscription Plans", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              RadioGroup<String>(
                groupValue: _activePlan,
                onChanged: (val) {
                  setSheetState(() => _activePlan = val!);
                  setState(() => _activePlan = val!);
                  context.read<SettingsProvider>().updateActivePlan(val!);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<String>(
                      title: const Text("Ad-Supported (Free)"),
                      subtitle: const Text("Basic gate access & community updates"),
                      value: "Ad-Supported",
                      activeColor: primaryBlue,
                    ),
                    RadioListTile<String>(
                      title: const Text("Nivaas Premium (₹99/mo)"),
                      subtitle: const Text("Ad-free experience, unlimited guest passes & priority support"),
                      value: "Premium",
                      activeColor: primaryBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleFlatStatus(int index) {
    setState(() {
      for (int i = 0; i < _flats.length; i++) {
        _flats[i]['isActive'] = (i == index);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_flats[index]['name']} is now Active')),
    );
  }

  void _showAddFlatDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Property / Flat"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "e.g., Flat B-202, Sunshine Apts"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _flats.add({'name': controller.text.trim(), 'isActive': false});
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final storage = context.read<SecureStorageService>();
              final navigator = Navigator.of(context);
              Navigator.pop(context);
              // Clear the persisted session so a relaunch doesn't
              // auto-navigate back into the Dashboard.
              await storage.clearSession();
              navigator.pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showHouseholdCounterDialog(String title, Function() onIncrement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add $title"),
        content: Text("Do you want to add a new $title to your household record?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
            onPressed: () {
              onIncrement();
              Navigator.pop(context);
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final userName = settingsProvider.userName;
    final userInitial = settingsProvider.userInitial;
    final activeFlatObj = _flats.firstWhere((f) => f['isActive'] == true, orElse: () => _flats.first);

    return Scaffold(
      backgroundColor: bgLightBlue,
      appBar: AppBar(
        backgroundColor: bgLightBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.helpSupport);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Card
              _buildCardContainer(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.amber.shade700,
                      child: Text(
                        userInitial,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Nivaas Hub ID : $_hubId',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.qr_code_scanner, color: primaryBlue),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Profile Completion Card
              _buildCardContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.red.shade50,
                      child: const Text('0%', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Complete your profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('Let neighbours discover you!', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _openProfileScreen,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                      child: const Text('View Profile', style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Household Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('Household'),
                  GestureDetector(
                    onTap: _openHouseholdViewAll,
                    child: const Text('View all >', style: TextStyle(color: primaryBlue, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Household Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildHouseholdCard(
                    title: 'InstaHelp',
                    subtitle: '190+ houses',
                    icon: Icons.face_outlined,
                    rating: '4.8',
                  ),
                  _buildHouseholdCard(
                    title: 'Family',
                    subtitle: '$_familyCount member${_familyCount == 1 ? '' : 's'}',
                    icon: Icons.person_outline,
                    showAddButton: true,
                    onAddTap: () => _showHouseholdCounterDialog('Family Member', () => setState(() => _familyCount++)),
                  ),
                  _buildHouseholdCard(
                    title: 'Daily Help',
                    subtitle: _dailyHelpCount == 0 ? 'Add helper' : '$_dailyHelpCount added',
                    icon: Icons.badge_outlined,
                    showAddButton: true,
                    onAddTap: () => _showHouseholdCounterDialog('Daily Helper', () => setState(() => _dailyHelpCount++)),
                  ),
                  _buildHouseholdCard(
                    title: 'Vehicles',
                    subtitle: _vehicleCount == 0 ? 'Add vehicle' : '$_vehicleCount added',
                    icon: Icons.directions_car_outlined,
                    showAddButton: true,
                    onAddTap: () => _showHouseholdCounterDialog('Vehicle', () => setState(() => _vehicleCount++)),
                  ),
                  _buildHouseholdCard(
                    title: 'Pets',
                    subtitle: _petCount == 0 ? 'Add pet' : '$_petCount added',
                    icon: Icons.pets_outlined,
                    showAddButton: true,
                    onAddTap: () => _showHouseholdCounterDialog('Pet', () => setState(() => _petCount++)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Address Card
              _buildCardContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('My Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(activeFlatObj['name'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: primaryBlue, size: 20),
                      onPressed: _shareAddress,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Notification Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Not Getting Notifications?', style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.w600)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('🔔 Test push notification sent!'), backgroundColor: Colors.green),
                        );
                      },
                      child: const Text('Test Now', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Security & Notifications
              _buildSectionHeader('Security & Notifications'),
              const SizedBox(height: 10),
              _buildSingleSettingTile(
                icon: Icons.notifications_none_outlined,
                title: 'Notification Preferences',
                subtitle: 'Manage what alerts you receive',
                onTap: _openNotificationPreferences,
              ),
              _buildSingleSettingTile(
                icon: Icons.shield_outlined,
                title: 'Security Alert List',
                subtitle: 'View and manage security alerts',
                onTap: _openSecurityAlerts,
              ),
              _buildSingleSettingTile(
                icon: Icons.article_outlined,
                title: 'Feed Settings',
                subtitle: 'Customize your community feed',
                onTap: _openNotificationPreferences,
              ),
              const SizedBox(height: 18),

              // Purchases
              _buildSectionHeader('Purchases'),
              const SizedBox(height: 10),
              _buildSingleSettingTile(
                icon: Icons.shopping_bag_outlined,
                title: 'My Orders',
                subtitle: 'Track your purchases',
                onTap: _openMyOrders,
              ),
              _buildSingleSettingTile(
                icon: Icons.credit_card_outlined,
                title: 'My Plans',
                subtitle: '$_activePlan Active',
                badgeText: _activePlan,
                badgeColor: primaryBlue,
                onTap: _openMyPlans,
              ),
              const SizedBox(height: 18),

              // Manage Flats
              _buildSectionHeader('Manage Flats'),
              const SizedBox(height: 10),
              ...List.generate(_flats.length, (index) {
                final flat = _flats[index];
                return _buildSingleSettingTile(
                  icon: Icons.home_outlined,
                  title: flat['name'],
                  badgeText: flat['isActive'] ? 'Active' : 'Deactive',
                  badgeColor: flat['isActive'] ? Colors.green : Colors.grey,
                  onTap: () => _toggleFlatStatus(index),
                );
              }),
              _buildSingleSettingTile(
                icon: Icons.add_business_outlined,
                title: 'Add Flat/Villa/Office',
                subtitle: 'Link another property',
                onTap: _showAddFlatDialog,
              ),
              const SizedBox(height: 18),

              // General Settings
              _buildSectionHeader('GENERAL SETTINGS'),
              const SizedBox(height: 10),
              _buildSingleSettingTile(
                icon: Icons.headset_mic_outlined,
                title: 'Support & Feedback',
                subtitle: 'Get help or share your thoughts',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.helpSupport);
                },
              ),
              _buildSingleSettingTile(
                icon: Icons.send_outlined,
                title: 'Tell a friend about nivaashub',
                subtitle: 'Invite your neighbours',
                onTap: _shareAddress,
              ),
              _buildSingleSettingTile(
                icon: Icons.person_outline,
                title: 'Account Information',
                subtitle: 'Manage your personal details',
                onTap: _openProfileScreen,
              ),
              _buildSingleSettingTile(
                icon: Icons.logout,
                iconColor: Colors.red,
                title: 'Logout',
                subtitle: 'Sign-out of your account',
                textColor: Colors.red,
                onTap: _showLogoutDialog,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) {
          setState(() => _selectedNavIndex = index);
          settingsProvider.setBottomNavIndex(index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Visitors'),
          BottomNavigationBarItem(icon: Icon(Icons.location_city_outlined), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Payments'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'More'),
        ],
      ),
    );
  }

  // --- HELPER METHODS ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
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
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContainer({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildHouseholdCard({
    required String title,
    required String subtitle,
    required IconData icon,
    String? rating,
    bool showAddButton = false,
    VoidCallback? onAddTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryBlue, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    if (rating != null) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.star, color: Colors.amber, size: 12),
                      Text(rating, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          if (showAddButton)
            GestureDetector(
              onTap: onAddTap,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: bgLightBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: primaryBlue, size: 16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSingleSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    String? badgeText,
    Color? badgeColor,
    Color? iconColor,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F7FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: iconColor ?? primaryBlue,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: textColor ?? Colors.black87,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badgeText != null)
              Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (badgeColor ?? primaryBlue).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: badgeColor ?? primaryBlue,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}