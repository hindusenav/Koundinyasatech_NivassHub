import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../shared/widgets/cards/custom_card.dart';
import '../../../shared/widgets/common/section_title.dart';
import '../../../shared/widgets/states/custom_error_widget.dart';
import '../provider/profile_provider.dart';
import '../widgets/profile_info_row.dart';
import '../widgets/profile_shimmer.dart';

/// Read-only display of the current user's profile and active society —
/// the contract has no update-profile endpoint, so there is no edit UI here.
/// `ProfileProvider` is loaded eagerly at app startup (same convention as
/// `DashboardProvider`); this screen only reads its current state and offers
/// pull-to-refresh / retry.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Profile',
        actions: [
          IconButton(
            icon: Icon(AppIcons.settings),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading && provider.profile == null && provider.activeSociety == null) {
              return const ProfileShimmer();
            }
            if (provider.hasError && provider.profile == null && provider.activeSociety == null) {
              return CustomErrorWidget(
                message: provider.errorMessage ?? 'Something went wrong. Please try again.',
                onRetry: provider.retry,
              );
            }
            return RefreshIndicator(
              onRefresh: provider.loadProfile,
              child: _buildBody(context, provider),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProfileProvider provider) {
    final profile = provider.profile;
    final society = provider.activeSociety;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: 20,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: AppDimensions.avatarXl / 2,
            backgroundColor: AppColors.primary,
            child: Text(
              (profile?.fullName.isNotEmpty ?? false) ? profile!.fullName[0].toUpperCase() : '?',
              style: AppTextStyles.headlineMedium.copyWith(color: AppColors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(profile?.fullName ?? 'Unable to load name', style: AppTextStyles.titleLarge),
          const SizedBox(height: 24),
          const SectionTitle(title: 'Contact Details'),
          if (provider.profileFailed && profile == null)
            const _SectionUnavailable()
          else
            CustomCard(
              child: Column(
                children: [
                  ProfileInfoRow(
                    icon: AppIcons.phone,
                    label: 'Mobile Number',
                    value: profile?.mobileNumber ?? '-',
                  ),
                  ProfileInfoRow(
                    icon: AppIcons.email,
                    label: 'Email',
                    value: profile?.email ?? '-',
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          const SectionTitle(title: 'Address'),
          if (provider.profileFailed && profile == null)
            const _SectionUnavailable()
          else
            CustomCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(AppIcons.location, size: AppDimensions.iconSm, color: AppColors.grey500),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      profile?.address.displayAddress ?? '-',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey800),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          const SectionTitle(title: 'Active Society'),
          if (provider.activeSocietyFailed && society == null)
            const _SectionUnavailable()
          else
            CustomCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(AppIcons.society, size: AppDimensions.iconSm, color: AppColors.grey500),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(society?.name ?? '-', style: AppTextStyles.titleSmall),
                        const SizedBox(height: 4),
                        Text(
                          society?.fullAddress ?? '-',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionUnavailable extends StatelessWidget {
  const _SectionUnavailable();

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Text(
        'Unable to load this section.',
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
      ),
    );
  }
}
