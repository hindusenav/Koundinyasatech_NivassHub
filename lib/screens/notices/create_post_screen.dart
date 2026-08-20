import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/providers/notices/notices_provider.dart';
import 'package:flutter_nivasshub/widgets/notices/user_bar.dart';

/// Screen matching Figma "Community - New Posts"
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final String _selectedVisibility = 'All Residents';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    final text = _contentController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter post content.')),
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
        success = await provider.createPost(
          content: text,
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
          const SnackBar(content: Text('Post published successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage ?? 'Failed to publish post. Please try again.',
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
          'New Post',
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
            // editor-area (Padding: Top 8px, Right 20px, Bottom 8px, Left 20px, Gap 12px)
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                right: 20,
                bottom: 8,
                left: 20,
              ),
              child: TextField(
                controller: _contentController,
                maxLines: 8,
                style: const TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 16,
                  color: Color(0xFF3E3E3E),
                ),
                decoration: const InputDecoration(
                  hintText: 'What do you want to talk about?',
                  hintStyle: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 16,
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
                  onTap: _isSubmitting ? null : _submitPost,
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
                            'Post',
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
