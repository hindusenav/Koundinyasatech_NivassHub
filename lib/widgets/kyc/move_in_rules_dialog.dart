import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_widgets.dart';

/// Figma "Society Move-in Rules" dialog: a list of rules and an orange
/// "I Agree to Move-in Rules" button. Resolves to `true` when agreed.
class MoveInRulesDialog extends StatelessWidget {
  const MoveInRulesDialog({super.key, required this.rules});

  final List<String> rules;

  static Future<bool?> show(BuildContext context, {required List<String> rules}) {
    return showDialog<bool>(
      context: context,
      builder: (_) => MoveInRulesDialog(rules: rules),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = FigmaColors.of(context);

    return Dialog(
      backgroundColor: t.card,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Society Move-in Rules',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: t.heading),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final rule in rules)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 6, right: 8),
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: FigmaColors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                rule,
                                style: TextStyle(fontSize: 13, height: 1.4, color: t.body),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            FigmaButton(
              label: 'I Agree to Move-in Rules',
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ),
    );
  }
}
