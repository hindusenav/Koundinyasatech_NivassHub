import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';
import 'package:flutter_nivasshub/widgets/kyc/kyc_search_header.dart';
import 'package:flutter_nivasshub/widgets/kyc/kyc_selection_list.dart';

class CountryData {
  final String name;
  final String flag;
  final bool isPopular;

  const CountryData({
    required this.name,
    required this.flag,
    this.isPopular = false,
  });
}

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({super.key});

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<CountryData> _popularCountries = [
    CountryData(name: 'India', flag: '🇮🇳', isPopular: true),
    CountryData(name: 'Kenya', flag: '🇰🇪', isPopular: true),
    CountryData(name: 'United Arab Emirates', flag: '🇦🇪', isPopular: true),
    CountryData(name: 'Philippines', flag: '🇵🇭', isPopular: true),
    CountryData(name: 'Canada', flag: '🇨🇦', isPopular: true),
  ];

  static const List<CountryData> _allCountries = [
    CountryData(name: 'Australia', flag: '🌐'),
    CountryData(name: 'Germany', flag: '🌐'),
    CountryData(name: 'Singapore', flag: '🌐'),
    CountryData(name: 'United Kingdom', flag: '🌐'),
    CountryData(name: 'United States', flag: '🇺🇸'),
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

  void _onCountrySelected(CountryData country) {
    // Select State step removed — go straight from country to city.
    Navigator.pushNamed(
      context,
      AppRoutes.selectCity,
      arguments: country.name,
    );
  }

  Widget _buildLeading(CountryData country, bool isDark) {
    if (country.flag == '🌐') {
      return Container(
        width: 28,
        height: 28,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E3547) : const Color(0xFFE8F4FF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.language,
          size: 16,
          color: Color(0xFF006FC9),
        ),
      );
    }
    return Container(
      width: 32,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        country.flag,
        style: const TextStyle(fontSize: 18, height: 1.0),
      ),
    );
  }

  List<KycListItemData> _toListItems(List<CountryData> countries, bool isDark) {
    return countries
        .map(
          (country) => KycListItemData(
            leading: _buildLeading(country, isDark),
            title: country.name,
            onTap: () => _onCountrySelected(country),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredPopular = _popularCountries
        .where((c) => c.name.toLowerCase().contains(_searchQuery))
        .toList();

    final filteredAll = _allCountries
        .where((c) => c.name.toLowerCase().contains(_searchQuery))
        .toList();

    final scaffoldBgColor = isDark
        ? AppColors.backgroundDark
        : const Color(0xFFF3F7FD);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            KycSearchHeader(
              title: 'Select Country',
              searchController: _searchController,
              hintText: 'Search your country...',
            ),

            // Country Lists Content
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
                              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1F2937),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.0,
                              letterSpacing: 0,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search your country...',
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

                  if (filteredPopular.isNotEmpty) ...[
                    const KycSectionTitle(title: 'POPULAR COUNTRIES'),
                    const SizedBox(height: 10),
                    KycListCardGroup(items: _toListItems(filteredPopular, isDark)),
                    const SizedBox(height: 24),
                  ],

                  if (filteredAll.isNotEmpty) ...[
                    const KycSectionTitle(title: 'ALL COUNTRIES'),
                    const SizedBox(height: 10),
                    KycListCardGroup(items: _toListItems(filteredAll, isDark)),
                    const SizedBox(height: 16),
                  ],

                  if (filteredPopular.isEmpty && filteredAll.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'No countries match "$_searchQuery"',
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
}
