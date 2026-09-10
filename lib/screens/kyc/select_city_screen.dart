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
  final String? imageAsset;

  const CityData({
    required this.name,
    required this.state,
    required this.country,
    required this.region,
    required this.icon,
    this.imageAsset,
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
  final TextEditingController _manualCityController = TextEditingController();
  String _searchQuery = '';

  static const List<CityData> _popularGridCities = [
    CityData(name: 'Bangalore', state: 'Karnataka', country: 'India', region: 'Bengaluru Urban', icon: Icons.account_balance_outlined, imageAsset: 'assets/images/kyc/cities/landmark-illustration.png'),
    CityData(name: 'Mumbai', state: 'Maharashtra', country: 'India', region: 'Mumbai City', icon: Icons.domain_outlined, imageAsset: 'assets/images/kyc/cities/landmark-illustration (1).png'),
    CityData(name: 'Delhi NCR', state: 'Delhi', country: 'India', region: 'New Delhi', icon: Icons.museum_outlined, imageAsset: 'assets/images/kyc/cities/landmark-illustration (2).png'),
    CityData(name: 'Pune', state: 'Maharashtra', country: 'India', region: 'Pune City', icon: Icons.location_city_outlined, imageAsset: 'assets/images/kyc/cities/landmark-illustration (3).png'),
    CityData(name: 'Chennai', state: 'Tamil Nadu', country: 'India', region: 'Chennai', icon: Icons.fort_outlined, imageAsset: 'assets/images/kyc/cities/landmark-illustration (4).png'),
    CityData(name: 'Hyderabad', state: 'Telangana', country: 'India', region: 'Hyderabad', icon: Icons.apartment_outlined, imageAsset: 'assets/images/kyc/cities/landmark-illustration (5).png'),
    CityData(name: 'Ahmedabad', state: 'Gujarat', country: 'India', region: 'Ahmedabad', icon: Icons.landscape_outlined, imageAsset: 'assets/images/kyc/cities/landmark-illustration (6).png'),
    CityData(name: 'Kolkata', state: 'West Bengal', country: 'India', region: 'Kolkata', icon: Icons.directions_boat_outlined, imageAsset: 'assets/images/kyc/cities/landmark-illustration (7).png'),
    CityData(name: 'Kochi', state: 'Kerala', country: 'India', region: 'Ernakulam', icon: Icons.water_outlined, imageAsset: 'assets/images/kyc/cities/landmark-illustration (8).png'),
  ];

  static const List<CityData> _allCitiesList = [
    CityData(name: 'Amritsar', state: 'Punjab', country: 'India', region: 'Amritsar', icon: Icons.location_on_outlined),
    CityData(name: 'Bhopal', state: 'Madhya Pradesh', country: 'India', region: 'Bhopal', icon: Icons.location_on_outlined),
    CityData(name: 'Chandigarh', state: 'Punjab', country: 'India', region: 'Chandigarh', icon: Icons.location_on_outlined),
    CityData(name: 'Dehradun', state: 'Uttarakhand', country: 'India', region: 'Dehradun', icon: Icons.location_on_outlined),
  ];

  /// Curated (non-exhaustive) sample cities per country for the non-India
  /// KYC flow. Grouped by state/province/region internally (each `CityData`
  /// still carries its own `state`), but since there's no Select State step
  /// any more, all of a country's curated cities are flattened into one
  /// list (see `_citiesForCountry`). A country with no entry here falls back
  /// to the "No cities available for ..." message below. India is
  /// intentionally absent: its city list above is unrelated and unaffected
  /// by this map.
  static const Map<String, Map<String, List<CityData>>> _citiesByCountryAndState = {
    'Kenya': {
      'Nairobi': [CityData(name: 'Nairobi', state: 'Nairobi', country: 'Kenya', region: 'Nairobi', icon: Icons.location_city_outlined)],
      'Mombasa': [CityData(name: 'Mombasa', state: 'Mombasa', country: 'Kenya', region: 'Mombasa', icon: Icons.location_city_outlined)],
      'Kisumu': [CityData(name: 'Kisumu', state: 'Kisumu', country: 'Kenya', region: 'Kisumu', icon: Icons.location_city_outlined)],
      'Nakuru': [CityData(name: 'Nakuru', state: 'Nakuru', country: 'Kenya', region: 'Nakuru', icon: Icons.location_city_outlined)],
    },
    'United Arab Emirates': {
      'Dubai': [CityData(name: 'Dubai', state: 'Dubai', country: 'United Arab Emirates', region: 'Dubai', icon: Icons.location_city_outlined)],
      'Abu Dhabi': [CityData(name: 'Abu Dhabi', state: 'Abu Dhabi', country: 'United Arab Emirates', region: 'Abu Dhabi', icon: Icons.location_city_outlined)],
      'Sharjah': [CityData(name: 'Sharjah', state: 'Sharjah', country: 'United Arab Emirates', region: 'Sharjah', icon: Icons.location_city_outlined)],
    },
    'Philippines': {
      'National Capital Region (NCR)': [
        CityData(name: 'Manila', state: 'National Capital Region (NCR)', country: 'Philippines', region: 'Manila', icon: Icons.location_city_outlined),
        CityData(name: 'Quezon City', state: 'National Capital Region (NCR)', country: 'Philippines', region: 'Quezon City', icon: Icons.location_city_outlined),
      ],
      'Central Visayas': [CityData(name: 'Cebu City', state: 'Central Visayas', country: 'Philippines', region: 'Cebu City', icon: Icons.location_city_outlined)],
      'Davao Region': [CityData(name: 'Davao City', state: 'Davao Region', country: 'Philippines', region: 'Davao City', icon: Icons.location_city_outlined)],
    },
    'Canada': {
      'Ontario': [
        CityData(name: 'Toronto', state: 'Ontario', country: 'Canada', region: 'Toronto', icon: Icons.location_city_outlined),
        CityData(name: 'Ottawa', state: 'Ontario', country: 'Canada', region: 'Ottawa', icon: Icons.location_city_outlined),
      ],
      'British Columbia': [CityData(name: 'Vancouver', state: 'British Columbia', country: 'Canada', region: 'Vancouver', icon: Icons.location_city_outlined)],
      'Quebec': [CityData(name: 'Montreal', state: 'Quebec', country: 'Canada', region: 'Montreal', icon: Icons.location_city_outlined)],
      'Alberta': [CityData(name: 'Calgary', state: 'Alberta', country: 'Canada', region: 'Calgary', icon: Icons.location_city_outlined)],
    },
    'Australia': {
      'New South Wales': [CityData(name: 'Sydney', state: 'New South Wales', country: 'Australia', region: 'Sydney', icon: Icons.location_city_outlined)],
      'Victoria': [CityData(name: 'Melbourne', state: 'Victoria', country: 'Australia', region: 'Melbourne', icon: Icons.location_city_outlined)],
      'Queensland': [CityData(name: 'Brisbane', state: 'Queensland', country: 'Australia', region: 'Brisbane', icon: Icons.location_city_outlined)],
      'Western Australia': [CityData(name: 'Perth', state: 'Western Australia', country: 'Australia', region: 'Perth', icon: Icons.location_city_outlined)],
    },
    'Germany': {
      'Bavaria': [CityData(name: 'Munich', state: 'Bavaria', country: 'Germany', region: 'Munich', icon: Icons.location_city_outlined)],
      'Berlin': [CityData(name: 'Berlin', state: 'Berlin', country: 'Germany', region: 'Berlin', icon: Icons.location_city_outlined)],
      'Hamburg': [CityData(name: 'Hamburg', state: 'Hamburg', country: 'Germany', region: 'Hamburg', icon: Icons.location_city_outlined)],
      'North Rhine-Westphalia': [CityData(name: 'Cologne', state: 'North Rhine-Westphalia', country: 'Germany', region: 'Cologne', icon: Icons.location_city_outlined)],
    },
    'Singapore': {
      'Central Region': [CityData(name: 'Singapore', state: 'Central Region', country: 'Singapore', region: 'Central Region', icon: Icons.location_city_outlined)],
    },
    'United Kingdom': {
      'England': [
        CityData(name: 'London', state: 'England', country: 'United Kingdom', region: 'London', icon: Icons.location_city_outlined),
        CityData(name: 'Manchester', state: 'England', country: 'United Kingdom', region: 'Manchester', icon: Icons.location_city_outlined),
      ],
      'Scotland': [CityData(name: 'Edinburgh', state: 'Scotland', country: 'United Kingdom', region: 'Edinburgh', icon: Icons.location_city_outlined)],
      'Wales': [CityData(name: 'Cardiff', state: 'Wales', country: 'United Kingdom', region: 'Cardiff', icon: Icons.location_city_outlined)],
    },
    'United States': {
      'California': [
        CityData(name: 'Los Angeles', state: 'California', country: 'United States', region: 'Los Angeles', icon: Icons.location_city_outlined),
        CityData(name: 'San Francisco', state: 'California', country: 'United States', region: 'San Francisco', icon: Icons.location_city_outlined),
      ],
      'New York': [CityData(name: 'New York City', state: 'New York', country: 'United States', region: 'New York City', icon: Icons.location_city_outlined)],
      'Texas': [CityData(name: 'Houston', state: 'Texas', country: 'United States', region: 'Houston', icon: Icons.location_city_outlined)],
      'Illinois': [CityData(name: 'Chicago', state: 'Illinois', country: 'United States', region: 'Chicago', icon: Icons.location_city_outlined)],
    },
  };

  /// All curated cities for [country] across every state/region, flattened
  /// since there's no Select State step to narrow this down first.
  static List<CityData> _citiesForCountry(String? country) {
    final byState = _citiesByCountryAndState[country];
    if (byState == null) return const [];
    return byState.values.expand((cities) => cities).toList();
  }

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
    _manualCityController.dispose();
    super.dispose();
  }

  /// Fallback for non-India countries with no curated city data (see
  /// `_citiesByCountryAndState`) — lets the user type their city instead of
  /// dead-ending with no tappable option. Still goes through the same City
  /// Confirmation modal and non-India branch as a curated city would.
  void _onManualCityContinue() async {
    final typedCity = _manualCityController.text.trim();
    if (typedCity.isEmpty) return;

    final result = await CityConfirmationScreen.showModal(
      context,
      cityName: typedCity,
      stateName: '',
      countryName: widget.countryName ?? '',
      subRegion: typedCity,
    );

    if (result != null && mounted) {
      Navigator.pushNamed(
        context,
        AppRoutes.societyRegistrationNumber,
        arguments: {
          'country': widget.countryName,
          'state': '',
          'city': typedCity,
        },
      );
    }
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
      if (city.country == 'India') {
        // Existing India flow — unchanged.
        Navigator.pushNamed(context, AppRoutes.addHome);
      } else {
        // Non-India flow: Society Registration Number -> KYC Review -> KYC Status.
        Navigator.pushNamed(
          context,
          AppRoutes.societyRegistrationNumber,
          arguments: {
            'country': city.country,
            'state': city.state,
            'city': city.name,
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // India (including the legacy no-country case) keeps its existing
    // static city lists and grid/list split exactly as before. Any other
    // country looks up its curated cities (flattened across all its
    // states/regions, since there's no Select State step), rendered
    // through the same "ALL CITIES" list section below.
    final isIndia = widget.countryName == null || widget.countryName == 'India';

    final filteredGrid = isIndia
        ? _popularGridCities
            .where((c) => c.name.toLowerCase().contains(_searchQuery))
            .toList()
        : const <CityData>[];

    final filteredAll = isIndia
        ? _allCitiesList
            .where((c) => c.name.toLowerCase().contains(_searchQuery))
            .toList()
        : _citiesForCountry(widget.countryName)
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
            // Top Sky-Blue Header Container (Header Container: Padding 20,12,20,16, #C7E3FF)
            Container(
              decoration: BoxDecoration(
                color: headerBgColor,
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: SizedBox(
                    height: 38,
                    child: Row(
                      children: [
                        // Navigation back button (24x24px, Gap 12px)
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          behavior: HitTestBehavior.opaque,
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: Icon(
                              Icons.arrow_back,
                              size: 24,
                              color: textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Greeting Container (Pill capsule: height 38px, radius 40px, border #CCDFF2)
                        Expanded(
                          child: Container(
                            height: 38,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.borderDark
                                    : const Color(0xFFCCDFF2),
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.only(left: 16, right: 12),
                            child: Center(
                              child: Text(
                                'Select City',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  height: 1.0,
                                  letterSpacing: 0,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : const Color(0xFF000000),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),


            // City Content (Grid + List)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // Search Box: Height 42px, Radius 14px, Border 1px #E5E7EB, Font Inter 400
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 18,
                          color: isDark ? AppColors.grey400 : const Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.0,
                              letterSpacing: 0,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search your city...',
                              hintStyle: TextStyle(
                                fontFamily: 'Inter',
                                color: isDark ? AppColors.grey400 : const Color(0xFF6B7280),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.0,
                                letterSpacing: 0,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3x3 Popular Cities Grid Card (seamless-city-grid)
                  if (filteredGrid.isNotEmpty) ...[
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(11.79),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                          width: 0.98,
                        ),
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredGrid.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: 100,
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
                                        color: isDark ? AppColors.grey800 : const Color(0xFFE2E8F0),
                                        width: 0.63,
                                      )
                                    : BorderSide.none,
                                bottom: row < totalRows - 1
                                    ? BorderSide(
                                        color: isDark ? AppColors.grey800 : const Color(0xFFE2E8F0),
                                        width: 0.63,
                                      )
                                    : BorderSide.none,
                              ),
                            ),
                            child: InkWell(
                              onTap: () => _onCitySelected(city),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (city.imageAsset != null)
                                    SizedBox(
                                      height: 66.67,
                                      width: 100,
                                      child: Image.asset(
                                        city.imageAsset!,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => Icon(
                                          city.icon,
                                          size: 32,
                                          color: isDark ? AppColors.grey400 : const Color(0xFF94A3B8),
                                        ),
                                      ),
                                    )
                                  else
                                    Icon(
                                      city.icon,
                                      size: 32,
                                      color: isDark ? AppColors.grey400 : const Color(0xFF94A3B8),
                                    ),
                                  Text(
                                    city.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'DM Sans',
                                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF000000),
                                      fontSize: 12.61,
                                      fontWeight: FontWeight.w500,
                                      height: 1.0,
                                      letterSpacing: 0,
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
                    _buildSectionTitle(isIndia ? 'ALL CITIES' : 'CITIES', isDark),
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
                    if (!isIndia && _searchQuery.isEmpty)
                      // No curated city data for this state/region — let the
                      // user type their city instead of dead-ending here.
                      _buildManualCityEntry(isDark, textPrimary, cardBgColor, borderColor)
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'No cities match "$_searchQuery"',
                            textAlign: TextAlign.center,
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

  Widget _buildManualCityEntry(
    bool isDark,
    Color textPrimary,
    Color cardBgColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No cities available for ${widget.countryName}',
            style: TextStyle(
              color: isDark ? AppColors.grey400 : AppColors.grey500,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _manualCityController,
            style: TextStyle(color: textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Enter your city',
              hintStyle: TextStyle(
                color: isDark ? AppColors.grey400 : AppColors.grey500,
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Icons.edit_location_alt_outlined,
                color: isDark ? AppColors.grey400 : AppColors.grey500,
              ),
              filled: true,
              fillColor: isDark ? AppColors.backgroundDark : const Color(0xFFF8FBFE),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
            ),
            onSubmitted: (_) => _onManualCityContinue(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: _onManualCityContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006FC9),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFF0060BD),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'DM Sans',
              color: isDark ? AppColors.grey300 : const Color(0xFF1D1B20),
              fontWeight: FontWeight.w700,
              fontSize: 12,
              height: 1.0,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: isDark
            ? null
            : const [
                BoxShadow(
                  color: Color.fromRGBO(5, 35, 77, 0.0588),
                  offset: Offset(0, 6),
                  blurRadius: 16,
                  spreadRadius: 0,
                ),
              ],
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
                child: SizedBox(
                  height: 52,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E3547)
                                : const Color(0xFFE8F4FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: Color(0xFF006FC9),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            city.name,
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF000000),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: isDark ? AppColors.grey400 : const Color(0xFF10213D),
                          size: 16,
                        ),
                      ],
                    ),
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
