import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';

class ScheduleVisitScreen extends StatefulWidget {
  const ScheduleVisitScreen({
    super.key,
    required this.projectName,
    required this.subtitleInfo,
  });

  final String projectName;
  final String subtitleInfo;

  @override
  State<ScheduleVisitScreen> createState() => _ScheduleVisitScreenState();
}

class _ScheduleVisitScreenState extends State<ScheduleVisitScreen> {
  String _selectedDay = 'Weekend';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _confirmVisit() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name.')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Visit Scheduled Successfully! Our team will contact you.'),
        backgroundColor: Color(0xFF059669),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleName = widget.projectName.isNotEmpty ? widget.projectName : 'Century Bliss';

    final headingColor = isDark ? AppColors.noticesHeadingDark : Colors.black87;
    final cardColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final cardBorderColor =
        isDark ? AppColors.noticesCardBorderDark : AppColors.noticesCardBorderLight;
    final titleTextColor =
        isDark ? AppColors.noticesTitleTextDark : AppColors.noticesTitleTextLight;
    final labelColor = isDark ? AppColors.noticesLabelTextDark : AppColors.noticesLabelTextLight;
    final dividerColor = isDark ? AppColors.noticesDividerDark : AppColors.noticesDividerLight;
    final amberAccent =
        isDark ? AppColors.noticesAccentAmberDark : AppColors.noticesAccentAmberLight;
    final amberStrongBorder =
        isDark ? AppColors.noticesAmberStrongBorderDark : AppColors.noticesAmberStrongBorderLight;
    final amberBg = isDark ? AppColors.noticesAmberBgDark : AppColors.noticesAmberBgLight;
    final mutedColor = isDark ? AppColors.noticesMutedDark : AppColors.noticesMutedLight;
    final borderColor = isDark ? AppColors.noticesBorderDark : AppColors.noticesBorderLight;
    final accentBlue =
        isDark ? AppColors.noticesAccentBlueDark : AppColors.noticesAccentBlueLight;
    final fieldFillColor =
        isDark ? AppColors.noticesBackgroundDark : AppColors.noticesBackgroundLight;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.noticesBackgroundDark : AppColors.noticesBackgroundLight,
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.noticesAppBarDark : AppColors.noticesAppBarLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: headingColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Schedule Your Visit',
          style: TextStyle(
            color: headingColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      bottomNavigationBar: const DashboardBottomNavigation(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Introductory Text below App Bar
            Text(
              'Pick your preferred day and we\'ll arrange a personalized tour of $titleName.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.noticesSecondaryTextDark : Colors.grey.shade800,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Subtitle Info Box (Orange Bordered Pill Container)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: amberStrongBorder),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.home_outlined,
                    color: amberAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.subtitleInfo.isNotEmpty
                          ? widget.subtitleInfo
                          : 'Freespirited 2 & 3 Bed Homes | Starting at ₹93.5 L*',
                      style: TextStyle(
                        color: amberAccent,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Preferred Visit Day Enclosed Card Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cardBorderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? .25 : .02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Header Row with right-aligned Orange Calendar Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Preferred Visit Day',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: titleTextColor,
                        ),
                      ),
                      Icon(
                        Icons.calendar_today_outlined,
                        color: amberAccent,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(height: 1, color: dividerColor),
                  const SizedBox(height: 12),

                  // Option 1: Weekday
                  InkWell(
                    onTap: () => setState(() => _selectedDay = 'Weekday'),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedDay == 'Weekday' ? amberBg : cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedDay == 'Weekday' ? amberStrongBorder : cardBorderColor,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _selectedDay == 'Weekday'
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: _selectedDay == 'Weekday' ? amberAccent : borderColor,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.business_center_outlined,
                            color: labelColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Weekday',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: titleTextColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Mon – Fri',
                            style: TextStyle(
                              fontSize: 11,
                              color: _selectedDay == 'Weekday' ? amberAccent : mutedColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Option 2: Weekend
                  InkWell(
                    onTap: () => setState(() => _selectedDay = 'Weekend'),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedDay == 'Weekend' ? amberBg : cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedDay == 'Weekend' ? amberStrongBorder : cardBorderColor,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _selectedDay == 'Weekend'
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: amberAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.wb_sunny_outlined,
                            color: amberAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Weekend',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: titleTextColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Sat – Sun',
                            style: TextStyle(
                              fontSize: 11,
                              color: amberAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Contact Details Enclosed Card Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cardBorderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? .25 : .02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Header Row with right-aligned Orange Person Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Contact Details',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: titleTextColor,
                        ),
                      ),
                      Icon(
                        Icons.person_outline,
                        color: amberAccent,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(height: 1, color: dividerColor),
                  const SizedBox(height: 14),

                  // Full Name Field
                  Text(
                    'Full Name',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: labelColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameController,
                    style: TextStyle(fontSize: 13, color: headingColor),
                    decoration: InputDecoration(
                      hintText: 'Enter full name',
                      hintStyle: TextStyle(fontSize: 12.5, color: isDark ? AppColors.noticesMutedDark : Colors.grey.shade400),
                      prefixIcon: Icon(Icons.person_outline, size: 18, color: isDark ? AppColors.noticesMutedDark : Colors.grey),
                      filled: true,
                      fillColor: fieldFillColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cardBorderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cardBorderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: accentBlue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Phone Number Field
                  Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: labelColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontSize: 13, color: headingColor),
                    decoration: InputDecoration(
                      hintText: 'Enter phone number',
                      hintStyle: TextStyle(fontSize: 12.5, color: isDark ? AppColors.noticesMutedDark : Colors.grey.shade400),
                      prefixIcon: Icon(Icons.phone_outlined, size: 18, color: isDark ? AppColors.noticesMutedDark : Colors.grey),
                      filled: true,
                      fillColor: fieldFillColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cardBorderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cardBorderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: accentBlue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Email Address Field
                  Text(
                    'Email Address',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: labelColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 13, color: headingColor),
                    decoration: InputDecoration(
                      hintText: 'Enter email address',
                      hintStyle: TextStyle(fontSize: 12.5, color: isDark ? AppColors.noticesMutedDark : Colors.grey.shade400),
                      prefixIcon: Icon(Icons.email_outlined, size: 18, color: isDark ? AppColors.noticesMutedDark : Colors.grey),
                      filled: true,
                      fillColor: fieldFillColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cardBorderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cardBorderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: accentBlue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Confirm Visit Button
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: _confirmVisit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Confirm Visit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Center(
              child: Text(
                'By submitting, you agree to our Terms & Privacy Policy.',
                style: TextStyle(fontSize: 11, color: isDark ? AppColors.noticesMutedDark : Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
