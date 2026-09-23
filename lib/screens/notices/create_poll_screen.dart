import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/providers/notices/notices_provider.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';

/// Screen matching Figma "Community - New Poll"
class CreatePollScreen extends StatefulWidget {
  const CreatePollScreen({super.key});

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  final String _selectedVisibility = 'All Residents';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _questionController.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    if (_optionControllers.length < 6) {
      setState(() {
        _optionControllers.add(TextEditingController());
      });
    }
  }

  Future<void> _submitPoll() async {
    final question = _questionController.text.trim();
    final options = _optionControllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a poll question.')),
      );
      return;
    }
    if (options.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least 2 poll options.')),
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
        success = await provider.createPoll(
          question: question,
          options: options,
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
          const SnackBar(content: Text('Poll published successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage ?? 'Failed to publish poll. Please try again.',
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
    final secondaryColor =
        isDark ? AppColors.noticesSecondaryTextDark : AppColors.noticesSecondaryTextLight;

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
          'New Poll',
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
                  Text(
                    'Add a description to your poll...',
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                      letterSpacing: 0,
                      color: isDark ? secondaryColor : const Color(0xFF3E3E3E),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.noticesCardBorderDark : const Color(0xFFE2E8F0),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 3,
                          height: 18,
                          decoration: BoxDecoration(
                            color: accentBlue,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _questionController,
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                              letterSpacing: 0,
                              color: titleColor,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Write your poll question here...',
                              hintStyle: TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                height: 1.0,
                                letterSpacing: 0,
                                color: isDark ? accentBlue : const Color(0xFF0060BD),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
            for (int i = 0; i < _optionControllers.length; i++) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? AppColors.noticesCardBorderDark
                        : const Color(0xFFE2E8F0),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _optionControllers[i],
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                          letterSpacing: 0,
                          color: titleColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Option ${i + 1}',
                          hintStyle: TextStyle(
                            fontFamily: 'DM Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.0,
                            letterSpacing: 0,
                            color: isDark ? mutedColor : const Color(0xFF3E3E3E),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.crop_square,
                      color: isDark ? AppColors.noticesBorderDark : const Color(0xFF94A3B8),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _addOption,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      color: isDark ? accentBlue : const Color(0xFF0060BD),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Add Option',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        letterSpacing: 0,
                        color: isDark ? accentBlue : const Color(0xFF0060BD),
                      ),
                    ),
                  ],
                ),
              ),
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
                      onTap: _isSubmitting ? null : _submitPoll,
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
                                'Create Poll',
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
