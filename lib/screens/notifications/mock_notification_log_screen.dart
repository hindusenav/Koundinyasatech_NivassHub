import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_dimensions.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/constants/app_spacing.dart';
import 'package:flutter_nivasshub/constants/app_text_styles.dart';
import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';
import 'package:flutter_nivasshub/models/notifications/mock_notification_model.dart';
import 'package:flutter_nivasshub/providers/notifications/mock_notification_provider.dart';
import 'package:flutter_nivasshub/widgets/shared/app_bar/custom_app_bar.dart';
import 'package:flutter_nivasshub/widgets/shared/cards/custom_card.dart';
import 'package:flutter_nivasshub/widgets/shared/loaders/loader.dart';
import 'package:flutter_nivasshub/widgets/shared/states/custom_error_widget.dart';
import 'package:flutter_nivasshub/widgets/shared/states/empty_state.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// In-app stand-in for the inbox the KYC emails would land in (spec §16).
///
/// The mail service is not connected, so [MockNotificationService] logs
/// each message to the console and records it here.
class MockNotificationLogScreen extends StatefulWidget {
  const MockNotificationLogScreen({super.key});

  @override
  State<MockNotificationLogScreen> createState() =>
      _MockNotificationLogScreenState();
}

class _MockNotificationLogScreenState extends State<MockNotificationLogScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final provider = context.read<MockNotificationProvider>();
      await provider.load();
      // Reading the log is what marks it read, so the Settings badge
      // clears as soon as the user has actually seen the messages.
      if (mounted) await provider.markAllRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MockNotificationProvider>();

    return Scaffold(
      appBar: CustomAppBar(
        title: KycStrings.notificationLogTitle,
        actions: [
          if (provider.notifications.isNotEmpty)
            IconButton(
              tooltip: 'Clear',
              icon: const Icon(AppIcons.delete, size: AppDimensions.iconSm),
              onPressed: provider.clear,
            ),
        ],
      ),
      body: SafeArea(child: _buildBody(provider)),
    );
  }

  Widget _buildBody(MockNotificationProvider provider) {
    return switch (provider.state) {
      NotificationLogState.initial ||
      NotificationLogState.loading => const Loader(),
      NotificationLogState.error => CustomErrorWidget(
        message: provider.errorMessage ?? KycStrings.genericError,
        onRetry: provider.load,
      ),
      NotificationLogState.empty => const EmptyState(
        title: KycStrings.notificationLogEmpty,
        message: KycStrings.notificationLogEmptyMessage,
        icon: AppIcons.email,
      ),
      NotificationLogState.success => ListView.builder(
        padding: AppSpacing.screenPadding,
        itemCount: provider.notifications.length,
        itemBuilder: (context, index) =>
            _NotificationTile(notification: provider.notifications[index]),
      ),
    };
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});

  final MockNotificationModel notification;

  Color get _accent => switch (notification.type) {
    MockNotificationType.kycApproved => AppColors.success,
    MockNotificationType.kycRejected => AppColors.error,
    MockNotificationType.kycCorrectionRequired => AppColors.warning,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Padding(
      padding: AppSpacing.vertical(AppSpacing.sm),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  AppIcons.email,
                  size: AppDimensions.iconSm,
                  color: _accent,
                ),
                AppSpacing.gapWSm,
                Expanded(
                  child: Text(
                    notification.subject,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: textPrimary,
                      fontWeight: notification.read
                          ? FontWeight.w500
                          : FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapXs,
            Text(
              'To: ${notification.recipient} · '
              '${DateFormat('dd MMM yyyy, hh:mm a').format(notification.sentAt)}',
              style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
            ),
            AppSpacing.gapSm,
            Text(
              notification.body,
              style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
