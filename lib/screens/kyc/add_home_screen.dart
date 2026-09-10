import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';

class AddHomeScreen extends StatefulWidget {
  const AddHomeScreen({super.key});

  @override
  State<AddHomeScreen> createState() => _AddHomeScreenState();
}

class _AddHomeScreenState extends State<AddHomeScreen> {
  // ============================================================
  // VALUES
  // ============================================================

  String country = 'India';
  String city = 'Bengaluru';
  String society = '';

  // ============================================================
  // ASSETS
  // ============================================================

  static const String _homeIcon = 'assets/icons/kyc_homeimg.png';
  static const String _locationIcon = 'assets/icons/locationkycimg.png';

  // ============================================================
  // COLORS
  // ============================================================

  static const Color backgroundColor = Color(0xFFF5F9FD);
  static const Color headerColor = Color(0xFFC7E1F8);
  static const Color bottomNavColor = Color(0xFFC7E3FF);
  static const Color primaryBlue = Color(0xFF0072CE);
  static const Color selectedBlue = Color(0xFF0068C9);
  static const Color textColor = Color(0xFF17202A);
  static const Color labelColor = Color(0xFF374151);
  static const Color secondaryText = Color(0xFF7A8795);
  static const Color borderColor = Color(0xFFD3DCE6);

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // HEADER
            _buildHeader(),

            // CONTENT
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: _buildContent(),
                    ),
                  );
                },
              ),
            ),

            // BOTTOM NAVIGATION
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 56,
      color: headerColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 4,
            top: 0,
            bottom: 0,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(30),
              child: const SizedBox(
                width: 48,
                height: 56,
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    size: 22,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
          const Center(
            child: Text(
              'Add Home',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textColor,
                letterSpacing: 0.15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MAIN CONTENT
  // ============================================================

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HOME ICON
          Center(
            child: _buildHomeIcon(),
          ),

          const SizedBox(height: 20),

          // DESCRIPTION
          const Center(
            child: Text(
              'Enter your property details below',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: secondaryText,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // COUNTRY
          _buildFieldLabel('COUNTRY'),
          const SizedBox(height: 8),
          _buildCountryField(),

          const SizedBox(height: 20),

          // CITY
          _buildFieldLabel('CITY'),
          const SizedBox(height: 8),
          _buildCityField(),

          const SizedBox(height: 20),

          // SOCIETY / APARTMENT
          _buildFieldLabel('SOCIETY / APARTMENT'),
          const SizedBox(height: 8),
          _buildSocietyField(),

          const SizedBox(height: 8),

          const Text(
            'Search for your apartment or society',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: secondaryText,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 48),

          // CONTINUE BUTTON
          _buildContinueButton(),
        ],
      ),
    );
  }

  // ============================================================
  // HOME ICON
  // ============================================================

  Widget _buildHomeIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          _homeIcon,
          width: 44,
          height: 44,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.home_outlined,
              color: primaryBlue,
              size: 40,
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // FIELD LABEL
  // ============================================================

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        color: labelColor,
      ),
    );
  }

  // ============================================================
  // COUNTRY FIELD
  // ============================================================

  Widget _buildCountryField() {
    return GestureDetector(
      onTap: _showCountryPicker,
      child: Container(
        height: 52,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            const Text(
              '🇮🇳',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                country,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 22,
              color: secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CITY FIELD
  // ============================================================

  Widget _buildCityField() {
    return GestureDetector(
      onTap: _showCityPicker,
      child: Container(
        height: 52,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF4FF),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  _locationIcon,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: primaryBlue,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                city,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 22,
              color: secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SOCIETY FIELD
  // ============================================================

  Widget _buildSocietyField() {
    return Container(
      height: 52,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF9EADC0),
          width: 1.5,
        ),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            society = value;
          });
        },
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 22,
            color: Color(0xFF64748B),
          ),
          hintText: 'Enter Society Name',
          hintStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6B7280),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CONTINUE BUTTON
  // ============================================================

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.kycVerification,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.16),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Continue',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: const BoxDecoration(
        color: bottomNavColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          _navItem(
            icon: Icons.home_rounded,
            label: 'Home',
            selected: true,
          ),
          _navItem(
            icon: Icons.person_outline_rounded,
            label: 'Visitors',
          ),
          _navItem(
            icon: Icons.apartment_outlined,
            label: 'Community',
          ),
          _navItem(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Payments',
          ),
          _navItem(
            icon: Icons.menu_rounded,
            label: 'More',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NAVIGATION ITEM
  // ============================================================

  Widget _navItem({
    required IconData icon,
    required String label,
    bool selected = false,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          // Connect navigation here later.
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: selected
                    ? const BoxDecoration(
                        color: selectedBlue,
                        shape: BoxShape.circle,
                      )
                    : null,
                child: Center(
                  child: Icon(
                    icon,
                    size: 20,
                    color: selected
                        ? Colors.white
                        : const Color(0xFF475569),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: selected
                      ? selectedBlue
                      : const Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // COUNTRY PICKER
  // ============================================================

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Country',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  leading: const Text(
                    '🇮🇳',
                    style: TextStyle(fontSize: 28),
                  ),
                  title: const Text(
                    'India',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.check_circle,
                    size: 24,
                    color: primaryBlue,
                  ),
                  onTap: () {
                    setState(() {
                      country = 'India';
                    });
                    Navigator.pop(sheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // CITY PICKER
  // ============================================================

  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select City',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 16),
                _cityOption(sheetContext, 'Bengaluru'),
                _cityOption(sheetContext, 'Hyderabad'),
                _cityOption(sheetContext, 'Mumbai'),
                _cityOption(sheetContext, 'Chennai'),
                _cityOption(sheetContext, 'Delhi NCR'),
                _cityOption(sheetContext, 'Pune'),
                _cityOption(sheetContext, 'Kolkata'),
                _cityOption(sheetContext, 'Ahmedabad'),
                _cityOption(sheetContext, 'Kochi'),
                _cityOption(sheetContext, 'Noida'),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // CITY OPTION
  // ============================================================

  Widget _cityOption(
    BuildContext sheetContext,
    String value,
  ) {
    final bool isSelected = city == value;

    return InkWell(
      onTap: () {
        setState(() {
          city = value;
        });
        Navigator.pop(sheetContext);
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Image.asset(
                  _locationIcon,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.location_on_outlined,
                      size: 22,
                      color: primaryBlue,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                size: 24,
                color: primaryBlue,
              ),
          ],
        ),
      ),
    );
  }
}