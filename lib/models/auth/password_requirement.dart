/// One rule in the Update Password screen's strength checklist. Declared in
/// display order — [PasswordRequirementList] renders them in `values` order.
enum PasswordRequirement {
  minLength,
  uppercase,
  number,
  specialChar;

  String get label {
    switch (this) {
      case PasswordRequirement.minLength:
        return 'Minimum 8 characters';
      case PasswordRequirement.uppercase:
        return 'At least one uppercase letter';
      case PasswordRequirement.number:
        return 'At least one number';
      case PasswordRequirement.specialChar:
        return 'At least one special character (e.g. @ # \$)';
    }
  }
}

final RegExp _uppercaseRegex = RegExp(r'[A-Z]');
final RegExp _numberRegex = RegExp(r'[0-9]');
final RegExp _specialCharRegex = RegExp(r'''[!@#$&*~%^()\-_=+\[\]{}|;:,.<>?/]''');

/// Single source of truth for password-strength evaluation, consumed both
/// by [PasswordRequirementList] (per-rule pass/fail display) and by
/// `UpdatePasswordScreen`'s submit-button gate (all rules must pass).
Map<PasswordRequirement, bool> evaluatePasswordRequirements(String password) {
  return {
    PasswordRequirement.minLength: password.length >= 8,
    PasswordRequirement.uppercase: _uppercaseRegex.hasMatch(password),
    PasswordRequirement.number: _numberRegex.hasMatch(password),
    PasswordRequirement.specialChar: _specialCharRegex.hasMatch(password),
  };
}
