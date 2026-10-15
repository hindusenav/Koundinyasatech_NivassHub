import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';

/// Reusable dark navy header with curved bottom corners matching
/// the new Select Country, Select City, and Complete Your Profile designs.
class AuthCurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthCurvedAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.showBackButton = true,
    this.bottomCurveRadius = 24.0,
    this.actions,
  });

  final String title;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final double bottomCurveRadius;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(64.0);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AuthColors.blueNh,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(bottomCurveRadius),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F000000),
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: 64.0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (showBackButton)
                  Positioned(
                    left: 8,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 56),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (actions != null)
                  Positioned(
                    right: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions!,
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
