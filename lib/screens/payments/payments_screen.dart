import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';
import 'package:flutter_nivasshub/widgets/shared/app_bar/custom_app_bar.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';

/// Payments Center: outstanding-dues hero card, month status pills and the
/// payment ledger.
///
/// UI-only for now — there is no payments API/repository in the app yet, so
/// the figures below are sample data shaped like the dashboard's "Dues"
/// stat. Replace [_months], [_dueItems] and [_history] with provider data
/// once a payments service exists; the layout does not depend on where the
/// values come from.
class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  static const double _pagePadding = 16;

  static const _months = <_MonthStatus>[
    _MonthStatus('Oct', 'Pending', paid: false),
    _MonthStatus('Sep', 'Paid', paid: true),
    _MonthStatus('Aug', 'Paid', paid: true),
    _MonthStatus('Jul', 'Paid', paid: true),
  ];

  static const _dueItems = <_DueItem>[
    _DueItem('Maintenance', '₹1,200'),
    _DueItem('Utilities', '₹300'),
  ];

  static const _history = <_PaymentRecord>[
    _PaymentRecord(
      title: 'Maintenance - Sep',
      date: '05 Sep 2026',
      reference: 'UPI · 4829 1736 0021',
      amount: '₹1,500',
    ),
    _PaymentRecord(
      title: 'Maintenance - Aug',
      date: '04 Aug 2026',
      reference: 'Card · •••• 4417',
      amount: '₹1,500',
    ),
    _PaymentRecord(
      title: 'Maintenance - Jul',
      date: '06 Jul 2026',
      reference: 'UPI · 3917 2204 8810',
      amount: '₹1,450',
    ),
  ];

  int _selectedMonth = 0;

  void _payAll() {
    CustomSnackbar.info(context, 'Online payments are coming soon.');
  }

  void _downloadReceipt(_PaymentRecord record) {
    CustomSnackbar.info(context, 'Receipt for ${record.title} coming soon.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Payments Center',
        showBackButton: false,
      ),
      bottomNavigationBar: const DashboardBottomNavigation(selectedIndex: 3),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(_pagePadding),
          children: [
            _DuesHeroCard(items: _dueItems, onPayAll: _payAll),
            const SizedBox(height: 20),
            const _SectionTitle('Monthly status'),
            const SizedBox(height: 10),
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _months.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (_, i) => _MonthPill(
                  month: _months[i],
                  selected: i == _selectedMonth,
                  onTap: () => setState(() => _selectedMonth = i),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const _SectionTitle('Payment history'),
            const SizedBox(height: 10),
            for (final record in _history) ...[
              _PaymentCard(
                record: record,
                onDownload: () => _downloadReceipt(record),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _MonthStatus {
  const _MonthStatus(this.month, this.label, {required this.paid});

  final String month;
  final String label;
  final bool paid;
}

class _DueItem {
  const _DueItem(this.label, this.amount);

  final String label;
  final String amount;
}

class _PaymentRecord {
  const _PaymentRecord({
    required this.title,
    required this.date,
    required this.reference,
    required this.amount,
  });

  final String title;
  final String date;
  final String reference;
  final String amount;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textDark,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: AppColors.cardBg,
  borderRadius: BorderRadius.circular(AppColors.cardRadius),
  border: Border.all(color: AppColors.cardBorder),
);

class _DuesHeroCard extends StatelessWidget {
  const _DuesHeroCard({required this.items, required this.onPayAll});

  final List<_DueItem> items;
  final VoidCallback onPayAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Outstanding dues',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentTint,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: AppColors.primaryOrangeDark,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Due Oct 31',
                      style: TextStyle(
                        color: AppColors.primaryOrangeDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '₹1,500',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                for (final item in items)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.label,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          item.amount,
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onPayAll,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Pay All Now',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthPill extends StatelessWidget {
  const _MonthPill({
    required this.month,
    required this.selected,
    required this.onTap,
  });

  final _MonthStatus month;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = month.paid
        ? AppColors.badgeGreen
        : AppColors.primaryOrangeDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 88,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentTint : AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primaryOrange : AppColors.cardBorder,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              month.month,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              month.label,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.record, required this.onDownload});

  final _PaymentRecord record;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.badgeGreenBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 20,
              color: AppColors.badgeGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${record.date} · ${record.reference}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                record.amount,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              InkWell(
                onTap: onDownload,
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.download_rounded,
                        size: 14,
                        color: AppColors.primaryOrange,
                      ),
                      SizedBox(width: 2),
                      Text(
                        'Receipt',
                        style: TextStyle(
                          color: AppColors.primaryOrange,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
