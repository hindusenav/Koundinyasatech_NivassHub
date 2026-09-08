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
                    const SizedBox(height: 18),
                    _buildBottomNavigation(),
                  ],
                ),
              ),
            ),
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
      height: 50,
      decoration: const BoxDecoration(
        color: Color(0xFFC7E1F8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),

          // Back icon
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const SizedBox(
              width: 35,
              height: 40,
              child: Icon(
                Icons.arrow_back,
                size: 16,
                color: Color(0xFF17202A),
              ),
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                'Add Home',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ),
          ),

          const SizedBox(width: 47),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MAIN CONTENT
  // ---------------------------------------------------------------------------

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(9, 18, 9, 0),
      child: Column(
        children: [
          _buildHomeIcon(),
          const SizedBox(height: 12),

          const Text(
            'Enter your property details below',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 7,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 17),

          _buildFieldLabel('COUNTRY'),
          const SizedBox(height: 5),
          _buildDropdownField(
            value: country,
            flag: '🇮🇳',
            onTap: () {
              _showCountryPicker();
            },
          ),

          const SizedBox(height: 10),

          _buildFieldLabel('CITY'),
          const SizedBox(height: 5),
          _buildDropdownField(
            value: city,
            onTap: () {
              _showCityPicker();
            },
          ),

          const SizedBox(height: 10),

          _buildFieldLabel('SOCIETY / APARTMENT'),
          const SizedBox(height: 5),
          _buildSocietyField(),

          const SizedBox(height: 5),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Search for your apartment or society',
              style: TextStyle(
                fontSize: 6.5,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          const SizedBox(height: 29),

          _buildContinueButton(),

          const SizedBox(height: 18),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HOME ICON
  // ---------------------------------------------------------------------------

  Widget _buildHomeIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.home_outlined,
          color: Color(0xFF1677D2),
          size: 22,
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
          fontSize: 6.5,
          fontWeight: FontWeight.w700,
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
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 27,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: const Color(0xFFD6DEE8),
            width: 0.7,
          ),
        ),
        child: Row(
          children: [
            if (flag != null) ...[
              Text(
                flag,
                style: const TextStyle(fontSize: 11),
              ),
              const SizedBox(width: 7),
            ],
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 7.5,
                  color: Color(0xFF374151),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 13,
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
      height: 27,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color(0xFF9AAAC0),
          width: 0.8,
        ),
      ),
      child: TextField(
        onChanged: (value) {
          society = value;
        },
        style: const TextStyle(
          fontSize: 7.5,
          color: Color(0xFF374151),
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            size: 13,
            color: Color(0xFF6B7280),
          ),
          hintText: 'Enter Society Name',
          hintStyle: TextStyle(
            fontSize: 7.5,
            color: Color(0xFF6B7280),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 8,
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
      height: 28,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.kycVerification);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF006FCB),
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.zero,
        ),
        child: const Text(
          'Continue',
          style: TextStyle(
            fontSize: 8,
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
    return Container(
      height: 53,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFC7E1F8),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(13),
          topRight: Radius.circular(13),
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
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    bool selected = false,
  }) {
    return SizedBox(
      width: 43,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 19,
            height: 19,
            decoration: selected
                ? const BoxDecoration(
                    color: Color(0xFF0876D1),
                    shape: BoxShape.circle,
                  )
                : null,
            child: Icon(
              icon,
              size: 11,
              color: selected
                  ? Colors.white
                  : const Color(0xFF526170),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 5.5,
              color: selected
                  ? const Color(0xFF0876D1)
                  : const Color(0xFF526170),
              fontWeight:
                  selected ? FontWeight.w700 : FontWeight.w400,
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