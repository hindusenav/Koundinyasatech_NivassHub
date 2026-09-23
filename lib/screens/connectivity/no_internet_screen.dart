import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/providers/connectivity/connectivity_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/routes/navigation_service.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/primary_button.dart';
import 'package:flutter_nivasshub/widgets/shared/buttons/secondary_button.dart';

/// Shown by [NoInternetOverlay] on top of the current screen whenever the
/// device has no real internet access. Not a routed destination — the
/// screen underneath is never left, so restoring connectivity simply
/// removes this overlay and reveals it exactly as it was.
class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  static const String _title = 'No Internet Connection';
  static const String _description =
      "Looks like you're not connected to the internet.\n"
      'Please check your connection and try again.';

  Future<void> _tryAgain(BuildContext context) {
    return context.read<ConnectivityProvider>().checkConnection();
  }

  Future<void> _checkConnection(BuildContext context) async {
    final hasInternet =
        await context.read<ConnectivityProvider>().checkConnection();

    if (!hasInternet && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Still no internet connection.')),
      );
    }
  }

  void _contactSupport() {
    NavigationService.pushNamed(AppRoutes.helpSupport);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Consumer<ConnectivityProvider>(
              builder: (context, connectivity, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: AppDimensions.avatarXl,
                      height: AppDimensions.avatarXl,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: isDark ? 0.16 : 0.08),
                      ),
                      child: Icon(
                        AppIcons.noConnection,
                        size: AppDimensions.iconXl,
                        color: AppColors.primary,
                      ),
                    ),
                    AppSpacing.gapXl,
                    Text(
                      _title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.gapMd,
                    Text(
                      _description,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: secondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.gapXl,
                    PrimaryButton(
                      label: 'Try Again',
                      icon: AppIcons.refresh,
                      isLoading: connectivity.isChecking,
                      onPressed: () => _tryAgain(context),
                    ),
                    AppSpacing.gapMd,
                    SecondaryButton(
                      label: 'Check Connection',
                      icon: AppIcons.signalCheck,
                      isLoading: connectivity.isChecking,
                      onPressed: () => _checkConnection(context),
                    ),
                    AppSpacing.gapXl,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Need help? ',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: secondaryColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: _contactSupport,
                          child: Text(
                            'Contact Support',
                            style: AppTextStyles.link,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
