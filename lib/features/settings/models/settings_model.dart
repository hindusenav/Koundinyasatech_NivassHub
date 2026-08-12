class SettingsModel {
  final String userName;
  final String hubId;
  final int familyCount;
  final int dailyHelpCount;
  final int vehicleCount;
  final int petCount;
  final String currentFlat;

  SettingsModel({
    required this.userName,
    required this.hubId,
    required this.familyCount,
    required this.dailyHelpCount,
    required this.vehicleCount,
    required this.petCount,
    required this.currentFlat,
  });

  SettingsModel copyWith({
    String? userName,
    String? hubId,
    int? familyCount,
    int? dailyHelpCount,
    int? vehicleCount,
    int? petCount,
    String? currentFlat,
  }) {
    return SettingsModel(
      userName: userName ?? this.userName,
      hubId: hubId ?? this.hubId,
      familyCount: familyCount ?? this.familyCount,
      dailyHelpCount: dailyHelpCount ?? this.dailyHelpCount,
      vehicleCount: vehicleCount ?? this.vehicleCount,
      petCount: petCount ?? this.petCount,
      currentFlat: currentFlat ?? this.currentFlat,
    );
  }

  factory SettingsModel.initial() {
    return SettingsModel(
      userName: 'User Name',
      hubId: '000000',
      familyCount: 1,
      dailyHelpCount: 0,
      vehicleCount: 0,
      petCount: 0,
      currentFlat: 'B-402, Golden Residency',
    );
  }
}