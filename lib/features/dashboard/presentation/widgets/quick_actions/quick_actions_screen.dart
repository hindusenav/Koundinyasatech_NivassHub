import 'package:flutter/material.dart';

class QuickActionsScreen extends StatefulWidget {
  const QuickActionsScreen({super.key});

  @override
  State<QuickActionsScreen> createState() => _QuickActionsScreenState();
}

class _QuickActionsScreenState extends State<QuickActionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Track Raise Alert State
  bool _isAlertActive = false;

  // Track search query
  String _searchQuery = '';

  // Track active section filter (null = show all sections)
  String? _selectedSection;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Check if a tile matches the search query
  bool _matchesSearch(String label) {
    if (_searchQuery.isEmpty) return true;
    return label.toLowerCase().contains(_searchQuery);
  }

  // Filter section visibility based on selected section filter
  bool _isSectionVisible(String sectionName) {
    if (_selectedSection == null) return true;
    return _selectedSection == sectionName;
  }

  @override
  Widget build(BuildContext context) {
    const bgLightBlue = Color(0xFFE2EBF8);

    return Scaffold(
      backgroundColor: bgLightBlue,
      appBar: AppBar(
        backgroundColor: bgLightBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Quick Actions',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFB0C4DE)),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search all features',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filter Reset Chip (Shows when a section is filtered)
              if (_selectedSection != null) ...[
                Row(
                  children: [
                    Text(
                      'Showing: $_selectedSection',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF0061C3),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedSection = null;
                        });
                      },
                      child: const Text('Show All Sections'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              // 2. Top Standalone Actions
              if (_selectedSection == null && _searchQuery.isEmpty) ...[
                Row(
                  children: [
                    _buildActionTile(
                      icon: Icons.smartphone_outlined,
                      label: 'Manage\nDevices',
                    ),
                    const SizedBox(width: 12),
                    _buildActionTile(
                      icon: Icons.lock_outline,
                      label: 'Nivasa\nHub Locks',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              // 3. Visitors & Security Section
              if (_isSectionVisible('Visitors & Security'))
                _buildSection(
                  title: 'Visitors & Security',
                  actionWidget: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isAlertActive = !_isAlertActive;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _isAlertActive ? Colors.red : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 14,
                            color: _isAlertActive ? Colors.white : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Raise Alert',
                            style: TextStyle(
                              color: _isAlertActive ? Colors.white : Colors.red,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  items: [
                    _buildActionTile(icon: Icons.person_outline, label: 'Invite Guest'),
                    _buildActionTile(icon: Icons.directions_car_outlined, label: 'Cab/Auto'),
                    _buildActionTile(icon: Icons.local_shipping_outlined, label: 'Allow Delivery'),
                    _buildActionTile(icon: Icons.build_outlined, label: 'Visiting Help'),
                    _buildActionTile(icon: Icons.phone_outlined, label: 'Call Security'),
                    _buildActionTile(icon: Icons.mail_outline, label: 'Message Guard'),
                    _buildActionTile(icon: Icons.badge_outlined, label: 'MyPasses'),
                    _buildActionTile(icon: Icons.sentiment_satisfied_alt, label: 'Allow Kid Exit'),
                  ],
                ),

              // 4. Community Section
              if (_isSectionVisible('Community'))
                _buildSection(
                  title: 'Community',
                  actionText: _selectedSection == 'Community' ? 'Show Less' : 'View all >',
                  onActionTap: () {
                    setState(() {
                      _selectedSection = _selectedSection == 'Community' ? null : 'Community';
                    });
                  },
                  items: [
                    _buildActionTile(icon: Icons.people_outline, label: 'Residents'),
                    _buildActionTile(icon: Icons.directions_car_outlined, label: 'Search Vehicle'),
                    _buildActionTile(icon: Icons.person_search_outlined, label: 'Find Daily Help'),
                    _buildActionTile(icon: Icons.cancel_outlined, label: 'Amenities'),
                  ],
                ),

              // 5. Feed Section
              if (_isSectionVisible('Feed'))
                _buildSection(
                  title: 'Feed',
                  actionText: _selectedSection == 'Feed' ? 'Show Less' : 'View all posts >',
                  onActionTap: () {
                    setState(() {
                      _selectedSection = _selectedSection == 'Feed' ? null : 'Feed';
                    });
                  },
                  items: [
                    _buildActionTile(icon: Icons.grid_view_outlined, label: 'Create Post'),
                    _buildActionTile(icon: Icons.poll_outlined, label: 'Create Poll'),
                    _buildActionTile(icon: Icons.event_outlined, label: 'Host an Event'),
                    _buildActionTile(icon: Icons.article_outlined, label: 'My Posts'),
                  ],
                ),

              // 6. Marketplace Section
              if (_isSectionVisible('Marketplace'))
                _buildSection(
                  title: 'Marketplace',
                  actionText: _selectedSection == 'Marketplace' ? 'Show Less' : 'Explore >',
                  onActionTap: () {
                    setState(() {
                      _selectedSection = _selectedSection == 'Marketplace' ? null : 'Marketplace';
                    });
                  },
                  items: [
                    _buildWideMarketplaceCard(icon: Icons.home_outlined, label: 'Find Homes'),
                    _buildWideMarketplaceCard(icon: Icons.list_alt_outlined, label: 'My Listings'),
                    _buildWideMarketplaceCard(icon: Icons.add, label: 'Create a Listing'),
                  ],
                  isMarketplace: true,
                ),

              // 7. Household Section
              if (_isSectionVisible('Household'))
                _buildSection(
                  title: 'Household',
                  actionText: _selectedSection == 'Household' ? 'Show Less' : 'Manage >',
                  onActionTap: () {
                    setState(() {
                      _selectedSection = _selectedSection == 'Household' ? null : 'Household';
                    });
                  },
                  items: [
                    _buildActionTile(icon: Icons.groups_outlined, label: 'My Family'),
                    _buildActionTile(icon: Icons.person_outline, label: 'My Daily Help'),
                    _buildActionTile(icon: Icons.calendar_today_outlined, label: 'Home Planner'),
                    _buildActionTile(icon: Icons.directions_car_outlined, label: 'My Vehicles'),
                  ],
                ),

              // 8. Settings Section
              if (_isSectionVisible('Settings'))
                _buildSection(
                  title: 'Settings',
                  actionText: _selectedSection == 'Settings' ? 'Show Less' : 'View all >',
                  onActionTap: () {
                    setState(() {
                      _selectedSection = _selectedSection == 'Settings' ? null : 'Settings';
                    });
                  },
                  items: [
                    _buildActionTile(icon: Icons.notifications_none_outlined, label: 'Test Notific...'),
                    _buildActionTile(icon: Icons.crop_portrait_outlined, label: 'My Flat'),
                    _buildActionTile(icon: Icons.workspace_premium_outlined, label: 'My Plans'),
                    _buildActionTile(icon: Icons.help_outline, label: 'Help & Support'),
                  ],
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper to render a Section with Search Filtering ---
  Widget _buildSection({
    required String title,
    String? actionText,
    Widget? actionWidget,
    VoidCallback? onActionTap,
    required List<Widget> items,
    bool isMarketplace = false,
  }) {
    // Filter items based on search query
    final filteredItems = items.where((widget) {
      if (widget is _ActionTileData) {
        return _matchesSearch(widget.label);
      }
      return true;
    }).toList();

    // Hide section completely if search yields 0 matches in this section
    if (_searchQuery.isNotEmpty && filteredItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: title,
          actionText: actionText,
          actionWidget: actionWidget,
          onActionTap: onActionTap,
        ),
        const SizedBox(height: 12),
        if (isMarketplace)
          Row(
            children: filteredItems
                .map((item) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: item)))
                .toList(),
          )
        else
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
            childAspectRatio: 0.72,
            children: filteredItems,
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Action Tile Widget (Wraps tile data for search matching)
  Widget _buildActionTile({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return _ActionTileData(
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 26,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3748),
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Wide Card for Marketplace
  Widget _buildWideMarketplaceCard({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return _ActionTileData(
      label: label,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: const Color(0xFF2D3748)),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section Header Widget
  Widget _buildSectionHeader({
    required String title,
    String? actionText,
    Widget? actionWidget,
    VoidCallback? onActionTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E2A38),
          ),
        ),
        if (actionWidget != null)
          actionWidget
        else if (actionText != null)
          InkWell(
            onTap: onActionTap,
            child: Text(
              actionText,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0061C3),
              ),
            ),
          ),
      ],
    );
  }
}

// Wrapper class to preserve label for filtering
class _ActionTileData extends StatelessWidget {
  final String label;
  final Widget child;

  const _ActionTileData({required this.label, required this.child});

  @override
  Widget build(BuildContext context) => child;
}