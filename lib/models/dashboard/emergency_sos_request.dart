class EmergencySosRequest {
  final double latitude;
  final double longitude;

  const EmergencySosRequest({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'location': {
        'latitude': latitude,
        'longitude': longitude,
      },
    };
  }
}
