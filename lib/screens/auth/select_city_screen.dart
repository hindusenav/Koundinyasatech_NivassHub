import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/auth/user_details_screen.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_curved_app_bar.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_skyline_painter.dart';
import 'package:flutter_nivasshub/widgets/auth/city_monument_icons.dart';
import 'package:flutter_nivasshub/widgets/auth/confirm_city_bottom_sheet.dart';
import 'package:flutter_nivasshub/widgets/auth/section_header_badge.dart';

class SelectCityScreenArgs {
  const SelectCityScreenArgs({
    required this.identifier,
    this.selectedCountryName = 'India',
    this.selectedCountryCode = 'IN',
  });

  final AuthIdentifier identifier;
  final String selectedCountryName;
  final String selectedCountryCode;
}

class CityData {
  const CityData({
    required this.cityName,
    required this.stateName,
    required this.districtName,
    this.countryName = 'India',
  });

  final String cityName;
  final String stateName;
  final String districtName;
  final String countryName;
}

/// Screen 2: "Select City" matching the new registration flow.
class SelectCityScreen extends StatefulWidget {
  const SelectCityScreen({super.key, required this.args});

  final SelectCityScreenArgs args;

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<CityData> _popularGridCities = [
    CityData(cityName: 'Bangalore', stateName: 'Karnataka', districtName: 'Bengaluru Urban'),
    CityData(cityName: 'Mumbai', stateName: 'Maharashtra', districtName: 'Mumbai Suburban'),
    CityData(cityName: 'Delhi NCR', stateName: 'Delhi', districtName: 'New Delhi'),
    CityData(cityName: 'Pune', stateName: 'Maharashtra', districtName: 'Pune Urban'),
    CityData(cityName: 'Chennai', stateName: 'Tamil Nadu', districtName: 'Chennai Urban'),
    CityData(cityName: 'Hyderabad', stateName: 'Telangana', districtName: 'Hyderabad Urban'),
    CityData(cityName: 'Ahmedabad', stateName: 'Gujarat', districtName: 'Ahmedabad Urban'),
    CityData(cityName: 'Kolkata', stateName: 'West Bengal', districtName: 'Kolkata Urban'),
    CityData(cityName: 'Kochi', stateName: 'Kerala', districtName: 'Ernakulam'),
  ];

  static const List<CityData> _allCitiesSeed = [
    CityData(cityName: 'Amritsar', stateName: 'Punjab', districtName: 'Amritsar District'),
    CityData(cityName: 'Bhopal', stateName: 'Madhya Pradesh', districtName: 'Bhopal District'),
    CityData(cityName: 'Chandigarh', stateName: 'Punjab', districtName: 'Chandigarh'),
    CityData(cityName: 'Dehradun', stateName: 'Uttarakhand', districtName: 'Dehradun District'),
    CityData(cityName: 'Jaipur', stateName: 'Rajasthan', districtName: 'Jaipur Urban'),
    CityData(cityName: 'Lucknow', stateName: 'Uttar Pradesh', districtName: 'Lucknow Urban'),
    CityData(cityName: 'Surat', stateName: 'Gujarat', districtName: 'Surat Urban'),
    CityData(cityName: 'Visakhapatnam', stateName: 'Andhra Pradesh', districtName: 'Visakhapatnam Urban'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCityTap(CityData city) {
    ConfirmCityBottomSheet.show(
      context: context,
      cityName: city.cityName,
      stateName: city.stateName,
      countryName: widget.args.selectedCountryName,
      districtName: city.districtName,
      onConfirm: () {
        Navigator.of(context).pushNamed(
          AppRoutes.userDetails,
          arguments: UserDetailsScreenArgs(
            identifier: widget.args.identifier,
            prefillCountry: widget.args.selectedCountryName,
            prefillState: city.stateName,
            prefillCity: city.cityName,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchQuery.trim().toLowerCase();

    final filteredPopular = _popularGridCities.where((c) {
      if (query.isEmpty) return true;
      return c.cityName.toLowerCase().contains(query) ||
          c.stateName.toLowerCase().contains(query);
    }).toList();

    final filteredAll = _allCitiesSeed.where((c) {
      if (query.isEmpty) return true;
      return c.cityName.toLowerCase().contains(query) ||
          c.stateName.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: const AuthCurvedAppBar(title: 'Select City'),
      body: Stack(
        children: [
          // Background Skyline Painting
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: AuthSkylinePainter(progress: 1.0),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          offset: Offset(0, 2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF9CA3AF),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => setState(() => _searchQuery = val),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AuthColors.blueNh,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Search your city...',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF9CA3AF),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              color: Color(0xFF9CA3AF),
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 3x3 POPULAR CITIES GRID
                  if (filteredPopular.isNotEmpty) ...[
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.12,
                      ),
                      itemCount: filteredPopular.length,
                      itemBuilder: (context, index) {
                        final city = filteredPopular[index];
                        return InkWell(
                          onTap: () => _onCityTap(city),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE5E7EB), width: 0.8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x06000000),
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CityMonumentIcon(
                                  cityName: city.cityName,
                                  size: 34,
                                  color: const Color(0xFF94A3B8),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  city.cityName,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AuthColors.blueNh,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ALL CITIES LIST SECTION
                  if (filteredAll.isNotEmpty) ...[
                    const SectionHeaderBadge(title: 'ALL CITIES'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
                        boxShadow: const [AuthColors.shadowCards1],
                      ),
                      child: Column(
                        children: List.generate(filteredAll.length, (index) {
                          final city = filteredAll[index];
                          final isLast = index == filteredAll.length - 1;

                          return Column(
                            children: [
                              InkWell(
                                onTap: () => _onCityTap(city),
                                borderRadius: BorderRadius.vertical(
                                  top: index == 0 ? const Radius.circular(16) : Radius.zero,
                                  bottom: isLast ? const Radius.circular(16) : Radius.zero,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF0FDF4),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.location_on_rounded,
                                          color: Color(0xFF0284C7),
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          city.cityName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AuthColors.blueNh,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right_rounded,
                                        color: Color(0xFF9CA3AF),
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (!isLast)
                                const Divider(height: 1, indent: 56, color: Color(0xFFF1F5F9)),
                            ],
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  if (filteredPopular.isEmpty && filteredAll.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'No cities found matching "$_searchQuery"',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
