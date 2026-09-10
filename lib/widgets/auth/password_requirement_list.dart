import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/models/auth/password_requirement.dart';
import 'package:flutter_nivasshub/widgets/auth/password_requirement_row.dart';

/// Live checklist of the 4 password-strength rules, recomputed from
/// [password] on every rebuild. Stateless — the parent screen triggers a
/// rebuild on each keystroke (`onChanged: (_) => setState(() {})`), the same
/// trick `CreateProfileScreen` already uses to keep its confirm-password
/// validator fresh.
class PasswordRequirementList extends StatelessWidget {
  const PasswordRequirementList({super.key, required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final results = evaluatePasswordRequirements(password);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final requirement in PasswordRequirement.values)
          PasswordRequirementRow(
            requirement: requirement,
            isSatisfied: results[requirement] ?? false,
          ),
      ],
    );
  }
}
