import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/widgets/shared/glass/glass_widgets.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.isPropertyPanelExpanded,
    required this.onTogglePropertyPanel,
  });

  /// Kept for call-site compatibility: the flat selector (which toggles the
  /// property panel) now lives in the resident card below the header.
  final bool isPropertyPanelExpanded;
  final VoidCallback onTogglePropertyPanel;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final user = provider.home?.data.user;
    const textColor = Colors.white;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AmberGradientBar.overlayStyle,
      child: AmberGradientBar(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: SafeArea(
          top: true,
          left: false,
          right: false,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              bottom: 26,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Hello,',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: textColor.withValues(alpha: 0.9),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user?.name ?? 'User name',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                _CircleIconButton(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.search),
                  child: Image.asset(
                    'assets/icons/search.png',
                    width: 20,
                    height: 20,
                    color: textColor,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _CircleIconButton(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                  child: Image.asset(
                    'assets/icons/chat.png',
                    width: 20,
                    height: 20,
                    color: textColor,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 20,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                  child: Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.orange,
                    ),
                    child: const Text(
                      'A',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1,
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
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.18),
        ),
        child: child,
      ),
    );
  }
}
