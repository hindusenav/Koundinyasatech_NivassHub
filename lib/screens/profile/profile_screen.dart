import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/providers/profile/profile_provider.dart';
import 'package:flutter_nivasshub/models/profile/profile_model.dart';
import 'package:flutter_nivasshub/screens/profile/add_address_details_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryBlue = Color(0xFF006FC9);
  static const Color backgroundBlue = Color(0xFFF2F7FD);
  static const Color headerBlue = Color(0xFFD8ECFF);
  static const Color iconBackground = Color(0xFFEAF4FF);
  static const Color orange = Color(0xFFFF9800);

  // ============================================================
  // EDIT DIALOG
  // ============================================================

  void _showEditDialog(
    BuildContext context,
    String title,
    String initialValue,
    Function(String) onSave,
  ) {
    final controller = TextEditingController(
      text: initialValue,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Edit $title',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter $title',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                final value = controller.text.trim();

                if (value.isNotEmpty) {
                  onSave(value);
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // MAIN SCREEN
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final profile = profileProvider.profile;

    return Scaffold(
      backgroundColor: backgroundBlue,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: headerBlue,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,

        toolbarHeight: 48,

        leadingWidth: 45,

        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
            size: 21,
          ),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),

        centerTitle: true,

        title: const Text(
          'Create Your Profile',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 45,
            ),
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.black87,
              size: 20,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.settings,
              );
            },
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(
            12,
            12,
            12,
            5,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // PROFILE HEADER
              // ==================================================

              _buildProfileHeader(profile),

              const SizedBox(height: 28),

              // ==================================================
              // ENTER YOUR DETAILS
              // ==================================================

              const Text(
                'Enter your details',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 9),

              // ==================================================
              // ENABLE CALLS
              // ==================================================

              _buildEnableCalls(
                profile,
                profileProvider,
              ),

              const SizedBox(height: 9),

              // ==================================================
              // USER NAME
              // ==================================================

              _buildDetailCard(
                icon: Icons.person_outline,
                title: 'User Name',
                subtitle: profile.userName.isEmpty
                    ? 'User Name'
                    : profile.userName,
                tags: profile.tags,
                onTap: () {
                  _showEditDialog(
                    context,
                    'User Name',
                    profile.userName,
                    (value) {
                      profileProvider.updateUserName(
                        value,
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 9),

              // ==================================================
              // BIO
              // ==================================================

              _buildDetailCard(
                icon: Icons.description_outlined,
                title: 'Add bio',
                subtitle: profile.bio.isEmpty
                    ? 'Tell your neighbors about yourself'
                    : profile.bio,
                onTap: () {
                  _showEditDialog(
                    context,
                    'Bio',
                    profile.bio,
                    (value) {
                      profileProvider.updateBio(
                        value,
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 9),

              // ==================================================
              // WORK
              // ==================================================

              _buildDetailCard(
                icon: Icons.work_outline,
                title: 'Add Work',
                subtitle: profile.work.isEmpty
                    ? 'Where do you work?'
                    : profile.work,
                onTap: () {
                  _showEditDialog(
                    context,
                    'Work',
                    profile.work,
                    (value) {
                      profileProvider.updateWork(
                        value,
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 9),

              // ==================================================
              // ADDRESS
              // ==================================================

              _buildDetailCard(
                icon: Icons.location_on_outlined,
                title: profile.address.flatNo.isNotEmpty
                    ? 'Edit Address'
                    : 'Add Address',
                subtitle: profile.address.flatNo.isNotEmpty
                    ? '${profile.address.flatNo}, '
                        '${profile.address.societyName}'
                    : 'Add Address details',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddAddressDetailsScreen(
                        address: profile.address,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              // ==================================================
              // INTERESTS
              // ==================================================

              _buildInterests(
                context,
                profile,
                profileProvider,
              ),
            ],
          ),
        ),
      ),

      // ==========================================================
      // BOTTOM BUTTONS
      // ==========================================================

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: backgroundBlue,

          padding: const EdgeInsets.fromLTRB(
            12,
            8,
            12,
            8,
          ),

          child: SizedBox(
            height: 46,

            child: Row(
              children: [
                // =================================================
                // SAVE
                // =================================================

                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                    ),

                    onPressed:
                        profileProvider.isLoading
                            ? null
                            : () async {
                                await profileProvider
                                    .saveProfileData();

                                if (context.mounted) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Profile saved successfully!',
                                      ),
                                      backgroundColor:
                                          Colors.green,
                                    ),
                                  );
                                }
                              },

                    icon: profileProvider.isLoading
                        ? const SizedBox(
                            width: 15,
                            height: 15,
                            child:
                                CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.save_outlined,
                            size: 15,
                          ),

                    label: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // =================================================
                // CANCEL
                // =================================================

                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                    ),

                    onPressed: () {
                      Navigator.maybePop(context);
                    },

                    icon: const Icon(
                      Icons.close,
                      size: 15,
                    ),

                    label: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _buildProfileHeader(
    ProfileModel profile,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 105,

      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ======================================================
          // BANNER
          // ======================================================

          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 84,

            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFD4DEE9),
                  width: 0.8,
                ),
              ),

              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(12),

                child: CustomPaint(
                  painter: _ProfileBannerPainter(),
                ),
              ),
            ),
          ),

          // ======================================================
          // EDIT BUTTON
          // ======================================================

          Positioned(
            top: 7,
            right: 7,

            child: Container(
              width: 27,
              height: 27,

              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 0.8,
                ),
              ),

              child: const Icon(
                Icons.edit_outlined,
                size: 14,
                color: Colors.grey,
              ),
            ),
          ),

          // ======================================================
          // AVATAR
          // ======================================================

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,

            child: Center(
              child: Stack(
                clipBehavior: Clip.none,

                children: [
                  Container(
                    width: 62,
                    height: 62,

                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFFFFBF2),
                      shape: BoxShape.circle,

                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 0.8,
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(
                            alpha: 0.08,
                          ),
                          blurRadius: 5,
                          offset:
                              const Offset(0, 2),
                        ),
                      ],
                    ),

                    child: const Icon(
                      Icons.person_outline,
                      color: orange,
                      size: 30,
                    ),
                  ),

                  // =================================================
                  // CAMERA BUTTON
                  // =================================================

                  Positioned(
                    right: -2,
                    bottom: 0,

                    child: Container(
                      width: 24,
                      height: 24,

                      decoration: BoxDecoration(
                        color: orange,
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),

                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 12,
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
  // ENABLE CALLS
  // ============================================================

  Widget _buildEnableCalls(
    ProfileModel profile,
    ProfileProvider provider,
  ) {
    return Align(
      alignment: Alignment.centerRight,

      child: Container(
        height: 34,

        padding: const EdgeInsets.only(
          left: 9,
          right: 3,
        ),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(8),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            const Icon(
              Icons.phone_outlined,
              size: 13,
              color: Colors.grey,
            ),

            const SizedBox(width: 5),

            const Text(
              'Enable calls',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),

            const SizedBox(width: 4),

            Transform.scale(
              scale: 0.72,

              child: Switch(
                value: profile.enableCalls,

                onChanged: (value) {
                  provider.toggleEnableCalls(
                    value,
                  );
                },

                activeThumbColor: Colors.white,
                activeTrackColor: Colors.green,

                inactiveThumbColor:
                    Colors.white,

                inactiveTrackColor:
                    Colors.grey.shade300,

                materialTapTargetSize:
                    MaterialTapTargetSize
                        .shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DETAIL CARD
  // ============================================================

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    List<String>? tags,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius:
            BorderRadius.circular(12),

        child: Container(
          width: double.infinity,

          // ====================================================
          // IMPORTANT CARD HEIGHT
          // ====================================================

          height: 78,

          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(12),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.045,
                ),
                blurRadius: 5,
                offset:
                    const Offset(0, 2),
              ),
            ],
          ),

          child: Row(
            children: [
              // =================================================
              // ICON
              // =================================================

              Container(
                width: 40,
                height: 40,

                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius:
                      BorderRadius.circular(9),
                ),

                child: Icon(
                  icon,
                  color: primaryBlue,
                  size: 21,
                ),
              ),

              const SizedBox(width: 12),

              // =================================================
              // CONTENT
              // =================================================

              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,

                      maxLines: 1,

                      overflow:
                          TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w600,
                        color:
                            Colors.black87,
                      ),
                    ),

                    // ==========================================
                    // TAGS
                    // ==========================================

                    if (tags != null &&
                        tags.isNotEmpty) ...[
                      const SizedBox(
                        height: 4,
                      ),

                      Row(
                        children:
                            tags.take(2).map(
                          (tag) {
                            return Container(
                              margin:
                                  const EdgeInsets
                                      .only(
                                right: 5,
                              ),

                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),

                              decoration:
                                  BoxDecoration(
                                color:
                                    iconBackground,

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  5,
                                ),
                              ),

                              child: Text(
                                tag,

                                style:
                                    const TextStyle(
                                  fontSize: 8,
                                  color:
                                      primaryBlue,
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ],

                    const SizedBox(height: 3),

                    Text(
                      subtitle,

                      maxLines: 1,

                      overflow:
                          TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 10,
                        color:
                            Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              // =================================================
              // ARROW
              // =================================================

              const Icon(
                Icons.chevron_right,
                color: Colors.black54,
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INTERESTS
  // ============================================================

  Widget _buildInterests(
    BuildContext context,
    ProfileModel profile,
    ProfileProvider provider,
  ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(
        14,
        13,
        14,
        13,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(12),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.045,
            ),
            blurRadius: 5,
            offset:
                const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            'Interests',

            style: TextStyle(
              fontSize: 13,
              fontWeight:
                  FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Share what you love with your community',

            style: TextStyle(
              fontSize: 10,
              color:
                  Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 10),

          // ======================================================
          // EXISTING INTERESTS
          // ======================================================

          if (profile.interests.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 5,

              children:
                  profile.interests.map(
                (interest) {
                  return Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          iconBackground,

                      borderRadius:
                          BorderRadius
                              .circular(6),
                    ),

                    child: Text(
                      interest,

                      style:
                          const TextStyle(
                        fontSize: 9,
                        color:
                            primaryBlue,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),

            const SizedBox(height: 9),
          ],

          // ======================================================
          // ADD INTERESTS
          // ======================================================

          SizedBox(
            height: 40,
            width: double.infinity,

            child: CustomPaint(
              painter:
                  _DashedBorderPainter(
                color: orange,
                radius: 7,
              ),

              child: TextButton.icon(
                onPressed: () {
                  _showEditDialog(
                    context,
                    'Interest',
                    '',
                    (value) {
                      provider.addInterest(
                        value,
                      );
                    },
                  );
                },

                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: orange,
                  tapTargetSize:
                      MaterialTapTargetSize
                          .shrinkWrap,
                ),

                icon: const Icon(
                  Icons.add,
                  color: orange,
                  size: 16,
                ),

                label: const Text(
                  'Add Interests',

                  style: TextStyle(
                    color: orange,
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PROFILE BANNER PAINTER
// ============================================================================

class _ProfileBannerPainter
    extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    // ==========================================================
    // LIGHT WAVE FILL
    // ==========================================================

    final fillPaint = Paint()
      ..color = const Color(0xFFF3F8FE)
      ..style = PaintingStyle.fill;

    final fillPath = Path();

    fillPath.moveTo(
      0,
      size.height * 0.60,
    );

    fillPath.cubicTo(
      size.width * 0.12,
      size.height * 0.20,
      size.width * 0.30,
      size.height * 0.95,
      size.width * 0.52,
      size.height * 0.58,
    );

    fillPath.cubicTo(
      size.width * 0.68,
      size.height * 0.30,
      size.width * 0.82,
      size.height * 0.80,
      size.width,
      size.height * 0.48,
    );

    fillPath.lineTo(
      size.width,
      size.height,
    );

    fillPath.lineTo(
      0,
      size.height,
    );

    fillPath.close();

    canvas.drawPath(
      fillPath,
      fillPaint,
    );

    // ==========================================================
    // WAVE OUTLINE
    // ==========================================================

    final linePaint = Paint()
      ..color = const Color(0xFFDCEBFA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;

    final linePath = Path();

    linePath.moveTo(
      0,
      size.height * 0.52,
    );

    linePath.cubicTo(
      size.width * 0.14,
      size.height * 0.10,
      size.width * 0.31,
      size.height * 0.82,
      size.width * 0.52,
      size.height * 0.52,
    );

    linePath.cubicTo(
      size.width * 0.68,
      size.height * 0.22,
      size.width * 0.83,
      size.height * 0.74,
      size.width,
      size.height * 0.40,
    );

    canvas.drawPath(
      linePath,
      linePaint,
    );

    // ==========================================================
    // DECORATIVE CIRCLES
    // ==========================================================

    final circlePaint = Paint()
      ..color = const Color(0xFFE4F0FC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    canvas.drawCircle(
      Offset(
        size.width * 0.12,
        size.height * 0.20,
      ),
      4,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.78,
        size.height * 0.56,
      ),
      2.5,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}

// ============================================================================
// DASHED BORDER PAINTER
// ============================================================================

class _DashedBorderPainter
    extends CustomPainter {
  final Color color;
  final double radius;

  _DashedBorderPainter({
    required this.color,
    required this.radius,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final path = Path();

    final rect =
        RRect.fromRectAndRadius(
      Rect.fromLTWH(
        0.5,
        0.5,
        size.width - 1,
        size.height - 1,
      ),
      Radius.circular(radius),
    );

    path.addRRect(rect);

    const double dashWidth = 4;
    const double dashSpace = 3;

    for (final metric
        in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final double end =
            distance + dashWidth;

        canvas.drawPath(
          metric.extractPath(
            distance,
            end > metric.length
                ? metric.length
                : end,
          ),
          paint,
        );

        distance +=
            dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}