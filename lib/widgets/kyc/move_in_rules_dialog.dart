import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';

/// Figma "Society Move-in Rules" dialog: a list of rules and an orange
/// "I Agree to Move-in Rules" button. Resolves to `true` when agreed.
class MoveInRulesDialog extends StatelessWidget {
  const MoveInRulesDialog({super.key, required this.rules});

  final List<String> rules;

  static const Color _bullet = Color(0xFF12A28F);

  static Future<bool?> show(BuildContext context, {required List<String> rules}) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (_) => MoveInRulesDialog(rules: rules),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);

    return Dialog(
      backgroundColor: t.card,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Society Move-in Rules',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: t.heading,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final rule in rules)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Text(
                                      '*',
                                      style: TextStyle(
                                        fontSize: 14,
                                        height: 1.4,
                                        fontWeight: FontWeight.w700,
                                        color: _bullet,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      rule,
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1.45,
                                        color: t.heading,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Full-bleed orange action bar flush with the card's bottom edge.
          Material(
            color: FigmaColors.orange,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(true),
              child: const SizedBox(
                height: 48,
                child: Center(
                  child: Text(
                    'I Agree to Move-in Rules',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
