import 'package:flutter/material.dart';
import './../../../features/welcome/screens/welcome_screen.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedNavIndex = 4; // 'More' active

  // State Variables
  String _userName = "User Name";
  String _hubId = "000000";
  String _phone = "+91 9876543210";
  String _email = "resident@nivaashub.com";

  // Household Counts
  int _familyCount = 1;
  int _dailyHelpCount = 0;
  int _vehicleCount = 0;
  int _petCount = 0;

  // Flats State
  List<Map<String, dynamic>> _flats = [
    {'name': 'Flat A-101', 'isActive': true},
  ];

  // Active Plan
  String _activePlan = "Ad-Supported";

  // Notification Toggles
  bool _gateAlerts = true;
  bool _deliveryAlerts = true;
  bool _communityPosts = false;

  // Colors
  static const primaryBlue = Color(0xFF0061C3);
  static const bgLightBlue = Color(0xFFD8E9F8);

  // --- FUNCTIONALITY HANDLERS ---

  // 1. Profile Navigation Modal
  void _openProfileScreen() {
    final nameController = TextEditingController(text: _userName);
    final phoneController = TextEditingController(text: _phone);
    final emailController = TextEditingController(text: _email);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("User Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone Number", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email Address", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
                onPressed: () {
                  setState(() {
                    _userName = nameController.text.trim();
                    _phone = phoneController.text.trim();
                    _email = emailController.text.trim();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated successfully!')),
                  );
                },
                child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Household "View All" Modal
  void _openHouseholdViewAll() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Household Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  // 3. Address Share Dialog (WhatsApp, SMS, Native simulation)
  void _shareAddress() {
    final activeFlat = _flats.firstWhere((f) => f['isActive'] == true, orElse: () => _flats.first);
    final addressText = "My Address: ${activeFlat['name']}, Nivaas Hub Society. Contact: $_userName";

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
          CircleAvatar(radius: 24, backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color)),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // 4. Notification Preferences Modal
  void _openNotificationPreferences() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                activeColor: primaryBlue,
                onChanged: (val) {
                  setSheetState(() => _gateAlerts = val);
                  setState(() => _gateAlerts = val);
                },
              ),
              SwitchListTile(
                title: const Text("Delivery Notifications"),
                subtitle: const Text("Parcels at gate, OTPs"),
                value: _deliveryAlerts,
                activeColor: primaryBlue,
                onChanged: (val) {
                  setSheetState(() => _deliveryAlerts = val);
                  setState(() => _deliveryAlerts = val);
                },
              ),
              SwitchListTile(
                title: const Text("Community Feed Updates"),
                subtitle: const Text("Announcements and notices"),
                value: _communityPosts,
                activeColor: primaryBlue,
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

  // 5. Security Alert History
  void _openSecurityAlerts() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Recent Security Alerts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const ListTile(
              leading: Icon(Icons.verified, color: Colors.green),
              title: Text("Visitor Entry Approved"),
              subtitle: Text("Guest Entry - 2:15 PM"),
            ),
            const ListTile(
              leading: Icon(Icons.local_shipping, color: Colors.orange),
              title: Text("Parcel Delivered at Gate"),
              subtitle: Text("Amazon Package - 11:30 AM"),
            ),
          ],
        ),
      ),
    );
  }

  // 6. Purchases & Orders History
  void _openMyOrders() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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

  // 7. My Plans Selector
  void _openMyPlans() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Subscription Plans", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              RadioListTile<String>(
                title: const Text("Ad-Supported (Free)"),
                subtitle: const Text("Basic gate access & community updates"),
                value: "Ad-Supported",
                groupValue: _activePlan,
                activeColor: primaryBlue,
                onChanged: (val) {
                  setSheetState(() => _activePlan = val!);
                  setState(() => _activePlan = val!);
                },
              ),
              RadioListTile<String>(
                title: const Text("Nivaas Premium (₹99/mo)"),
                subtitle: const Text("Ad-free experience, unlimited guest passes & priority support"),
                value: "Premium",
                groupValue: _activePlan,
                activeColor: primaryBlue,
                onChanged: (val) {
                  setSheetState(() => _activePlan = val!);
                  setState(() => _activePlan = val!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 8. Flat Active/Inactive Toggle
  void _toggleFlatStatus(int index) {
    setState(() {
      for (int i = 0; i < _flats.length; i++) {
        _flats[i]['isActive'] = (i == index); // Only 1 flat active at a time
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_flats[index]['name']} is now Active')),
    );
  }

  // Add Flat Dialog
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

  // 9. Logout
  void _showLogoutDialog() {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            Navigator.pop(dialogContext);

            // Navigate directly to WelcomeScreen and clear history
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              (route) => false,
            );
          },
          child: const Text('Logout', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

  // 10. Household Counter Modal
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

  // --- BUILD UI ---

  @override
  Widget build(BuildContext context) {
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help Center: Support is available 24/7')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. USER PROFILE CARD
              _buildCardContainer(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.amber.shade700,
                      child: Text(
                        _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 2),
                          Text('Nivaas Hub ID : $_hubId', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.qr_code_2, color: primaryBlue, size: 24),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Resident QR Code Active')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // 2. COMPLETE PROFILE BANNER
              _buildCardContainer(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 13,
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
                      child: const Text('View Profile', style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 3. HOUSEHOLD SECTION
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

              // HOUSEHOLD GRID
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2.1,
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
              const SizedBox(height: 14),

              // 4. MY ADDRESS CARD
              _buildCardContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('My Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 2),
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
              const SizedBox(height: 10),

              // 5. NOTIFICATION BANNER
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E7),
                  borderRadius: BorderRadius.circular(14),
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
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
              const SizedBox(height: 18),

              // 6. SECURITY & NOTIFICATIONS
              _buildSectionHeader('Security & Notifications'),
              const SizedBox(height: 8),
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
              const SizedBox(height: 14),

              // 7. PURCHASES
              _buildSectionHeader('Purchases'),
              const SizedBox(height: 8),
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
              const SizedBox(height: 14),

              // 8. MANAGE FLATS
              _buildSectionHeader('Manage Flats'),
              const SizedBox(height: 8),

              // DYNAMIC FLATS LIST
              Column(
                children: List.generate(_flats.length, (index) {
                  final flat = _flats[index];
                  return _buildSingleSettingTile(
                    icon: Icons.home_outlined,
                    title: flat['name'],
                    badgeText: flat['isActive'] ? 'Active' : 'Deactive',
                    badgeColor: flat['isActive'] ? Colors.green : Colors.grey,
                    onTap: () => _toggleFlatStatus(index),
                  );
                }),
              ),
              _buildSingleSettingTile(
                icon: Icons.add_business_outlined,
                title: 'Add Flat/Villa/Office',
                subtitle: 'Link another property',
                onTap: _showAddFlatDialog,
              ),
              const SizedBox(height: 14),

              // 9. GENERAL SETTINGS
              _buildSectionHeader('GENERAL SETTINGS'),
              const SizedBox(height: 8),
              _buildSingleSettingTile(
                icon: Icons.headset_mic_outlined,
                title: 'Support & Feedback',
                subtitle: 'Get help or share your thoughts',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Support Desk: Created ticket #4092')),
                  );
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) => setState(() => _selectedNavIndex = index),
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

  // --- HELPER BUILDERS ---

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(width: 3, height: 14, color: primaryBlue),
        const SizedBox(width: 6),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
      ],
    );
  }

  Widget _buildCardContainer({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: child,
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
    VoidCallback? onTap,
  }) {
    final effectiveIconColor = iconColor ?? primaryBlue;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: effectiveIconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: effectiveIconColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor ?? Colors.black),
        ),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badgeText != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (badgeColor ?? primaryBlue).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(color: badgeColor ?? primaryBlue, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 4),
            ],
            const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
          ],
        ),
        onTap: onTap,
      ),
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryBlue, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis),
                    ),
                    if (rating != null) ...[
                      const SizedBox(width: 2),
                      const Icon(Icons.star, color: Colors.amber, size: 11),
                      Text(rating, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ],
                ),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if (showAddButton)
            GestureDetector(
              onTap: onAddTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: primaryBlue.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('+ Add', style: TextStyle(color: primaryBlue, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}