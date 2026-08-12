import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/app_routes.dart';
import '../../../app/navigation_service.dart';
import '../../../app/theme_mode_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/string_constants.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../shared/widgets/buttons/custom_button.dart';
import '../../../shared/widgets/cards/custom_card.dart';
import '../../../shared/widgets/common/section_title.dart';
import '../../../shared/widgets/dialogs/confirmation_dialog.dart';
import '../../profile/provider/profile_provider.dart';
import '../provider/settings_provider.dart';
import '../widgets/household_card.dart';

/// Preferences, support, and logout. Dark Mode reads/writes the app-wide
/// `ThemeModeProvider` directly (not `SettingsProvider`) so there is a
/// single source of truth for the live theme.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _addHouseholdItem(
    BuildContext context, {
    required String label,
    required Future<void> Function() onConfirm,
  }) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Add $label',
      message: 'Add a $label to your household?',
    );
    if (!confirmed) return;
    await onConfirm();
  }

  Future<void> _handleLogout(BuildContext context) async {
    final secureStorageService = context.read<SecureStorageService>();

    final confirmed = await ConfirmationDialog.show(
      context,
      title: StringConstants.logoutConfirmationTitle,
      message: StringConstants.logoutConfirmationMessage,
      isDestructive: true,
    );
    if (!confirmed) return;

    await secureStorageService.clearTokens();
    await NavigationService.logoutAndRedirectToLogin();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
    final settings = context.watch<SettingsProvider>();
    final themeMode = context.watch<ThemeModeProvider>();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding(context),
            vertical: 20,
          ),
          children: [
            CustomCard(
              onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text(
                      (profile?.fullName.isNotEmpty ?? false)
                          ? profile!.fullName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(color: AppColors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(profile?.fullName ?? 'My Profile', style: AppTextStyles.titleSmall),
                  ),
                  Icon(AppIcons.chevronRight, color: AppColors.grey400),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionTitle(title: 'Preferences'),
            CustomCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Push Notifications'),
                    value: settings.notificationsEnabled,
                    onChanged: settings.setNotificationsEnabled,
                  ),
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    value: themeMode.isDarkMode,
                    onChanged: (value) =>
                        themeMode.setThemeMode(value ? ThemeMode.dark : ThemeMode.light),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionTitle(title: 'Household'),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.4,
              children: [
                HouseholdCard(
                  title: 'Family',
                  subtitle: '${settings.familyCount} member(s)',
                  icon: AppIcons.family,
                  onAdd: () => _addHouseholdItem(
                    context,
                    label: 'family member',
                    onConfirm: settings.addFamilyMember,
                  ),
                ),
                HouseholdCard(
                  title: 'Daily Help',
                  subtitle: '${settings.dailyHelpCount} registered',
                  icon: AppIcons.dailyHelp,
                  onAdd: () => _addHouseholdItem(
                    context,
                    label: 'daily help',
                    onConfirm: settings.addDailyHelp,
                  ),
                ),
                HouseholdCard(
                  title: 'Vehicles',
                  subtitle: '${settings.vehicleCount} registered',
                  icon: AppIcons.vehicle,
                  onAdd: () => _addHouseholdItem(
                    context,
                    label: 'vehicle',
                    onConfirm: settings.addVehicle,
                  ),
                ),
                HouseholdCard(
                  title: 'Pets',
                  subtitle: '${settings.petCount} registered',
                  icon: AppIcons.pet,
                  onAdd: () => _addHouseholdItem(
                    context,
                    label: 'pet',
                    onConfirm: settings.addPet,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const SectionTitle(title: 'Support'),
            CustomCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.help_outline_rounded),
                    title: const Text('Help & Support'),
                    trailing: Icon(AppIcons.chevronRight, color: AppColors.grey400),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.helpSupport),
                  ),
                  ListTile(
                    leading: Icon(AppIcons.info),
                    title: const Text('About'),
                    trailing: Icon(AppIcons.chevronRight, color: AppColors.grey400),
                    onTap: () => showAboutDialog(
                      context: context,
                      applicationName: AppConstants.appName,
                      applicationVersion: '1.0.0',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              label: 'Log Out',
              icon: AppIcons.logout,
              backgroundColor: AppColors.error,
              onPressed: () => _handleLogout(context),
            ),
          ],
        ),
      ),
    );
  }
}
