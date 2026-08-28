import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/providers/profile/profile_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/screens/profile/add_address_details_screen.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  File? _profileImage;
  File? _coverImage;

  // ============================================================
  // COLORS
  // ============================================================

  static const Color _primaryBlue = Color(0xFF2167A5);

  static const Color _lightBlue = Color(0xFFEAF3FB);

  // Updated to match Figma blue header
  static const Color _headerBlue = Color(0xFFC4D9EE);

  static const Color _background = Color(0xFFF4F7FB);

  static const Color _orange = Color(0xFFE88700);

  static const Color _textDark = Color(0xFF263747);

  static const Color _textGrey = Color(0xFF6F7C89);

  // ============================================================
  // IMAGE PICKER
  // ============================================================

  Future<void> _pickProfileImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1200,
    );

    if (pickedFile == null) return;

    setState(() {
      _profileImage = File(pickedFile.path);
    });
  }

  Future<void> _pickCoverImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1600,
    );

    if (pickedFile == null) return;

    setState(() {
      _coverImage = File(pickedFile.path);
    });
  }

  // ============================================================
  // IMAGE SOURCE BOTTOM SHEET
  // ============================================================

  void _showImagePicker({
    required bool isProfile,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                Text(
                  isProfile
                      ? 'Update Profile Photo'
                      : 'Update Cover Photo',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),

                const SizedBox(height: 12),

                ListTile(
                  leading: _bottomSheetIcon(
                    Icons.camera_alt_outlined,
                  ),
                  title: const Text(
                    'Take a picture',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);

                    if (isProfile) {
                      await _pickProfileImage(ImageSource.camera);
                    } else {
                      await _pickCoverImage(ImageSource.camera);
                    }
                  },
                ),

                ListTile(
                  leading: _bottomSheetIcon(
                    Icons.photo_library_outlined,
                  ),
                  title: const Text(
                    'Choose from gallery',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);

                    if (isProfile) {
                      await _pickProfileImage(ImageSource.gallery);
                    } else {
                      await _pickCoverImage(ImageSource.gallery);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _bottomSheetIcon(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: _lightBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: _primaryBlue,
        size: 22,
      ),
    );
  }

  // ============================================================
  // USER NAME
  // ============================================================

  void _editUserName() {
    final provider = context.read<ProfileProvider>();

    final controller = TextEditingController(
      text: provider.profile.userName,
    );

    _showEditDialog(
      title: 'Edit User Name',
      controller: controller,
      hint: 'Enter your name',
      onSave: () {
        final name = controller.text.trim();

        if (name.isNotEmpty) {
          provider.updateUserName(name);
        }
      },
    );
  }

  // ============================================================
  // BIO
  // ============================================================

  void _editBio() {
    final provider = context.read<ProfileProvider>();

    final controller = TextEditingController(
      text: provider.profile.bio,
    );

    _showEditDialog(
      title: 'Add bio',
      controller: controller,
      hint: 'Tell your neighbors about yourself',
      maxLines: 4,
      onSave: () {
        provider.updateBio(controller.text.trim());
      },
    );
  }

  // ============================================================
  // WORK
  // ============================================================

  void _editWork() {
    final provider = context.read<ProfileProvider>();

    final controller = TextEditingController(
      text: provider.profile.work,
    );

    _showEditDialog(
      title: 'Add Work',
      controller: controller,
      hint: 'Where do you work?',
      onSave: () {
        provider.updateWork(controller.text.trim());
      },
    );
  }

  // ============================================================
  // INTEREST
  // ============================================================

  void _addInterest() {
    final provider = context.read<ProfileProvider>();

    final controller = TextEditingController();

    _showEditDialog(
      title: 'Add Interest',
      controller: controller,
      hint: 'Enter your interest',
      onSave: () {
        final interest = controller.text.trim();

        if (interest.isNotEmpty) {
          provider.addInterest(interest);
        }
      },
    );
  }

  // ============================================================
  // COMMON EDIT DIALOG
  // ============================================================

  void _showEditDialog({
    required String title,
    required TextEditingController controller,
    required String hint,
    required VoidCallback onSave,
    int maxLines = 1,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: controller,
            maxLines: maxLines,
            autofocus: true,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryBlue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                onSave();
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // SETTINGS NAVIGATION
  // ============================================================

  void _openSettings() {
    Navigator.pushNamed(
      context,
      '/settings',
    );
  }

  // ============================================================
  // ADD ADDRESS NAVIGATION
  // ============================================================
void _openAddress() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AddAddressDetailsScreen(),
    ),
  );
}

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  Future<void> _saveProfile() async {
    final provider = context.read<ProfileProvider>();

    await provider.saveProfileData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved successfully'),
      ),
    );
  }

  // ============================================================
  // CANCEL
  // ============================================================

  void _cancel() {
    Navigator.pop(context);
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final horizontalPadding = screenWidth < 360 ? 14.0 : 20.0;

    return Scaffold(
      backgroundColor: _background,

      // IMPORTANT:
      // No outer SafeArea because header handles status bar padding.
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // ==================================================
              // HEADER
              // ==================================================

              _buildHeader(),

              // ==================================================
              // SCROLLABLE CONTENT
              // ==================================================

              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),

                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    14,
                    horizontalPadding,
                    8,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ============================================
                      // COVER + PROFILE IMAGE
                      // ============================================

                      _buildCoverSection(),

                      const SizedBox(height: 24),

                      // ============================================
                      // DETAILS HEADER
                      // ============================================

                      _buildDetailsHeader(provider),

                      const SizedBox(height: 9),

                      // ============================================
                      // USER NAME
                      // ============================================

                      _buildUserNameCard(provider),

                      const SizedBox(height: 8),

                      // ============================================
                      // BIO
                      // ============================================

                      _buildDetailCard(
                        assetPath:
                            'assets/icons/profile/addbio.png',
                        title: 'Add bio',
                        subtitle: provider.profile.bio.isEmpty
                            ? 'Tell your neighbors about yourself'
                            : provider.profile.bio,
                        onTap: _editBio,
                      ),

                      const SizedBox(height: 8),

                      // ============================================
                      // WORK
                      // ============================================

                      _buildDetailCard(
                        assetPath:
                            'assets/icons/profile/briefcase.png',
                        title: 'Add Work',
                        subtitle: provider.profile.work.isEmpty
                            ? 'Where do you work?'
                            : provider.profile.work,
                        onTap: _editWork,
                      ),

                      const SizedBox(height: 8),

                      // ============================================
                      // ADDRESS
                      // ============================================

                      _buildDetailCard(
                        assetPath:
                            'assets/icons/profile/address(profile).png',
                        title: 'Add Address',
                        subtitle: 'Add Address details',
                        onTap: _openAddress,
                      ),

                      const SizedBox(height: 10),

                      // ============================================
                      // INTERESTS
                      // ============================================

                      _buildInterestCard(provider),

                      // Reduced unnecessary bottom space
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              // ==================================================
              // BOTTOM BUTTONS
              // ==================================================

              _buildBottomButtons(provider),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,

      // Status bar + header
      height: topPadding + 66,

      padding: EdgeInsets.only(
        top: topPadding,
      ),

      color: _headerBlue,

      child: Row(
        children: [
          const SizedBox(width: 12),

          // BACK
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: _textDark,
              size: 21,
            ),
          ),

          const SizedBox(width: 6),

          // TITLE
          const Text(
            'Create Your Profile',
            style: TextStyle(
              color: _textDark,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          // SETTINGS
          IconButton(
            onPressed: _openSettings,
            icon: const Icon(
              Icons.settings_outlined,
              color: _textDark,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),
        ],
      ),
    );
  }

  // ============================================================
  // COVER SECTION
  // ============================================================

  Widget _buildCoverSection() {
    return SizedBox(
      height: 122,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // COVER
          GestureDetector(
            onTap: () {
              _showImagePicker(isProfile: false);
            },
            child: Container(
              height: 82,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFD5DCE5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
                image: _coverImage != null
                    ? DecorationImage(
                        image: FileImage(_coverImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _coverImage == null
                  ? CustomPaint(
                      painter: _CoverPainter(),
                      child: const SizedBox.expand(),
                    )
                  : null,
            ),
          ),

          // COVER EDIT BUTTON
          Positioned(
            top: 9,
            right: 10,
            child: GestureDetector(
              onTap: () {
                _showImagePicker(isProfile: false);
              },
              child: Container(
                width: 29,
                height: 29,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 14,
                  color: _textGrey,
                ),
              ),
            ),
          ),

          // PROFILE IMAGE
          Positioned(
            top: 48,
            child: GestureDetector(
              onTap: () {
                _showImagePicker(isProfile: true);
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFFBF3),
                      border: Border.all(
                        color: const Color(0xFFD7D0C4),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.16),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      image: _profileImage != null
                          ? DecorationImage(
                              image: FileImage(_profileImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _profileImage == null
                        ? const Icon(
                            Icons.person_outline_rounded,
                            color: _orange,
                            size: 29,
                          )
                        : null,
                  ),

                  // CAMERA
                  Positioned(
                    right: -3,
                    bottom: 4,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: _orange,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DETAILS HEADER
  // ============================================================

  Widget _buildDetailsHeader(ProfileProvider provider) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Enter your details',
            style: TextStyle(
              color: _textDark,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        Container(
          height: 30,
          padding: const EdgeInsets.only(
            left: 10,
            right: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 7,
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 11,
                color: _textGrey,
              ),

              const SizedBox(width: 5),

              const Text(
                'Enable calls',
                style: TextStyle(
                  fontSize: 9,
                  color: _textGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(width: 5),

              Transform.scale(
                scale: 0.72,
                child: Switch(
                  value: provider.profile.enableCalls,
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color(0xFF2E9656),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey.shade300,
                  onChanged: provider.toggleEnableCalls,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // USER NAME CARD
  // ============================================================

  Widget _buildUserNameCard(ProfileProvider provider) {
    return GestureDetector(
      onTap: _editUserName,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          14,
          12,
          12,
          10,
        ),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    provider.profile.userName.isEmpty
                        ? 'User Name'
                        : provider.profile.userName,
                    style: const TextStyle(
                      color: _textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const Icon(
                  Icons.chevron_right,
                  size: 19,
                  color: _textDark,
                ),
              ],
            ),

            const SizedBox(height: 7),

            Row(
              children: [
                _buildTag(
                  imagePath:
                      'assets/icons/profile/block.png',
                  text: provider.profile.tags.isNotEmpty
                      ? provider.profile.tags[0]
                      : 'B-402',
                ),

                const SizedBox(width: 7),

                _buildTag(
                  imagePath:
                      'assets/icons/profile/house.png',
                  text: provider.profile.tags.length > 1
                      ? provider.profile.tags[1]
                      : 'Tenant',
                ),
              ],
            ),

            const SizedBox(height: 8),

            Container(
              height: 1,
              color: const Color(0xFFE2E7ED),
            ),

            const SizedBox(height: 6),

            Text(
              provider.profile.userName.isEmpty
                  ? 'User Name'
                  : provider.profile.userName,
              style: const TextStyle(
                color: _textGrey,
                fontSize: 9,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TAG
  // ============================================================

  Widget _buildTag({
    required String imagePath,
    required String text,
  }) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
      ),
      decoration: BoxDecoration(
        color: _lightBlue,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: 12,
            height: 12,
            fit: BoxFit.contain,
          ),

          const SizedBox(width: 4),

          Text(
            text,
            style: const TextStyle(
              color: _primaryBlue,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DETAIL CARD
  // ============================================================

  Widget _buildDetailCard({
    required String assetPath,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,

        // Compact size closer to Figma
        height: 68,

        padding: const EdgeInsets.symmetric(
          horizontal: 13,
        ),

        decoration: _cardDecoration(),

        child: Row(
          children: [
            // ICON
            Container(
              width: 44,
              height: 44,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: _lightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),

            const SizedBox(width: 12),

            // TEXT
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _textDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _textGrey,
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),

            const Icon(
              Icons.chevron_right,
              color: _textDark,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INTEREST CARD
  // ============================================================

  Widget _buildInterestCard(ProfileProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        12,
        12,
        12,
        12,
      ),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interests',
            style: TextStyle(
              color: _textDark,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Share what you love with your community',
            style: TextStyle(
              color: _textGrey,
              fontSize: 9,
            ),
          ),

          const SizedBox(height: 10),

          if (provider.profile.interests.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: provider.profile.interests
                  .map(
                    (interest) => Chip(
                      label: Text(
                        interest,
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      backgroundColor: _lightBlue,
                      side: BorderSide.none,
                    ),
                  )
                  .toList(),
            ),

          if (provider.profile.interests.isNotEmpty)
            const SizedBox(height: 8),

          GestureDetector(
            onTap: _addInterest,
            child: CustomPaint(
              painter: _DashedBorderPainter(
                color: _orange,
                radius: 8,
              ),
              child: Container(
                width: double.infinity,
                height: 48,
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: _orange,
                      size: 17,
                    ),

                    SizedBox(width: 5),

                    Text(
                      'Add Interests',
                      style: TextStyle(
                        color: _orange,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM BUTTONS
  // ============================================================

  Widget _buildBottomButtons(ProfileProvider provider) {
    return Container(
      color: _background,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            10,
          ),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: provider.isLoading
                        ? null
                        : _saveProfile,
                    icon: provider.isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.save_outlined,
                            size: 16,
                          ),
                    label: Text(
                      provider.isLoading
                          ? 'Saving...'
                          : 'Save',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: _cancel,
                    icon: const Icon(
                      Icons.close,
                      size: 16,
                    ),
                    label: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
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

  // ============================================================
  // CARD DECORATION
  // ============================================================

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}

// ============================================================
// COVER BACKGROUND PAINTER
// ============================================================

class _CoverPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD5E2F0)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path1 = Path()
      ..moveTo(0, size.height * 0.65)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.35,
        size.width * 0.52,
        size.height * 0.62,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.85,
        size.width,
        size.height * 0.55,
      );

    canvas.drawPath(path1, paint);

    final path2 = Path()
      ..moveTo(0, size.height * 0.35)
      ..quadraticBezierTo(
        size.width * 0.30,
        size.height * 0.05,
        size.width * 0.58,
        size.height * 0.38,
      )
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.55,
        size.width,
        size.height * 0.28,
      );

    canvas.drawPath(path2, paint);

    final dotPaint = Paint()
      ..color = const Color(0xFFD3E2F0)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.14, size.height * 0.22),
      3,
      dotPaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.72, size.height * 0.45),
      2.5,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================
// DASHED BORDER PAINTER
// ============================================================

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedBorderPainter({
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 4.0;

    final rect = Rect.fromLTWH(
      0.5,
      0.5,
      size.width - 1,
      size.height - 1,
    );

    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(
            distance,
            distance + dashWidth,
          ),
          paint,
        );

        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(
    covariant _DashedBorderPainter oldDelegate,
  ) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius;
  }
}