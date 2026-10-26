/// Turns an ISO 3166-1 alpha-2 code (e.g. `IN`) into its flag emoji (`🇮🇳`).
///
/// Each letter maps to a Unicode regional-indicator symbol, so no flag
/// assets are needed. Returns `null` for anything that is not two A–Z
/// letters, so callers can simply skip the flag.
String? flagEmojiFromIso(String? iso) {
  if (iso == null) return null;
  final code = iso.trim().toUpperCase();
  if (!RegExp(r'^[A-Z]{2}$').hasMatch(code)) return null;
  const base = 0x1F1E6 - 0x41;
  return String.fromCharCodes(code.codeUnits.map((c) => base + c));
}
