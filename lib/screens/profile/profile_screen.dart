import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/providers/profile/profile_provider.dart';
import 'package:flutter_nivasshub/widgets/profile/profile_tile.dart';
import 'package:flutter_nivasshub/models/profile/profile_model.dart';
import 'package:flutter_nivasshub/screens/profile/add_address_details_screen.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color bgLightBlue = Color(0xFFF4F7FC);

  void _showEditDialog(
    BuildContext context,
    String title,
    String initialValue,
    Function(String) onSave,
  ) {
    final controller = TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter $title',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onSave(controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final profile = profileProvider.profile;

    return Scaffold(
      backgroundColor: bgLightBlue,
      appBar: AppBar(
        backgroundColor: bgLightBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Create Your Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Card
            _buildProfileHeaderCard(profile),
            const SizedBox(height: 16),

            // Enter your details section
            _buildSectionHeader('Enter your details'),
            const SizedBox(height: 10),

            // Enable calls toggle
            _buildEnableCallsRow(profile, profileProvider),
            const SizedBox(height: 10),

            // User Name
            ProfileTile(
              icon: Icons.person_outline,
              title: 'User Name',
              subtitle: profile.userName,
              tags: profile.tags,
              onTap: () {
                _showEditDialog(context, 'User Name', profile.userName, (val) {
                  profileProvider.updateUserName(val);
                });
              },
            ),
            const SizedBox(height: 8),

            // Add Bio
            ProfileTile(
              icon: Icons.description_outlined,
              title: 'Add bio',
              subtitle: profile.bio.isEmpty
                  ? 'Tell your neighbors about yourself'
                  : profile.bio,
              onTap: () {
                _showEditDialog(context, 'Bio', profile.bio, (val) {
                  profileProvider.updateBio(val);
                });
              },
            ),
            const SizedBox(height: 8),

            // Add Work
            ProfileTile(
              icon: Icons.work_outline,
              title: 'Add Work',
              subtitle: profile.work.isEmpty
                  ? 'Where do you work?'
                  : profile.work,
              onTap: () {
                _showEditDialog(context, 'Work', profile.work, (val) {
                  profileProvider.updateWork(val);
                });
              },
            ),
            const SizedBox(height: 8),

            // Add Address
            ProfileTile(
              icon: Icons.location_on_outlined,
              title: profile.address.flatNo.isNotEmpty
                  ? 'Edit Address'
                  : 'Add Address',
              subtitle: profile.address.flatNo.isNotEmpty
                  ? '${profile.address.flatNo}, ${profile.address.societyName}'
                  : 'Add Address details',
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddAddressDetailsScreen(
        address: profile.address,
      ),
    ),
  );
},
            ),
            const SizedBox(height: 16),

            // Interests Section - Pass context explicitly
            _buildInterestsSection(context, profile, profileProvider),
            const SizedBox(height: 16),

            // Stats Row (Hug count)
            _buildStatsRow(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: profileProvider.isLoading
                    ? null
                    : () async {
                        await profileProvider.saveProfileData();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile saved successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                child: profileProvider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.maybePop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- PROFILE HEADER CARD ---
  Widget _buildProfileHeaderCard(ProfileModel profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.amber.shade700,
                child: Text(
                  profile.userName.isNotEmpty
                      ? profile.userName[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            profile.userName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Nivaas Hub Member',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: bgLightBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: primaryBlue,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Profile Complete 60%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- SECTION HEADER ---
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // --- ENABLE CALLS ROW ---
  Widget _buildEnableCallsRow(ProfileModel profile, ProfileProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F7FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.phone_outlined,
                  color: primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Enable calls',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Switch(
            value: profile.enableCalls,
            onChanged: (val) => provider.toggleEnableCalls(val),
            activeThumbColor: Colors.green,
            activeTrackColor: Colors.green.shade100,
          ),
        ],
      ),
    );
  }

  // --- INTERESTS SECTION ---
  // ✅ FIXED: Pass context as parameter
  Widget _buildInterestsSection(
    BuildContext context, 
    ProfileModel profile, 
    ProfileProvider provider
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interests',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Share what you love with your community',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),

          if (profile.interests.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.interests.map((item) {
                return Chip(
                  label: Text(item),
                  backgroundColor: const Color(0xFFEFF6FF),
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  labelStyle: const TextStyle(
                    fontSize: 12,
                    color: primaryBlue,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
          ],

          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
              side: const BorderSide(color: Colors.orange),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              // ✅ FIXED: Now using the context parameter passed in
              _showEditDialog(context, 'Interest', '', (val) {
                provider.addInterest(val);
              });
            },
            icon: const Icon(
              Icons.add,
              color: Colors.orange,
              size: 18,
            ),
            label: const Text(
              'Add Interests',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- STATS ROW ---
  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_outline,
            color: Colors.pink,
            size: 20,
          ),
          const SizedBox(width: 6),
          Text(
            '400 Hug',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 1,
            height: 20,
            color: Colors.grey.shade300,
          ),
          const SizedBox(width: 20),
          const Icon(
            Icons.emoji_events_outlined,
            color: Colors.amber,
            size: 20,
          ),
          const SizedBox(width: 6),
          Text(
            '49 Hug ×',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}