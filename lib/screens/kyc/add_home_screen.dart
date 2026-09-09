import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/routes/app_routes.dart';

class AddHomeScreen extends StatefulWidget {
  const AddHomeScreen({super.key});

  @override
  State<AddHomeScreen> createState() => _AddHomeScreenState();
}

class _AddHomeScreenState extends State<AddHomeScreen> {
  String country = 'India';
  String city = 'Bengaluru';
  String society = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FC),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildContent(),
                  ],
                ),
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFFC7E1F8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),

          // Back icon
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const SizedBox(
              width: 48,
              height: 56,
              child: Icon(
                Icons.arrow_back,
                size: 20,
                color: Color(0xFF17202A),
              ),
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                'Add Home',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ),
          ),

          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MAIN CONTENT
  // ---------------------------------------------------------------------------

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
      child: Column(
        children: [
          _buildHomeIcon(),
          const SizedBox(height: 16),

          const Text(
            'Enter your property details below',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 28),

          _buildFieldLabel('COUNTRY'),
          const SizedBox(height: 8),
          _buildDropdownField(
            value: country,
            flag: '🇮🇳',
            onTap: () {
              _showCountryPicker();
            },
          ),

          const SizedBox(height: 16),

          _buildFieldLabel('CITY'),
          const SizedBox(height: 8),
          _buildDropdownField(
            value: city,
            leadingIcon: Icons.location_on_outlined,
            onTap: () {
              _showCityPicker();
            },
          ),

          const SizedBox(height: 16),

          _buildFieldLabel('SOCIETY / APARTMENT'),
          const SizedBox(height: 8),
          _buildSocietyField(),

          const SizedBox(height: 6),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Search for your apartment or society',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          const SizedBox(height: 32),

          _buildContinueButton(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HOME ICON
  // ---------------------------------------------------------------------------

  Widget _buildHomeIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.home_outlined,
          color: Color(0xFF1677D2),
          size: 28,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LABEL
  // ---------------------------------------------------------------------------

  Widget _buildFieldLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: Color(0xFF374151),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DROPDOWN
  // ---------------------------------------------------------------------------

  Widget _buildDropdownField({
    required String value,
    String? flag,
    IconData? leadingIcon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFD6DEE8),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            if (flag != null) ...[
              Text(
                flag,
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 12),
            ],
            if (leadingIcon != null) ...[
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF4FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  leadingIcon,
                  size: 16,
                  color: const Color(0xFF006FC9),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF374151),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 22,
              color: Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SOCIETY FIELD
  // ---------------------------------------------------------------------------

  Widget _buildSocietyField() {
    return Container(
      height: 52,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF9AAAC0),
          width: 1,
        ),
      ),
      child: TextField(
        onChanged: (value) {
          society = value;
        },
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF374151),
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            size: 20,
            color: Color(0xFF6B7280),
          ),
          hintText: 'Enter Society Name',
          hintStyle: TextStyle(
            fontSize: 15,
            color: Color(0xFF6B7280),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 14,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CONTINUE BUTTON
  // ---------------------------------------------------------------------------

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.kycVerification);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF006FCB),
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.zero,
        ),
        child: const Text(
          'Continue',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM NAVIGATION
  // ---------------------------------------------------------------------------

  Widget _buildBottomNavigation() {
    return SafeArea(
      top: false,
      child: Container(
        height: 84,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFC7E3FF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(
              icon: Icons.home,
              label: 'Home',
              selected: true,
            ),
            _navItem(
              icon: Icons.person_outline,
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
              icon: Icons.menu,
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    bool selected = false,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: selected
                ? const BoxDecoration(
                    color: Color(0xFF0060BD),
                    shape: BoxShape.circle,
                  )
                : null,
            child: Icon(
              icon,
              size: 22,
              color: selected
                  ? Colors.white
                  : const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: selected
                  ? const Color(0xFF0060BD)
                  : const Color(0xFF475569),
              fontWeight:
                  selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // COUNTRY PICKER
  // ---------------------------------------------------------------------------

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text('🇮🇳'),
                title: const Text('India'),
                onTap: () {
                  setState(() {
                    country = 'India';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // CITY PICKER
  // ---------------------------------------------------------------------------

  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Bengaluru'),
                onTap: () {
                  setState(() {
                    city = 'Bengaluru';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Hyderabad'),
                onTap: () {
                  setState(() {
                    city = 'Hyderabad';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Mumbai'),
                onTap: () {
                  setState(() {
                    city = 'Mumbai';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
