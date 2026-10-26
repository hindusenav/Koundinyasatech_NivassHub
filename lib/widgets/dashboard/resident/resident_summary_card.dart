import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/providers/dashboard/dashboard_provider.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';
import 'package:flutter_nivasshub/widgets/shared/glass/glass_widgets.dart';

/// Resident card under the header: tower + flat selector, "Add Flat/Villa/
/// Office" row and the Approvals / Dues / Guests-today stats.
class ResidentSummaryCard extends StatelessWidget {
  const ResidentSummaryCard({
    super.key,
    required this.isPropertyPanelExpanded,
    required this.onTogglePropertyPanel,
  });

  final bool isPropertyPanelExpanded;
  final VoidCallback onTogglePropertyPanel;

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    final provider = context.watch<DashboardProvider>();
    final user = provider.home?.data.user;
    final addresses = provider.addresses;

    final defaultAddress = addresses.isNotEmpty
        ? addresses.firstWhere(
            (e) => e.isDefault,
            orElse: () => addresses.first,
          )
        : null;
    final flatLabel = defaultAddress?.flatNumber ?? (user?.flatNumber ?? 'B - 402');
    final shownFlat = flatLabel.isNotEmpty ? flatLabel : 'B - 402';
    final userName = (user?.name ?? '').trim();
    final initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.orange,
                ),
                child: Text(
                  initial,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tower B',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: t.heading,
                      ),
                    ),
                    Text(
                      'Resident · Verified',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: t.body,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onTogglePropertyPanel,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: t.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: t.cardBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(child: Text(
                        '$shownFlat · Tower B',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: t.heading,
                        ),
                      )),
                      Icon(
                        isPropertyPanelExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: t.heading,
                      ),
                    ],
                  ),
                ),
                ),
              ),
            ],
          ),
          if (isPropertyPanelExpanded) ...[
            const SizedBox(height: 10),
            Text(
              '$shownFlat Golden Residency',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: t.heading,
              ),
            ),
          ],
          const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.pushNamed(context, AppRoutes.addProperty),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.sectionBg.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: t.heading, width: 1.2),
                    ),
                    child: Icon(Icons.add, size: 20, color: t.heading),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Add Flat/Villa/Office',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: t.heading,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 2, color: AppColors.orange),
          const SizedBox(height: 12),
          Row(
            children: [
              _Stat(
                label: 'Approvals',
                value: '${provider.visitors.length}',
                onTap: () => Navigator.pushNamed(context, AppRoutes.activities),
              ),
              const _StatDivider(),
              const _Stat(label: 'Dues', value: '₹1,500'),
              const _StatDivider(),
              const _Stat(label: 'Guests today', value: '3'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.onTap});

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 12, color: t.body),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: t.heading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: AppColors.orange.withValues(alpha: 0.5),
    );
  }
}
