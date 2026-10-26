import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/constants/figma_colors.dart';
import 'package:flutter_nivasshub/screens/location/select_country_screen.dart';
import 'package:flutter_nivasshub/widgets/shared/figma/figma_widgets.dart';

/// Navy bottom sheet from the Figma "Confirm City" screen: the chosen city
/// in a white row with a check, and an orange "Confirm City" button.
/// Resolves to `true` when confirmed, `null`/`false` when dismissed.
class ConfirmCitySheet extends StatelessWidget {
  const ConfirmCitySheet({super.key, required this.city});

  final FigmaPlace city;

  static Future<bool?> show(BuildContext context, {required FigmaPlace city}) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ConfirmCitySheet(city: city),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: FigmaColors.navy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select City',
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text(
              'Confirm the selected region to continue',
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: FigmaColors.accentBlue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city.name,
                          style: const TextStyle(
                            color: FigmaColors.navy,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (city.subtitle != null)
                          Text(
                            city.subtitle!,
                            style: const TextStyle(color: Color(0xFF8A7658), fontSize: 11),
                          ),
                      ],
                    ),
                  ),
                  const Icon(Icons.check, color: FigmaColors.accentBlue),
                ],
              ),
            ),
            const SizedBox(height: 18),
            FigmaButton(
              label: 'Confirm City',
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ),
    );
  }
}
