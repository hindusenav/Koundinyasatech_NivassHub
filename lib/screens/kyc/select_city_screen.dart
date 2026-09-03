import 'package:flutter/material.dart';
import 'add_home_screen.dart';

class SelectCityScreen extends StatefulWidget {
  final String country;

  const SelectCityScreen({
    super.key,
    required this.country,
  });

  @override
  State<SelectCityScreen> createState() =>
      _SelectCityScreenState();
}

class _SelectCityScreenState
    extends State<SelectCityScreen> {
  int _step = 0;

  String? _selectedCity;
  String? _selectedBuilding;

  final List<String> _cities = [
    'Bangalore',
    'Mumbai',
    'Delhi',
    'Chennai',
    'Hyderabad',
    'Pune',
    'Kolkata',
    'Ahmedabad',
  ];

  final List<String> _buildings = [
    'Kamataka',
    'Bangalore Urban',
    'Bengaluru',
    'Electronic City',
  ];

  void _continueFromCity() {
    if (_selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a city'),
        ),
      );
      return;
    }

    setState(() {
      _step = 1;
    });
  }

  void _confirmCity() {
    if (_selectedBuilding == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please confirm your city'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddHomeScreen(
          country: widget.country,
          city: _selectedCity!,
          building: _selectedBuilding!,
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
            if (_step == 1) {
              setState(() {
                _step = 0;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),

        title: Text(
          _step == 0
              ? 'Select City'
              : 'Confirm City',
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: _step == 0
            ? _buildSelectCity(
                textColor,
                secondaryText,
                isDark,
                primaryBlue,
              )
            : _buildConfirmCity(
                textColor,
                secondaryText,
                isDark,
                primaryBlue,
              ),
      ),
    );
  }

  Widget _buildSelectCity(
    Color textColor,
    Color secondaryText,
    bool isDark,
    Color primaryBlue,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        16,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            'Select your city',
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Choose your city in ${widget.country}.',
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
                hintText: 'Search your city...',
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
            child: GridView.builder(
              physics:
                  const BouncingScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.45,
              ),
              itemCount: _cities.length,

              itemBuilder: (context, index) {
                final city = _cities[index];

                final selected =
                    _selectedCity == city;

                return InkWell(
                  borderRadius:
                      BorderRadius.circular(10),

                  onTap: () {
                    setState(() {
                      _selectedCity = city;
                    });
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      color: selected
                          ? primaryBlue
                              .withValues(alpha: 0.08)
                          : isDark
                              ? const Color(0xFF1E1E1E)
                              : const Color(0xFFF8F8F8),

                      borderRadius:
                          BorderRadius.circular(10),

                      border: Border.all(
                        color: selected
                            ? primaryBlue
                            : isDark
                                ? Colors.white24
                                : Colors.black12,
                      ),
                    ),

                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [
                        Icon(
                          Icons.location_city,
                          color: selected
                              ? primaryBlue
                              : Colors.grey,
                          size: 24,
                        ),

                        const SizedBox(height: 6),

                        Text(
                          city,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
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
              onPressed: _continueFromCity,
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmCity(
    Color textColor,
    Color secondaryText,
    bool isDark,
    Color primaryBlue,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        16,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            'Confirm City',
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Please confirm the details before continuing.',
            style: TextStyle(
              color: secondaryText,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E1E1E)
                  : const Color(0xFFF7F9FC),

              borderRadius:
                  BorderRadius.circular(12),

              border: Border.all(
                color: isDark
                    ? Colors.white24
                    : Colors.black12,
              ),
            ),

            child: Column(
              children: [
                _detailRow(
                  icon: Icons.flag_outlined,
                  title: 'Country',
                  value: widget.country,
                  textColor: textColor,
                  secondaryText:
                      secondaryText,
                ),

                const SizedBox(height: 18),

                _detailRow(
                  icon: Icons.location_city,
                  title: 'City',
                  value: _selectedCity ?? '',
                  textColor: textColor,
                  secondaryText:
                      secondaryText,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Select area',
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 14,
            ),

            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E1E1E)
                  : Colors.white,

              borderRadius:
                  BorderRadius.circular(10),

              border: Border.all(
                color: isDark
                    ? Colors.white24
                    : Colors.black12,
              ),
            ),

            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBuilding,
                isExpanded: true,
                hint: Text(
                  'Select area',
                  style: TextStyle(
                    color: secondaryText,
                  ),
                ),

                dropdownColor: isDark
                    ? const Color(0xFF1E1E1E)
                    : Colors.white,

                items: _buildings
                    .map(
                      (item) =>
                          DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                            color: textColor,
                          ),
                        ),
                      ),
                    )
                    .toList(),

                onChanged: (value) {
                  setState(() {
                    _selectedBuilding =
                        value;
                  });
                },
              ),
            ),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            height: 50,

            child: ElevatedButton(
              onPressed: _confirmCity,

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
                'Confirm City',
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
  }

  Widget _detailRow({
    required IconData icon,
    required String title,
    required String value,
    required Color textColor,
    required Color secondaryText,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1976D2)
                .withValues(alpha: 0.10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF1976D2),
            size: 21,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                title,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}