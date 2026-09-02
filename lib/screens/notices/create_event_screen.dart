import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/providers/notices/notices_provider.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';

/// Screen matching Figma "Community - New Event"
class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final String _selectedVisibility = 'All Residents';
  String _selectedDateTime = 'Configure event start, end, and duration';
  String _selectedVenue = 'Set the location, park block, or clubhouse';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submitEvent() async {
    final details = _detailsController.text.trim();
    final title = _titleController.text.trim().isNotEmpty
        ? _titleController.text.trim()
        : 'Community Event';

    if (details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter event details.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    bool success = false;
    String? errorMessage;

    try {
      NoticesProvider? provider;
      try {
        provider = Provider.of<NoticesProvider>(context, listen: false);
      } catch (_) {}

      if (provider != null) {
        success = await provider.createEvent(
          title: title,
          description: details,
          startDateTime: DateTime.now().toIso8601String(),
          endDateTime: DateTime.now()
              .add(const Duration(hours: 3))
              .toIso8601String(),
          venueName: _selectedVenue.contains('Central')
              ? _selectedVenue
              : 'Club House',
          visibility: _selectedVisibility,
        );
        errorMessage = provider.errorMessage;
      } else {
        errorMessage = 'Unable to publish right now. Please try again.';
      }
    } catch (_) {
      errorMessage = 'Unable to publish right now. Please try again.';
    }

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event published successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage ?? 'Failed to publish event. Please try again.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerColor =
        isDark ? AppColors.dashboardHeaderDark : const Color(0xFFC7E3FF);
    final titleColor =
        isDark ? AppColors.noticesHeadingDark : const Color(0xFF05234D);
    final mutedColor = isDark ? AppColors.noticesMutedDark : AppColors.noticesMutedLight;
    final accentBlue =
        isDark ? AppColors.noticesAccentBlueDark : const Color(0xFF0060BD);

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      appBar: AppBar(
        backgroundColor: headerColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: titleColor),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          'New Event',
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.noticesBlueTintBgDark : const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.noticesBlueBorderDark : const Color(0xFFCCDFF2),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline, size: 14, color: accentBlue),
                      const SizedBox(width: 4),
                      Text(
                        'Guidelines',
                        style: TextStyle(
                          color: accentBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            isDark ? AppColors.noticesAccentAmberDark : const Color(0xFFEC9211),
                        child: const Text(
                          'A',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 1.0,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Name',
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              height: 1.0,
                              letterSpacing: 0,
                              color: isDark ? AppColors.noticesHeadingDark : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Apartment B 402',
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                              letterSpacing: 0,
                              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF05234D),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : const Color(0xFFFFFFFF),
                      border: Border.all(
                        color: isDark ? AppColors.noticesBorderDark : const Color(0xFFE2E8F0),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedVisibility,
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                            letterSpacing: 0,
                            color: isDark ? titleColor : const Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: isDark ? titleColor : const Color(0xFF475569),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _detailsController,
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                      letterSpacing: 0,
                      color: titleColor,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Add details about your event...',
                      hintStyle: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        letterSpacing: 0,
                        color: isDark ? mutedColor : const Color(0xFF3E3E3E),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _EventConfigTile(
                    icon: Icons.calendar_today_outlined,
                    title: 'Add Date & Time',
                    subtitle: _selectedDateTime,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _selectedDateTime =
                              '${date.day}/${date.month}/${date.year} at 7:00 PM';
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
            _EventConfigTile(
              icon: Icons.location_on_outlined,
              title: 'Add Venue',
              subtitle: _selectedVenue,
              onTap: () {
                setState(() {
                  _selectedVenue = 'Central Clubhouse & Lawn';
                });
              },
            ),
          ],
        ),
      ),
    ],
  ),
),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.noticesCardBorderDark : AppColors.noticesCardBorderLight,
                  ),
                ),
              ),
              child: Row(
                children: [
                  _MediaIconButton(icon: Icons.image_outlined, onTap: () {}),
                  const SizedBox(width: 8),
                  _MediaIconButton(icon: Icons.camera_alt_outlined, onTap: () {}),
                  const SizedBox(width: 8),
                  _MediaIconButton(icon: Icons.videocam_outlined, onTap: () {}),
                  const SizedBox(width: 8),
                  _MediaIconButton(icon: Icons.mic_none_outlined, onTap: () {}),
                  const Spacer(),
                  Material(
                    color: accentBlue,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: _isSubmitting ? null : _submitEvent,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Publish Event',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const DashboardBottomNavigation(selectedIndex: 2),
        ],
      ),
    );
  }
}

class _MediaIconButton extends StatelessWidget {
  const _MediaIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.noticesCardBorderDark : AppColors.noticesCardBorderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .25 : .03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: isDark ? AppColors.noticesBodyTextDark : AppColors.noticesBodyTextLight,
          size: 18,
        ),
        onPressed: onTap,
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}

class _EventConfigTile extends StatelessWidget {
  const _EventConfigTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.noticesCardBorderDark : const Color(0xFFE2E8F0),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? .25 : .0314),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.noticesBlueTintBgDark : const Color(0xFFF0F7FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark
                      ? AppColors.noticesBlueLightBorderDark
                      : const Color(0xFFE0F2FE),
                ),
              ),
              child: Icon(
                icon,
                color: isDark ? AppColors.noticesAccentBlueDark : const Color(0xFF0060BD),
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.0,
                      letterSpacing: 0,
                      color: isDark ? AppColors.noticesHeadingDark : const Color(0xFF05234D),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                      letterSpacing: 0,
                      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF3E3E3E),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? AppColors.noticesSecondaryTextDark : const Color(0xFF64748B),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
