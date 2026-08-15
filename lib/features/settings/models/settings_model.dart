class SettingsModel {
  final bool notificationPreferences;
  final bool securityAlerts;
  final bool feedSettings;
  final String activePlan;

  SettingsModel({
    required this.notificationPreferences,
    required this.securityAlerts,
    required this.feedSettings,
    required this.activePlan,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      notificationPreferences: json['notificationPreferences'] ?? true,
      securityAlerts: json['securityAlerts'] ?? true,
      feedSettings: json['feedSettings'] ?? true,
      activePlan: json['activePlan'] ?? 'Ad-Supported',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationPreferences': notificationPreferences,
      'securityAlerts': securityAlerts,
      'feedSettings': feedSettings,
      'activePlan': activePlan,
    };
  }

  SettingsModel copyWith({
    bool? notificationPreferences,
    bool? securityAlerts,
    bool? feedSettings,
    String? activePlan,
  }) {
    return SettingsModel(
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
      securityAlerts: securityAlerts ?? this.securityAlerts,
      feedSettings: feedSettings ?? this.feedSettings,
      activePlan: activePlan ?? this.activePlan,
    );
  }
}