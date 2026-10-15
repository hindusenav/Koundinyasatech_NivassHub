import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/models/auth/auth_identifier.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/screens/auth/select_city_screen.dart';
import 'package:flutter_nivasshub/utils/flag_emoji.dart';
import 'package:flutter_nivasshub/constants/asset_constants.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_curved_app_bar.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_skyline_painter.dart';
import 'package:flutter_nivasshub/widgets/auth/section_header_badge.dart';

class SelectCountryScreenArgs {
  const SelectCountryScreenArgs({required this.identifier});

  final AuthIdentifier identifier;
}

/// Screen 1: "Select Country" matching the new registration flow.
class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({super.key, required this.args});

  final SelectCountryScreenArgs args;

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<Map<String, String>> _popularCountries = [
    {'name': 'India', 'code': 'IN', 'calling': '+91'},
    {'name': 'Kenya', 'code': 'KE', 'calling': '+254'},
    {'name': 'United Arab Emirates', 'code': 'AE', 'calling': '+971'},
    {'name': 'Philippines', 'code': 'PH', 'calling': '+63'},
    {'name': 'Canada', 'code': 'CA', 'calling': '+1'},
  ];

  static const List<Map<String, String>> _allCountriesSeed = [
    {'name': 'Australia', 'code': 'AU', 'calling': '+61'},
    {'name': 'Germany', 'code': 'DE', 'calling': '+49'},
    {'name': 'Singapore', 'code': 'SG', 'calling': '+65'},
    {'name': 'United Kingdom', 'code': 'GB', 'calling': '+44'},
    {'name': 'United States', 'code': 'US', 'calling': '+1'},
    {'name': 'Japan', 'code': 'JP', 'calling': '+81'},
    {'name': 'France', 'code': 'FR', 'calling': '+33'},
    {'name': 'South Africa', 'code': 'ZA', 'calling': '+27'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCountrySelected(String countryName, String countryCode, String callingCode) {
    Navigator.of(context).pushNamed(
      AppRoutes.selectCity,
      arguments: SelectCityScreenArgs(
        identifier: widget.args.identifier,
        selectedCountryName: countryName,
        selectedCountryCode: countryCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchQuery.trim().toLowerCase();

    final filteredPopular = _popularCountries.where((c) {
      if (query.isEmpty) return true;
      return c['name']!.toLowerCase().contains(query);
    }).toList();

    final filteredAll = _allCountriesSeed.where((c) {
      if (query.isEmpty) return true;
      return c['name']!.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: const AuthCurvedAppBar(title: 'Select Country'),
      body: Stack(
        children: [
          // Background Image matching Figma Dev Mode specs:
          // Image: bg img 2.png, Scale: Crop, Opacity: 70%, Top: 340px, Left: -1px
          Positioned(
            top: 340,
            left: -1,
            right: -1,
            bottom: 0,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.70,
                child: Image.asset(
                  AppAssets.authBackground,
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                  errorBuilder: (_, __, ___) => CustomPaint(
                    painter: AuthSkylinePainter(progress: 1.0),
                  ),
                ),
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
                              hintText: 'Search your country...',
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
                  const SizedBox(height: 20),

                  // POPULAR COUNTRIES SECTION
                  if (filteredPopular.isNotEmpty) ...[
                    const SectionHeaderBadge(title: 'POPULAR COUNTRIES'),
                    const SizedBox(height: 8),
                    _buildCountryCard(filteredPopular),
                    const SizedBox(height: 20),
                  ],

                  // ALL COUNTRIES SECTION
                  if (filteredAll.isNotEmpty) ...[
                    const SectionHeaderBadge(title: 'ALL COUNTRIES'),
                    const SizedBox(height: 8),
                    _buildCountryCard(filteredAll),
                    const SizedBox(height: 24),
                  ],

                  if (filteredPopular.isEmpty && filteredAll.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'No country matches "$_searchQuery"',
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

  Widget _buildCountryCard(List<Map<String, String>> countries) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
        boxShadow: const [AuthColors.shadowCards1],
      ),
      child: Column(
        children: List.generate(countries.length, (index) {
          final country = countries[index];
          final flag = flagEmojiFromIso(country['code'] ?? '') ?? '🌐';
          final isLast = index == countries.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: () => _onCountrySelected(
                  country['name']!,
                  country['code']!,
                  country['calling']!,
                ),
                borderRadius: BorderRadius.vertical(
                  top: index == 0 ? const Radius.circular(16) : Radius.zero,
                  bottom: isLast ? const Radius.circular(16) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Text(flag, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          country['name']!,
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
                const Divider(height: 1, indent: 50, color: Color(0xFFF1F5F9)),
            ],
          );
        }),
      ),
    );
  }
}
