import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';

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
    Navigator.pushNamed(
      context,
      AppRoutes.selectCity,
      arguments: country.name,
    );
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
                            'Select Country',
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
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: textPrimary, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Search your country...',
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

            // Country Lists Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                children: [
                  if (filteredPopular.isNotEmpty) ...[
                    _buildSectionTitle('POPULAR COUNTRIES', isDark),
                    const SizedBox(height: 10),
                    _buildCountryCardGroup(
                      countries: filteredPopular,
                      cardBgColor: cardBgColor,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 24),
                  ],

                  if (filteredAll.isNotEmpty) ...[
                    _buildSectionTitle('ALL COUNTRIES', isDark),
                    const SizedBox(height: 10),
                    _buildCountryCardGroup(
                      countries: filteredAll,
                      cardBgColor: cardBgColor,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      isDark: isDark,
                    ),
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

  Widget _buildCountryCardGroup({
    required List<CountryData> countries,
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
        children: List.generate(countries.length, (index) {
          final country = countries[index];
          final isLast = index == countries.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: () => _onCountrySelected(country),
                borderRadius: BorderRadius.vertical(
                  top: index == 0 ? const Radius.circular(16) : Radius.zero,
                  bottom: isLast ? const Radius.circular(16) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      if (country.flag == '🌐')
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E3547)
                                : const Color(0xFFEAF4FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.language,
                            size: 18,
                            color: Color(0xFF006FC9),
                          ),
                        )
                      else
                        Text(
                          country.flag,
                          style: const TextStyle(fontSize: 22),
                        ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          country.name,
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
