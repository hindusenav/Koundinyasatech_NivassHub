/// The persisted local-preferences bundle for Settings. Dark mode is
/// intentionally excluded — it lives solely in `ThemeModeProvider` so there
/// is exactly one source of truth for it, rather than two providers each
/// tracking their own copy.
class AppSettingsModel {
  const AppSettingsModel({required this.notificationsEnabled});

  final bool notificationsEnabled;
}
