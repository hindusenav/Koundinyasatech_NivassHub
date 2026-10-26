import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';

/// Page shell with the navy, curved-bottom header used by the Figma
/// "Complete Your Profile" / "KYC Verification" screens: back arrow, centred
/// title, soft-blue (dark in dark mode) body.
class FigmaHeaderScaffold extends StatelessWidget {
  const FigmaHeaderScaffold({
    super.key,
    required this.title,
    required this.body,
    this.showBackButton = true,
    this.onBackPressed,
    this.bottom,
  });

  final String title;
  final Widget body;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  /// Optional content under the title row, inside the bronze header (step
  /// indicator, subtitle badge, filter chips).
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    final canPop = showBackButton && Navigator.of(context).canPop();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: t.page,
        body: FigmaBackground(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.headerGradient,
                  ),
                  child: Stack(
                    children: [
                      // Soft lighter circle bleeding off the top-right corner.
                      Positioned(
                        right: -70,
                        bottom: -90,
                        child: IgnorePointer(
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white.withValues(alpha: 0.08),
                            ),
                          ),
                        ),
                      ),
                      SafeArea(
                        bottom: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 60,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 56,
                                    child: canPop
                                        ? IconButton(
                                            icon: const Icon(
                                              AppIcons.back,
                                              color: AppColors.white,
                                              size: 20,
                                            ),
                                            onPressed:
                                                onBackPressed ??
                                                () =>
                                                    Navigator.of(context).pop(),
                                          )
                                        : null,
                                  ),
                                  Expanded(
                                    child: Text(
                                      title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 56),
                                ],
                              ),
                            ),
                            if (bottom != null)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  18,
                                  0,
                                  18,
                                  20,
                                ),
                                child: bottom,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}

/// Light page shell for the entry/OTP screens: soft-blue background and a
/// round back button top-left, content in a safe area.
class FigmaLightScaffold extends StatelessWidget {
  const FigmaLightScaffold({
    super.key,
    required this.body,
    this.showBackButton = true,
    this.onBackPressed,
  });

  final Widget body;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    final canPop = showBackButton && Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: t.page,
      body: FigmaBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (canPop)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Material(
                    color: t.card,
                    shape: const CircleBorder(),
                    elevation: 1,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onBackPressed ?? () => Navigator.of(context).pop(),
                      child: SizedBox(
                        width: 36,
                        height: 36,
                        child: Icon(AppIcons.back, size: 18, color: t.heading),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(height: 8),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}

/// Solid themed canvas behind a screen's content (warm beige in light mode,
/// the dark surface in dark mode). Deliberately no artwork.
class FigmaBackground extends StatelessWidget {
  const FigmaBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: FigmaColors.of(context).page,
      child: SizedBox.expand(child: child),
    );
  }
}
