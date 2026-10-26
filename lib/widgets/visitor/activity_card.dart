import 'package:flutter/material.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/models/visitor/approval_activity_model.dart';

/// One row on the Visitor Log screen: 48px avatar, name + category, arrival
/// time pill, status badge, verification note and the Approve / Deny /
/// Call Gate action row.
class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.activity,
    this.onCall,
    this.onWrongEntry,
    this.onApprove,
    this.onDeny,
  });

  final ApprovalActivityModel activity;

  /// "Call Gate".
  final VoidCallback? onCall;
  final VoidCallback? onWrongEntry;
  final VoidCallback? onApprove;
  final VoidCallback? onDeny;

  static const double _avatarSize = 48;

  ({String label, Color fg, Color bg}) get _status {
    switch (activity.status.toUpperCase()) {
      case 'INSIDE':
        return (
          label: 'Checked-In',
          fg: AppColors.badgeGreen,
          bg: AppColors.badgeGreenBg,
        );
      case 'DENIED':
        return (
          label: 'Denied',
          fg: AppColors.error,
          bg: AppColors.errorLight,
        );
      case 'LEFT':
        return (
          label: 'Left',
          fg: AppColors.textMuted,
          bg: AppColors.iconMoreBg,
        );
      default:
        return (
          label: activity.status,
          fg: AppColors.primaryOrangeDark,
          bg: AppColors.accentTint,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _status;
    final noteColor = activity.isDenied ? AppColors.error : AppColors.badgeGreen;
    final title = activity.company ?? activity.name;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ActivityAvatar(label: title, size: _avatarSize),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.name,
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
                      title,
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
              _Pill(label: status.label, fg: status.fg, bg: status.bg),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _Pill(
                icon: Icons.schedule_rounded,
                label: activity.timestamp,
                fg: AppColors.textMuted,
                bg: AppColors.background,
              ),
              if (activity.approvedBy != null) ...[
                const SizedBox(width: 8),
                const Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: AppColors.badgeGreen,
                ),
              ],
            ],
          ),
          if (activity.approvalNoteText.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.shield_outlined, size: 16, color: noteColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    activity.approvalNoteText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: noteColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'Approve',
                  icon: Icons.check_rounded,
                  fg: AppColors.white,
                  bg: AppColors.badgeGreen,
                  onTap: onApprove,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  label: 'Deny',
                  icon: Icons.close_rounded,
                  fg: AppColors.error,
                  bg: AppColors.errorLight,
                  onTap: onDeny,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  label: 'Call Gate',
                  icon: Icons.call_rounded,
                  fg: AppColors.textDark,
                  bg: AppColors.iconMoreBg,
                  onTap: onCall,
                ),
              ),
            ],
          ),
          if (onWrongEntry != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onWrongEntry,
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  activity.isWrongEntry ? 'Marked Wrong' : 'Wrong Entry',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: activity.isWrongEntry
                        ? AppColors.error
                        : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.fg, required this.bg, this.icon});

  final String label;
  final Color fg;
  final Color bg;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.fg,
    required this.bg,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color fg;
  final Color bg;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: fg),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: fg,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Colored initials circle for the card's leading avatar. Delivery brands
/// get a deterministic color from [_brandColors]; anything else falls back
/// to a neutral tone.
class _ActivityAvatar extends StatelessWidget {
  const _ActivityAvatar({required this.label, required this.size});

  final String label;
  final double size;

  static const Map<String, Color> _brandColors = {
    'Blinkit': AppColors.tertiary,
    'Zepto': AppColors.primaryDark,
    'Amazon': AppColors.warning,
    'Dunzo': AppColors.secondaryDark,
    'Swiggy': AppColors.error,
    'BigBasket': AppColors.success,
  };

  @override
  Widget build(BuildContext context) {
    final color = _brandColors[label] ?? AppColors.headerStart;

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: color,
      child: Text(
        label.isNotEmpty ? label[0].toUpperCase() : '?',
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
