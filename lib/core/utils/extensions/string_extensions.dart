/// Common string helpers used across features (validation display,
/// formatting for avatars/lists). Actual field validation for forms lives
/// in `core/validators/form_validators.dart` — these are presentation-only.
extension StringExtensions on String {
  bool get isBlank => trim().isEmpty;

  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Up to two initials for an avatar fallback, e.g. "Reshma Kandregula" -> "RK".
  String toInitials() {
    final parts = trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  bool get isNumeric => RegExp(r'^-?\d+(\.\d+)?$').hasMatch(this);
}

extension NullableStringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
}
