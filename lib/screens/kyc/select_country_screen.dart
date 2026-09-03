import 'package:flutter/material.dart';
import 'select_city_screen.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({
    super.key,
  });

  @override
  State<SelectCountryScreen> createState() =>
      _SelectCountryScreenState();
}

class _SelectCountryScreenState
    extends State<SelectCountryScreen> {
  String? _selectedCountry;

  final List<Map<String, String>> _countries = [
    {
      'name': 'India',
      'flag': '🇮🇳',
    },
    {
      'name': 'Kenya',
      'flag': '🇰🇪',
    },
    {
      'name': 'United Arab Emirates',
      'flag': '🇦🇪',
    },
    {
      'name': 'Philippines',
      'flag': '🇵🇭',
    },
    {
      'name': 'Canada',
      'flag': '🇨🇦',
    },
    {
      'name': 'Germany',
      'flag': '🇩🇪',
    },
    {
      'name': 'Singapore',
      'flag': '🇸🇬',
    },
    {
      'name': 'United Kingdom',
      'flag': '🇬🇧',
    },
  ];

  void _continue() {
    if (_selectedCountry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a country'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectCityScreen(
          country: _selectedCountry!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final background =
        isDark ? const Color(0xFF121212) : Colors.white;

    final textColor =
        isDark ? Colors.white : const Color(0xFF1A1A1A);

    final secondaryText =
        isDark ? Colors.white70 : Colors.black54;

    const primaryBlue = Color(0xFF1976D2);

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: textColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Select Country',
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding =
                constraints.maxWidth < 360 ? 16.0 : 22.0;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                18,
                horizontalPadding,
                16,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    'Choose your country',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Please select your country to continue.',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xFFF6F8FB),
                      borderRadius:
                          BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? Colors.white24
                            : Colors.black12,
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search your country...',
                        hintStyle: TextStyle(
                          color: secondaryText,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: secondaryText,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView.separated(
                      physics:
                          const BouncingScrollPhysics(),
                      itemCount: _countries.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),

                      itemBuilder: (context, index) {
                        final item =
                            _countries[index];

                        final country = item['name']!;
                        final flag = item['flag']!;

                        final selected =
                            _selectedCountry ==
                                country;

                        return InkWell(
                          borderRadius:
                              BorderRadius.circular(12),

                          onTap: () {
                            setState(() {
                              _selectedCountry =
                                  country;
                            });
                          },

                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),

                            decoration:
                                BoxDecoration(
                              color: selected
                                  ? primaryBlue
                                      .withValues(
                                          alpha: 0.08)
                                  : isDark
                                      ? const Color(
                                          0xFF1E1E1E)
                                      : Colors.white,

                              borderRadius:
                                  BorderRadius.circular(
                                      12),

                              border: Border.all(
                                color: selected
                                    ? primaryBlue
                                    : isDark
                                        ? Colors.white24
                                        : Colors.black12,
                              ),
                            ),

                            child: Row(
                              children: [
                                Text(
                                  flag,
                                  style:
                                      const TextStyle(
                                    fontSize: 25,
                                  ),
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Text(
                                    country,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 15,
                                      fontWeight:
                                          selected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                    ),
                                  ),
                                ),

                                Icon(
                                  selected
                                      ? Icons
                                          .radio_button_checked
                                      : Icons
                                          .radio_button_off,
                                  color: selected
                                      ? primaryBlue
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton(
                      onPressed: _continue,

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),

                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}