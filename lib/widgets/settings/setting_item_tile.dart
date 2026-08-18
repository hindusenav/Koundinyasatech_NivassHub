import 'package:flutter/material.dart';

class SettingItemTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final Color? iconBgColor;
  final String title;
  final Color? titleColor;
  final String subtitle;
  final String? badgeText;
  final Color? badgeColor;
  final VoidCallback? onTap;
  final bool isSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  const SettingItemTile({
    super.key,
    required this.icon,
    this.iconColor,
    this.iconBgColor,
    required this.title,
    this.titleColor,
    required this.subtitle,
    this.badgeText,
    this.badgeColor,
    this.onTap,
    this.isSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        onTap: isSwitch ? null : onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBgColor ?? const Color(0xFFF0F7FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: iconColor ?? const Color(0xFF1976D2),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: titleColor ?? Colors.black87,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              )
            : null,
        trailing: isSwitch
            ? Switch.adaptive(
                value: switchValue,
                activeThumbColor: const Color(0xFF1976D2),
                onChanged: onSwitchChanged,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (badgeText != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: (badgeColor ?? const Color(0xFF1976D2)).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badgeText!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: badgeColor ?? const Color(0xFF1976D2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                ],
              ),
      ),
    );
  }
}