import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
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
  });

  final String title;
  final Widget body;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    final canPop = showBackButton && Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: t.page,
      body: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
            child: Container(
              width: double.infinity,
              color: t.header,
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 56,
                        child: canPop
                            ? IconButton(
                                icon: const Icon(AppIcons.back, color: Colors.white, size: 20),
                                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                              )
                            : null,
                      ),
                      Expanded(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 56),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: body),
        ],
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
      body: SafeArea(
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
    );
  }
}
