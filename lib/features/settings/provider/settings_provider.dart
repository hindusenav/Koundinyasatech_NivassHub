import 'package:flutter/material.dart';

class SettingsModel {
  final String userName;
  final String hubId;
  final int familyCount;
  final int dailyHelpCount;
  final int vehicleCount;
  final int petCount;
  final String currentFlat;

  SettingsModel({
    this.userName = 'Resident',
    this.hubId = 'NH-101',
    this.familyCount = 0,
    this.dailyHelpCount = 0,
    this.vehicleCount = 0,
    this.petCount = 0,
    this.currentFlat = 'Flat A-101',
  });
}

class SettingsProvider extends ChangeNotifier {
  SettingsModel _settings = SettingsModel();
  bool _isLoading = false;

  SettingsModel get settings => _settings;
  bool get isLoading => _isLoading;

  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    // Simulate quick loading delay
    await Future.delayed(const Duration(milliseconds: 200));

    _isLoading = false;
    notifyListeners();
  }

  void addFamilyMember() {
    _settings = SettingsModel(
      userName: _settings.userName,
      hubId: _settings.hubId,
      familyCount: _settings.familyCount + 1,
      dailyHelpCount: _settings.dailyHelpCount,
      vehicleCount: _settings.vehicleCount,
      petCount: _settings.petCount,
      currentFlat: _settings.currentFlat,
    );
    notifyListeners();
  }

  void addDailyHelp() {
    _settings = SettingsModel(
      userName: _settings.userName,
      hubId: _settings.hubId,
      familyCount: _settings.familyCount,
      dailyHelpCount: _settings.dailyHelpCount + 1,
      vehicleCount: _settings.vehicleCount,
      petCount: _settings.petCount,
      currentFlat: _settings.currentFlat,
    );
    notifyListeners();
  }

  void addVehicle() {
    _settings = SettingsModel(
      userName: _settings.userName,
      hubId: _settings.hubId,
      familyCount: _settings.familyCount,
      dailyHelpCount: _settings.dailyHelpCount,
      vehicleCount: _settings.vehicleCount + 1,
      petCount: _settings.petCount,
      currentFlat: _settings.currentFlat,
    );
    notifyListeners();
  }

  void addPet() {
    _settings = SettingsModel(
      userName: _settings.userName,
      hubId: _settings.hubId,
      familyCount: _settings.familyCount,
      dailyHelpCount: _settings.dailyHelpCount,
      vehicleCount: _settings.vehicleCount,
      petCount: _settings.petCount + 1,
      currentFlat: _settings.currentFlat,
    );
    notifyListeners();
  }

  void updateFlat(String newFlat) {
    _settings = SettingsModel(
      userName: _settings.userName,
      hubId: _settings.hubId,
      familyCount: _settings.familyCount,
      dailyHelpCount: _settings.dailyHelpCount,
      vehicleCount: _settings.vehicleCount,
      petCount: _settings.petCount,
      currentFlat: newFlat,
    );
    notifyListeners();
  }
}