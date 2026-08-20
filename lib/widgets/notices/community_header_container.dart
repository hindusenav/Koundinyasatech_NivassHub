import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Header Container component matching Figma Dev Mode Specs & visual reference:
/// - Header Container: Flow Horizontal, Height Hug (66px), Justify space-between,
///   Padding: Top 12px, Right 20px, Bottom 16px, Left 20px, Background Color #C7E3FF (Blue 3).
/// - Navigation: Flow Horizontal, Width Fill (400px), Height Hug (38px), Gap 12px.
/// - Back Button: Navigation action arrow (←) on the left, Color #000000.
/// - Greeting Container: Flow Horizontal, Width Fixed (352px), Height Fixed (38px), Radius 40px, Border 1px (#CCDFF2),
///   Padding: Left 16px, Right 12px, Gap 10px. Contains "Community Posts" text + notification bell inside the pill.
/// - Greeting Text: DM Sans 18px SemiBold (600), Line height 100%, Letter spacing 0%, Color #000000.
class CommunityHeaderContainer extends StatelessWidget implements PreferredSizeWidget {
  const CommunityHeaderContainer({
    super.key,
    this.title = 'Community Posts',
    this.onBackPressed,
    this.onNotificationPressed,
  });

  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onNotificationPressed;

  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFC7E3FF),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          left: false,
          right: false,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              right: 20,
              bottom: 16,
              left: 20,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back Button (←) (Width: 24px, Height: 24px)
                GestureDetector(
                  onTap: onBackPressed ?? () => Navigator.of(context).pop(),
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox(
                    width: 24,
                    height: 24,
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        color: Color(0xFF000000),
                        size: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12), // Gap: 12px

                // Greeting Container (Pill container enclosing text and bell icon)
                // Flow: Horizontal, Height: Fixed (38px), Radius: 40px, Border: 1px (#CCDFF2), Padding: Left 16px, Right 12px, Gap: 10px
                Expanded(
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC7E3FF),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: const Color(0xFFCCDFF2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Greeting Text ("Community Posts" - DM Sans 18px SemiBold 600, Color #000000)
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'DM Sans',
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              height: 1.0,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10), // Gap: 10px

                        // Notification bell icon inside Greeting Container (Width: 24px, Height: 24px)
                        GestureDetector(
                          onTap: onNotificationPressed ?? () {},
                          behavior: HitTestBehavior.opaque,
                          child: const SizedBox(
                            width: 24,
                            height: 24,
                            child: Center(
                              child: Icon(
                                Icons.notifications_none_outlined,
                                color: Color(0xFF000000),
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}
