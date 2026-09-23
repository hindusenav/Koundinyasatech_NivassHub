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
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final titleName = widget.projectName.isNotEmpty ? widget.projectName : 'Century Bliss';

    final cardColor = isDark ? AppColors.surfaceDark : const Color(0xFFFFFFFF);
    final cardBorderColor = isDark ? AppColors.noticesCardBorderDark : const Color(0xFFE2E8F0);
    final amberAccent = const Color(0xFFEC9211);
    final amberStrongBorder = const Color(0xFFEC9211);
    final fieldFillColor = isDark ? AppColors.noticesBackgroundDark : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.noticesBackgroundDark : const Color(0xFFEBF5FF),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header Container matching Figma specs: background #C7E3FF edge-to-edge
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: statusBarHeight + 12,
                right: 20,
                bottom: 16,
                left: 20,
              ),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFC7E3FF),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  // Greeting Container (Title Pill) matching Figma specs: height 38px, radius 40px, border 1px #CCDFF2
                  Expanded(
                    child: Container(
                      height: 38,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFCCDFF2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Schedule Your Visit',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 24,
                  right: 20,
                  bottom: 24,
                  left: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Introductory Text (Text header-desc: DM Sans 500 Medium 14px height 20/14 #000000)
                    Text(
                      'Pick your preferred day and we\'ll arrange a personalized tour of $titleName.',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 20 / 14,
                        letterSpacing: 0,
                        color: isDark ? AppColors.noticesSecondaryTextDark : const Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Subtitle Info Box (reminder-banner-container: height 36px, #FFFFFF bg, border 1px #EC9211)
                    Container(
                      width: double.infinity,
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.noticesAmberBgDark : const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: amberStrongBorder, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home_outlined,
                            color: amberAccent,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            // Text banner-text (DM Sans 600 SemiBold 12px height 1.0 #EC9211)
                            child: Text(
                              widget.subtitleInfo.isNotEmpty
                                  ? widget.subtitleInfo
                                  : 'Freespirited 2 & 3 Bed Homes | Starting at ₹92.5 L*',
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                color: amberAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                height: 1.0,
                                letterSpacing: 0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Preferred Visit Day Enclosed Card Container
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: cardBorderColor, width: 1),
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
                          // Card Header Row with right-aligned Orange Calendar Icon (day-card-header: space-between)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text day-card-title (DM Sans 700 Bold 15px height 1.0 #05234D)
                              Text(
                                'Preferred Visit Day',
                                style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  height: 1.0,
                                  letterSpacing: 0,
                                  color: isDark
                                      ? AppColors.noticesTitleTextDark
                                      : const Color(0xFF05234D),
                                ),
                              ),
                              // icon-calendar (16px, #EC9211)
                              Icon(
                                Icons.calendar_today_outlined,
                                color: amberAccent,
                                size: 16,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Option 1: Weekday (option-weekday: padding 12px, radius 10px, border 1px #E2E8F0, gap 12px)
                          InkWell(
                            onTap: () => setState(() => _selectedDay = 'Weekday'),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _selectedDay == 'Weekday'
                                    ? const Color(0xFFC5A880).withValues(alpha: 0.0392)
                                    : cardColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _selectedDay == 'Weekday'
                                      ? amberStrongBorder
                                      : cardBorderColor,
                                  width: _selectedDay == 'Weekday' ? 1.5 : 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _selectedDay == 'Weekday'
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: _selectedDay == 'Weekday'
                                        ? amberAccent
                                        : const Color(0xFF94A3B8),
                                    size: _selectedDay == 'Weekday' ? 20 : 18,
                                  ),
                                  const SizedBox(width: 12),
                                  // icon-briefcase (14px, #1E293B)
                                  Icon(
                                    Icons.business_center_outlined,
                                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 8),
                                  // Text option-name (DM Sans 600 SemiBold 14px height 1.0 #1E293B)
                                  Text(
                                    'Weekday',
                                    style: TextStyle(
                                      fontFamily: 'DM Sans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      height: 1.0,
                                      letterSpacing: 0,
                                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                                    ),
                                  ),
                                  const Spacer(),
                                  // Text option-days (DM Sans 500 Medium 12px height 1.0 #94A3B8)
                                  Text(
                                    'Mon – Fri',
                                    style: TextStyle(
                                      fontFamily: 'DM Sans',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 1.0,
                                      letterSpacing: 0,
                                      color: _selectedDay == 'Weekday'
                                          ? amberAccent
                                          : const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Option 2: Weekend (option-weekend: padding 12px, radius 10px, border 1.5px #EC9211, bg #C5A880 3.92%)
                          InkWell(
                            onTap: () => setState(() => _selectedDay = 'Weekend'),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _selectedDay == 'Weekend'
                                    ? const Color(0xFFC5A880).withValues(alpha: 0.0392)
                                    : cardColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _selectedDay == 'Weekend'
                                      ? amberStrongBorder
                                      : cardBorderColor,
                                  width: _selectedDay == 'Weekend' ? 1.5 : 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // radio-container-active (fixed 20px size, #EC9211)
                                  Icon(
                                    _selectedDay == 'Weekend'
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: amberAccent,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.wb_sunny_outlined,
                                    color: amberAccent,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 8),
                                  // Text option-name (DM Sans 700 Bold 14px height 1.0 #05234D)
                                  Text(
                                    'Weekend',
                                    style: TextStyle(
                                      fontFamily: 'DM Sans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      height: 1.0,
                                      letterSpacing: 0,
                                      color: isDark ? Colors.white : const Color(0xFF05234D),
                                    ),
                                  ),
                                  const Spacer(),
                                  // Text option-days (DM Sans 600 SemiBold 12px height 1.0 #EC9211)
                                  Text(
                                    'Sat – Sun',
                                    style: TextStyle(
                                      fontFamily: 'DM Sans',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      height: 1.0,
                                      letterSpacing: 0,
                                      color: amberAccent,
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
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: cardBorderColor, width: 1),
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
                          // Card Header Row with right-aligned Orange Person Icon (contact-header: space-between)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text contact-title (DM Sans 700 Bold 15px height 1.0 #05234D)
                              Text(
                                'Contact Details',
                                style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  height: 1.0,
                                  letterSpacing: 0,
                                  color: isDark
                                      ? AppColors.noticesTitleTextDark
                                      : const Color(0xFF05234D),
                                ),
                              ),
                              // icon-person (16px, #EC9211)
                              Icon(
                                Icons.person_outline,
                                color: amberAccent,
                                size: 16,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Full Name Field (field-name: gap 6px, Text label: DM Sans 600 12px height 1.0 #3E3E3E, input-box: radius 8px, padding 10/12/10/12, fill #F8FAFC, border #E2E8F0)
                          Text(
                            'Full Name',
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                              letterSpacing: 0,
                              color: isDark ? AppColors.noticesLabelTextDark : const Color(0xFF3E3E3E),
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 38,
                            child: TextField(
                              controller: _nameController,
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.0,
                                letterSpacing: 0,
                                color: isDark ? Colors.white : const Color(0xFF3E3E3E),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter full name',
                                hintStyle: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.0,
                                  letterSpacing: 0,
                                  color: const Color(0xFF94A3B8),
                                ),
                                prefixIcon: const Icon(Icons.person_outline, size: 14, color: Color(0xFF64748B)),
                                filled: true,
                                fillColor: fieldFillColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                isDense: true,
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
                                  borderSide: const BorderSide(color: Color(0xFF0060BD)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Phone Number Field
                          Text(
                            'Phone Number',
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                              letterSpacing: 0,
                              color: isDark ? AppColors.noticesLabelTextDark : const Color(0xFF3E3E3E),
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 38,
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.0,
                                letterSpacing: 0,
                                color: isDark ? Colors.white : const Color(0xFF3E3E3E),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter phone number',
                                hintStyle: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.0,
                                  letterSpacing: 0,
                                  color: const Color(0xFF94A3B8),
                                ),
                                prefixIcon: const Icon(Icons.phone_outlined, size: 14, color: Color(0xFF64748B)),
                                filled: true,
                                fillColor: fieldFillColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                isDense: true,
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
                                  borderSide: const BorderSide(color: Color(0xFF0060BD)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Email Address Field
                          Text(
                            'Email Address',
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                              letterSpacing: 0,
                              color: isDark ? AppColors.noticesLabelTextDark : const Color(0xFF3E3E3E),
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 38,
                            child: TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.0,
                                letterSpacing: 0,
                                color: isDark ? Colors.white : const Color(0xFF3E3E3E),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter email address',
                                hintStyle: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.0,
                                  letterSpacing: 0,
                                  color: const Color(0xFF94A3B8),
                                ),
                                prefixIcon: const Icon(Icons.email_outlined, size: 14, color: Color(0xFF64748B)),
                                filled: true,
                                fillColor: fieldFillColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                isDense: true,
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
                                  borderSide: const BorderSide(color: Color(0xFF0060BD)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Confirm Visit Button matching cta-button: height 48px, radius 12px, #0060BD
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _confirmVisit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0060BD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Confirm Visit',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            height: 1.0,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Text disclaimer (Footer Section: DM Sans 500 Medium 11px height 1.0 #3E3E3E)
                    Center(
                      child: Text(
                        'By submitting, you agree to our Terms & Privacy Policy.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                          letterSpacing: 0,
                          color: isDark
                              ? AppColors.noticesMutedDark
                              : const Color(0xFF3E3E3E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const DashboardBottomNavigation(),
    );
  }
}
