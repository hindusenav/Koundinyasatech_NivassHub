import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../../shared/widgets/cards/custom_card.dart';
import '../../../shared/widgets/common/section_title.dart';

/// Fully static — no model/provider/service, no loading/error states apply.
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      'question': 'How do I approve a visitor?',
      'answer':
          'Open Visitors from the bottom navigation, then tap Approve or Reject next to the visitor request.',
    },
    {
      'question': 'Where do I find Quick Actions?',
      'answer':
          'Tap More in the bottom navigation, or the search bar on the Home screen, to open the full Quick Actions catalog.',
    },
    {
      'question': 'How do I change my society?',
      'answer':
          'Society switching is managed by your building management committee — contact your society admin directly.',
    },
    {
      'question': 'Who do I contact for billing issues?',
      'answer': 'Reach out using the contact details above — our support team handles billing questions directly.',
    },
  ];

  Future<void> _call() => launchUrl(Uri.parse('tel:+911234567890'));

  Future<void> _email() => launchUrl(Uri.parse('mailto:support@nivashub.com'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Help & Support'),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding(context),
            vertical: 20,
          ),
          children: [
            Text(
              "We're here to help. Reach out to us directly, or check the frequently asked questions below.",
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: 20),
            CustomCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(AppIcons.phone, color: AppColors.primary),
                    title: const Text('Call Support'),
                    subtitle: const Text('+91 12345 67890'),
                    onTap: _call,
                  ),
                  ListTile(
                    leading: Icon(AppIcons.email, color: AppColors.primary),
                    title: const Text('Email Support'),
                    subtitle: const Text('support@nivashub.com'),
                    onTap: _email,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionTitle(title: 'Frequently Asked Questions'),
            ..._faqs.map(
              (faq) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CustomCard(
                  padding: EdgeInsets.zero,
                  child: ExpansionTile(
                    title: Text(faq['question']!, style: AppTextStyles.titleSmall),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          faq['answer']!,
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
                        ),
                      ),
                    ],
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
