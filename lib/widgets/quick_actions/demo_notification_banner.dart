import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_radius.dart';
import 'package:flutter_nivasshub/constants/app_shadows.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';

/// Shows a brief in-app banner styled like a system notification, so "Test
/// Notifications" demonstrates real, visible behavior honestly — no
/// `flutter_local_notifications` dependency exists in this app, so this is
/// never presented as an actual OS push.
class DemoNotificationBanner {
  DemoNotificationBanner._();

  static void show(
    BuildContext context, {
    String title = 'NivasHub',
    String message = 'Visitor Ramesh Kumar is at the gate.',
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _DemoNotificationBannerContent(
        title: title,
        message: message,
        onDismiss: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }
}

class _DemoNotificationBannerContent extends StatefulWidget {
  const _DemoNotificationBannerContent({
    required this.title,
    required this.message,
    required this.onDismiss,
  });

  final String title;
  final String message;
  final VoidCallback onDismiss;

  @override
  State<_DemoNotificationBannerContent> createState() =>
      _DemoNotificationBannerContentState();
}

class _DemoNotificationBannerContentState
    extends State<_DemoNotificationBannerContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _offset = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
    Future.delayed(const Duration(seconds: 3), _dismiss);
  }

  Future<void> _dismiss() async {
    if (_dismissed || !mounted) return;
    _dismissed = true;
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: SlideTransition(
          position: _offset,
          child: GestureDetector(
            onTap: _dismiss,
            child: Padding(
              padding: AppSpacing.all(AppSpacing.sm),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: AppSpacing.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    borderRadius: AppRadius.radiusMd,
                    boxShadow: isDark ? AppShadows.darkMd : AppShadows.lg,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: AppDimensions.avatarSm,
                        height: AppDimensions.avatarSm,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.notifications,
                          color: AppColors.white,
                          size: AppDimensions.iconSm,
                        ),
                      ),
                      AppSpacing.gapWMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(widget.title, style: AppTextStyles.titleSmall),
                            Text(
                              widget.message,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isDark ? AppColors.grey300 : AppColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
