import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/kyc/city_confirmation_screen.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';

class CityData {
  final String name;
  final String state;
  final String country;
  final String region;
  final IconData icon;

  const CityData({
    required this.name,
    required this.state,
    required this.country,
    required this.region,
    required this.icon,
  });
}

class SelectCityScreen extends StatefulWidget {
  final String? countryName;

  const SelectCityScreen({
    super.key,
    this.countryName,
  });

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<CityData> _popularGridCities = [
    CityData(name: 'Bangalore', state: 'Karnataka', country: 'India', region: 'Bengaluru Urban', icon: Icons.account_balance_outlined),
    CityData(name: 'Mumbai', state: 'Maharashtra', country: 'India', region: 'Mumbai City', icon: Icons.domain_outlined),
    CityData(name: 'Delhi NCR', state: 'Delhi', country: 'India', region: 'New Delhi', icon: Icons.museum_outlined),
    CityData(name: 'Pune', state: 'Maharashtra', country: 'India', region: 'Pune City', icon: Icons.location_city_outlined),
    CityData(name: 'Chennai', state: 'Tamil Nadu', country: 'India', region: 'Chennai', icon: Icons.fort_outlined),
    CityData(name: 'Hyderabad', state: 'Telangana', country: 'India', region: 'Hyderabad', icon: Icons.apartment_outlined),
    CityData(name: 'Ahmedabad', state: 'Gujarat', country: 'India', region: 'Ahmedabad', icon: Icons.landscape_outlined),
    CityData(name: 'Kolkata', state: 'West Bengal', country: 'India', region: 'Kolkata', icon: Icons.directions_boat_outlined),
    CityData(name: 'Kochi', state: 'Kerala', country: 'India', region: 'Ernakulam', icon: Icons.water_outlined),
  ];

  static const List<CityData> _allCitiesList = [
    CityData(name: 'Amritsar', state: 'Punjab', country: 'India', region: 'Amritsar', icon: Icons.location_on_outlined),
    CityData(name: 'Bhopal', state: 'Madhya Pradesh', country: 'India', region: 'Bhopal', icon: Icons.location_on_outlined),
    CityData(name: 'Chandigarh', state: 'Punjab', country: 'India', region: 'Chandigarh', icon: Icons.location_on_outlined),
    CityData(name: 'Dehradun', state: 'Uttarakhand', country: 'India', region: 'Dehradun', icon: Icons.location_on_outlined),
  ];

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

  void _onCitySelected(CityData city) async {
    final result = await CityConfirmationScreen.showModal(
      context,
      cityName: city.name,
      stateName: city.state,
      countryName: city.country,
      subRegion: city.region,
    );

    if (result != null && mounted) {
      Navigator.pushNamed(context, AppRoutes.addHome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredGrid = _popularGridCities
        .where((c) => c.name.toLowerCase().contains(_searchQuery))
        .toList();

    final filteredAll = _allCitiesList
        .where((c) => c.name.toLowerCase().contains(_searchQuery))
        .toList();

    final headerBgColor = isDark
        ? AppColors.dashboardHeaderDark
        : const Color(0xFFC7E3FF);

    final scaffoldBgColor = isDark
        ? AppColors.backgroundDark
        : const Color(0xFFF3F7FD);

    final cardBgColor = isDark ? AppColors.surfaceDark : AppColors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF1F2937);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Top Sky-Blue Header Container
            Container(
              decoration: BoxDecoration(
                color: headerBgColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  child: Column(
                    children: [
                      // Header Row: Back button & Title
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: textPrimary,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          Text(
                            'Select City',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Search Input Box
                      Container(
                        decoration: BoxDecoration(
                          color: cardBgColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: textPrimary, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Search your city...',
                            hintStyle: TextStyle(
                              color: isDark ? AppColors.grey400 : AppColors.grey500,
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: isDark ? AppColors.grey400 : AppColors.grey500,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // City Content (Grid + List)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                children: [
                  // 3x3 Popular Cities Grid Card
                  if (filteredGrid.isNotEmpty) ...[
                    Container(
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredGrid.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.15,
                        ),
                        itemBuilder: (context, index) {
                          final city = filteredGrid[index];
                          final col = index % 3;
                          final row = index ~/ 3;
                          final totalRows = (filteredGrid.length / 3).ceil();

                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                right: col < 2
                                    ? BorderSide(
                                        color: isDark ? AppColors.grey800 : const Color(0xFFF3F4F6),
                                        width: 1,
                                      )
                                    : BorderSide.none,
                                bottom: row < totalRows - 1
                                    ? BorderSide(
                                        color: isDark ? AppColors.grey800 : const Color(0xFFF3F4F6),
                                        width: 1,
                                      )
                                    : BorderSide.none,
                              ),
                            ),
                            child: InkWell(
                              onTap: () => _onCitySelected(city),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    city.icon,
                                    size: 32,
                                    color: isDark ? AppColors.grey400 : const Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    city.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: textPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ALL CITIES section title & list
                  if (filteredAll.isNotEmpty) ...[
                    _buildSectionTitle('ALL CITIES', isDark),
                    const SizedBox(height: 10),
                    _buildCityCardGroup(
                      cities: filteredAll,
                      cardBgColor: cardBgColor,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (filteredGrid.isEmpty && filteredAll.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'No cities match "$_searchQuery"',
                          style: TextStyle(
                            color: isDark ? AppColors.grey400 : AppColors.grey500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const DashboardBottomNavigation(selectedIndex: 0),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Row(
      children: [
        Container(
          width: 3.5,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFF006FC9),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: isDark ? AppColors.grey300 : const Color(0xFF1E293B),
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildCityCardGroup({
    required List<CityData> cities,
    required Color cardBgColor,
    required Color borderColor,
    required Color textPrimary,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: List.generate(cities.length, (index) {
          final city = cities[index];
          final isLast = index == cities.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: () => _onCitySelected(city),
                borderRadius: BorderRadius.vertical(
                  top: index == 0 ? const Radius.circular(16) : Radius.zero,
                  bottom: isLast ? const Radius.circular(16) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E3547)
                              : const Color(0xFFEAF4FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: Color(0xFF006FC9),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          city.name,
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: isDark ? AppColors.grey400 : AppColors.grey500,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark ? AppColors.grey800 : const Color(0xFFF3F4F6),
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }),
      ),
    );
  }
}
