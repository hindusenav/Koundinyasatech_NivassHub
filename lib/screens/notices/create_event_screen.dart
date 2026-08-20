import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/providers/notices/notices_provider.dart';
import 'package:flutter_nivasshub/widgets/notices/user_bar.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC7E3FF),
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text(
          'New Event',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        actions: [
          // right-action (Flow: Horizontal, Width Hug 100px, Height Hug 28px, Radius 100px, Padding 10px/6px, Gap 4px, Color #E8F4FF 68%)
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FF).withValues(alpha: 0.68),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // info icon (14px x 14px, Color #0060BD)
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color: Color(0xFF0060BD),
                      ),
                      SizedBox(width: 4), // Gap: 4px
                      // Text Guidelines Button (DM Sans 12px SemiBold 600, Color #0060BD)
                      Text(
                        'Guidelines',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          color: Color(0xFF0060BD),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                          letterSpacing: 0,
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
            UserBar(selectedVisibility: _selectedVisibility),
            // scheduler-form (Padding: Horizontal 20px, Gap: 20px)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text Event details (DM Sans 14px Regular 400, Height 100%, Color #3E3E3E)
                  TextField(
                    controller: _detailsController,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF3E3E3E),
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Add details about your event...',
                      hintStyle: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF3E3E3E),
                        height: 1.0,
                        letterSpacing: 0,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 20), // scheduler-form Gap: 20px

                  // date-venue-cards (Gap: 12px)
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
                  const SizedBox(height: 12), // date-venue-cards Gap: 12px
                  _EventConfigTile(
                    icon: Icons.location_on_outlined,
                    title: 'Add Location',
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
      bottomNavigationBar: SafeArea(
        child: Container(
          // toolbar (Flow: Horizontal, Width Fixed 440px, Height Hug 61px, Border Top 1px #E2E8F0, Padding 20px/12px)
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: Row(
            children: [
              // attachments (Gap: 16px)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MediaIconButton(icon: Icons.image_outlined, onTap: () {}),
                  const SizedBox(width: 16),
                  _MediaIconButton(icon: Icons.camera_alt_outlined, onTap: () {}),
                  const SizedBox(width: 16),
                  _MediaIconButton(icon: Icons.videocam_outlined, onTap: () {}),
                  const SizedBox(width: 16),
                  _MediaIconButton(icon: Icons.mic_none_outlined, onTap: () {}),
                ],
              ),
              const Spacer(),
              // post-btn (Flow: Horizontal, Width Hug 132px, Height Hug 37px, Radius 8px, Padding 20px/10px, Color #0060BD)
              Material(
                color: const Color(0xFF0060BD), // Blue 1 #0060BD
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
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              height: 1.0,
                              letterSpacing: 0,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// tool-icon (Flow: Horizontal, Width Hug 36px, Height Hug 36px, Radius 8px, Padding 8px, Color #E8F4FF, Shadow 4px 4px 4px #000000 15%)
class _MediaIconButton extends StatelessWidget {
  const _MediaIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F4FF), // Blue 4 #E8F4FF
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000), // #000000 15%
              blurRadius: 4,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF0284C7), size: 20), // 20px x 20px
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16), // scheduler-card Padding: 16px
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC), // scheduler-card Color: #F8FAFC
          borderRadius: BorderRadius.circular(12), // Radius: 12px
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1), // Border: 1px #E2E8F0
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .0314), // Drop shadow 3.14%
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // icon-container (38px x 38px, Radius 10px, Padding 10px, Color #F0FDFA)
            Container(
              width: 38,
              height: 38,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDFA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF0284C7), size: 18), // calendar size: 18px
            ),
            const SizedBox(width: 14), // Gap: 14px
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text Date & Time (DM Sans 14px SemiBold 600, Color #05234D)
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF05234D),
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 2), // card-text Gap: 2px
                  // Text Date & Time description (DM Sans 12px Regular 400, Color #3E3E3E)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xFF3E3E3E),
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
            // chevron-right (16px x 16px)
            const Icon(Icons.chevron_right, color: Color(0xFF64748B), size: 16),
          ],
        ),
      ),
    );
  }
}
