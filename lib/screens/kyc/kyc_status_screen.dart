import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';
import 'package:flutter_nivasshub/storage/secure_storage_service.dart';
import 'package:flutter_nivasshub/constants/asset_constants.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/string_constants.dart';
import 'package:flutter_nivasshub/utils/extensions/context_extensions.dart';
import 'package:flutter_nivasshub/constants/auth/auth_colors.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_gradient_button.dart';
import 'package:flutter_nivasshub/widgets/auth/auth_skyline_painter.dart';
import 'package:flutter_nivasshub/widgets/auth/success_check_icon.dart';
import 'package:flutter_nivasshub/widgets/shared/dialogs/confirmation_dialog.dart';

/// Scenario 1:
/// Existing User + KYC Already Approved.
///
/// Flow:
/// Login -> KYC Status Check -> KYC Verified -> Home
class KycStatusScreen extends StatefulWidget {
  const KycStatusScreen({super.key});

  @override
  State<KycStatusScreen> createState() => _KycStatusScreenState();
}

class _KycStatusScreenState extends State<KycStatusScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;

  @override
  void initState() {
    super.initState();

    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  /// Scenario 1:
  /// Existing user whose KYC is already approved.
  ///
  /// Save the session, refresh dashboard data and go directly to Home.
  Future<void> _handleContinue() async {
    await context.read<SecureStorageService>().saveSession();

    if (!mounted) return;

    context.read<DashboardProvider>().refresh();

    NavigationService.pushNamedAndRemoveUntil(
      AppRoutes.dashboard,
    );
  }

  /// Prevent accidental back navigation from the KYC status screen.
  Future<void> _handleBackPress() async {
    final shouldExit = await ConfirmationDialog.show(
      context,
      title: StringConstants.exitConfirmationTitle,
      message: StringConstants.exitConfirmationMessage,
      confirmText: StringConstants.exit,
      isDestructive: true,
    );

    if (!mounted) return;

    if (shouldExit) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final screenHeight = context.screenHeight;

    final background = isDark
        ? AuthColors.backgroundDarkMode
        : AuthColors.background;

    final heading = isDark
        ? AuthColors.headingDarkMode
        : AuthColors.heading;

    final bodyText = isDark
        ? AuthColors.bodyTextDarkMode
        : AuthColors.bodyText;

    final primaryBlue = isDark
        ? AuthColors.primaryBlueDarkMode
        : AuthColors.primaryBlue;

    final lightBlue = isDark
        ? AuthColors.lightBlueDarkMode
        : AuthColors.lightBlue;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBackPress();
        }
      },
      child: Scaffold(
        backgroundColor: background,
        body: Stack(
          children: [
            // ============================================================
            // BACKGROUND
            // ============================================================

            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      background,
                      background,
                      lightBlue.withValues(alpha: 0.05),
                    ],
                    stops: const [
                      0.0,
                      0.55,
                      1.0,
                    ],
                  ),
                ),
              ),
            ),

            // ============================================================
            // SKYLINE ANIMATION
            // ============================================================

            AnimatedBuilder(
              animation: _entrance,
              builder: (context, _) {
                final illustrationT = const Interval(
                  0.20,
                  0.65,
                  curve: Curves.easeOutCubic,
                ).transform(_entrance.value);

                final opacity =
                    illustrationT.clamp(0.0, 1.0);

                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: screenHeight * 0.32,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: opacity,
                      child: Transform.translate(
                        offset: Offset(
                          0,
                          (1 - opacity) * 20,
                        ),
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: AuthSkylinePainter(
                            progress: opacity,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // ============================================================
            // MAIN CONTENT
            // ============================================================

            SafeArea(
              child: Center(
                child: Padding(
                  padding: AppSpacing.horizontal(
                    AppSpacing.lg,
                  ),
                  child: SingleChildScrollView(
                    child: AnimatedBuilder(
                      animation: _entrance,
                      builder: (context, _) {
                        final t = _entrance.value;

                        final logoT = const Interval(
                          0.00,
                          0.35,
                          curve: Curves.easeOut,
                        ).transform(t);

                        final iconT = const Interval(
                          0.10,
                          0.55,
                          curve: Curves.easeOutBack,
                        ).transform(t);

                        final titleT = const Interval(
                          0.35,
                          0.70,
                          curve: Curves.easeOut,
                        ).transform(t);

                        final subtitleT = const Interval(
                          0.42,
                          0.76,
                          curve: Curves.easeOut,
                        ).transform(t);

                        final buttonT = const Interval(
                          0.55,
                          0.90,
                          curve: Curves.easeOutCubic,
                        ).transform(t);

                        final footerT = const Interval(
                          0.68,
                          1.00,
                          curve: Curves.easeOut,
                        ).transform(t);

                        return Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            // ==================================================
                            // LOGO
                            // ==================================================

                            Opacity(
                              opacity:
                                  logoT.clamp(0.0, 1.0),
                              child: Image.asset(
                                AppAssets.logo,
                                width: 180,
                              ),
                            ),

                            SizedBox(
                              height: AppSpacing.xl,
                            ),

                            // ==================================================
                            // SUCCESS CHECK ICON
                            // ==================================================

                            SuccessCheckIcon(
                              entrance: iconT,
                            ),

                            SizedBox(
                              height: AppSpacing.xl,
                            ),

                            // ==================================================
                            // KYC VERIFIED TITLE
                            // ==================================================

                            Opacity(
                              opacity:
                                  titleT.clamp(0.0, 1.0),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'KYC ',
                                      style: AppTextStyles
                                          .headlineSmall
                                          .copyWith(
                                        color: heading,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Verified!',
                                      style: AppTextStyles
                                          .headlineSmall
                                          .copyWith(
                                        color: primaryBlue,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            SizedBox(
                              height: AppSpacing.sm,
                            ),

                            // ==================================================
                            // KYC MESSAGE
                            // ==================================================

                            Opacity(
                              opacity:
                                  subtitleT.clamp(0.0, 1.0),
                              child: Text(
                                'Your KYC is already approved.',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyLarge
                                    .copyWith(
                                  color: bodyText,
                                ),
                              ),
                            ),

                            SizedBox(
                              height: AppSpacing.xxl,
                            ),

                            // ==================================================
                            // CONTINUE BUTTON
                            // ==================================================

                            Opacity(
                              opacity:
                                  buttonT.clamp(0.0, 1.0),
                              child: AuthGradientButton(
                                label: 'Continue',
                                onPressed: _handleContinue,
                              ),
                            ),

                            SizedBox(
                              height: AppSpacing.xl,
                            ),

                            // ==================================================
                            // SECURE FOOTER
                            // ==================================================

                            Opacity(
                              opacity:
                                  footerT.clamp(0.0, 1.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    AppIcons.checkCircle,
                                    size:
                                        AppDimensions.iconSm,
                                    color:
                                        AppColors.success,
                                  ),
                                  SizedBox(
                                    width: AppSpacing.xs,
                                  ),
                                  Text(
                                    '100% Secure',
                                    style:
                                        AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: screenHeight * 0.06,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
