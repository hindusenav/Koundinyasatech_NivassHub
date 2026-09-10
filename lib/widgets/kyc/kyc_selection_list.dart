import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/app_colors.dart';

/// One selectable row rendered inside a [KycListCardGroup] — a leading
/// icon/flag, a title and a tap handler. Reused across the KYC
/// location-selection screens (Select Country / Select State / Select City)
/// so each screen only supplies its own data + leading visual.
class KycListItemData {
  final Widget leading;
  final String title;
  final VoidCallback onTap;

  const KycListItemData({
    required this.leading,
    required this.title,
    required this.onTap,
  });
}

/// Small blue accent bar + uppercase label used to head a list section
/// ("POPULAR COUNTRIES", "ALL STATES", ...).
class KycSectionTitle extends StatelessWidget {
  final String title;

  const KycSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          // accent-indicator: Width 4px, Height 16px, Radius 2px, Color #0060BD
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFF0060BD),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),

          // section-title: DM Sans 700 Bold 12px, #1D1B20, Letter spacing 1.0
          Text(
            title,
            style: TextStyle(
              fontFamily: 'DM Sans',
              color: isDark ? AppColors.grey300 : const Color(0xFF1D1B20),
              fontWeight: FontWeight.w700,
              fontSize: 12,
              height: 1.0,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded, bordered card holding a divided list of [KycListItemData] rows
/// (leading visual, title, chevron). Used for every list section in the KYC
/// location-selection flow (countries, states, cities).
class KycListCardGroup extends StatelessWidget {
  final List<KycListItemData> items;

  const KycListCardGroup({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? AppColors.surfaceDark : AppColors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF000000);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: isDark
            ? null
            : const [
                BoxShadow(
                  color: Color.fromRGBO(5, 35, 77, 0.0588),
                  offset: Offset(0, 6),
                  blurRadius: 16,
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.vertical(
                  top: index == 0 ? const Radius.circular(16) : Radius.zero,
                  bottom: isLast ? const Radius.circular(16) : Radius.zero,
                ),
                child: SizedBox(
                  height: 52,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        item.leading,
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              color: textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: isDark ? AppColors.grey400 : const Color(0xFF10213D),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark ? AppColors.grey800 : const Color(0xFFF3F4F6),
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }),
      ),
    );
  }
}
