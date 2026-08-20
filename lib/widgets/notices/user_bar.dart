import 'package:flutter/material.dart';

/// user-bar component matching Figma Dev Mode Specs for creation screens:
/// - user-bar: Flow Horizontal, Justify space-between, Padding: Top 16px, Right 20px, Bottom 16px, Left 20px.
/// - user-profile: Flow Horizontal, Width Hug (150px), Height Hug (40px), Gap 12px.
/// - avatar: Fixed 40x40, Radius 20px, Color Yellow 1 (#EC9211).
/// - user-info: Flow Vertical, Width Hug (98px), Height Hug (38px), Gap 2px.
/// - User name: DM Sans 15px SemiBold (600), Line height 100%, Letter spacing 0%, Color #0F172A.
/// - User Details: DM Sans 12px Medium (500), Line height 100%, Letter spacing 0%, Color #05234D.
/// - audience-selector: Flow Horizontal, Radius 8px, Border 1px (#E2E8F0), Padding: Horizontal 12px, Vertical 8px, Gap 6px, Color #FFFFFF.
/// - Audience Text: DM Sans 13px Medium (500), Line height 100%, Letter spacing 0%, Color #475569.
class UserBar extends StatelessWidget {
  const UserBar({
    super.key,
    this.userName = 'User Name',
    this.userDetails = 'Apartment B 402',
    this.selectedVisibility = 'All Residents',
    this.onVisibilityTap,
  });

  final String userName;
  final String userDetails;
  final String selectedVisibility;
  final VoidCallback? onVisibilityTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        right: 20,
        bottom: 16,
        left: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // user-profile (Flow: Horizontal, Width: Hug 150px, Height: Hug 40px, Gap: 12px)
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // avatar (Fixed 40x40px, Radius: 20px, Color: #EC9211)
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFEC9211), // Yellow 1 #EC9211
                child: Text(
                  'A',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12), // Gap: 12px

              // user-info (Flow: Vertical, Width: Hug 98px, Height: Hug 38px, Gap: 2px)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User name (DM Sans 15px SemiBold 600, Height 100%, Color #0F172A)
                  Text(
                    userName,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 2), // Gap: 2px

                  // User Details (DM Sans 12px Medium 500, Height 100%, Color #05234D)
                  Text(
                    userDetails,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF05234D),
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // audience-selector (Flow: Horizontal, Radius 8px, Border 1px #E2E8F0, Padding 12px/8px, Gap 6px, Color #FFFFFF)
          GestureDetector(
            onTap: onVisibilityTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Audience text (DM Sans 13px Medium 500, Height 100%, Color #475569)
                  Text(
                    selectedVisibility,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF475569),
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(width: 6), // Gap: 6px
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: Color(0xFF475569),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
