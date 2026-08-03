class AddressModel {
  final String addressId;
  final String flatNumber;
  final String societyName;
  final bool isDefault;

  const AddressModel({
    required this.addressId,
    required this.flatNumber,
    required this.societyName,
    required this.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json['addressId'] as String,
      flatNumber: json['flatNumber'] as String,
      societyName: json['societyName'] as String,
      isDefault: json['isDefault'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressId': addressId,
      'flatNumber': flatNumber,
      'societyName': societyName,
      'isDefault': isDefault,
    };
  }
}