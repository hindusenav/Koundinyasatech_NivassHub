class AddressModel {
  final String flatNo;
  final String society;
  final String wing;
  final String street;
  final String area;
  final String landmark;
  final String city;
  final String state;
  final String pincode;

  AddressModel({
    required this.flatNo,
    required this.society,
    required this.wing,
    required this.street,
    required this.area,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      flatNo: json['flat_no'] ?? json['flatNo'] ?? '',
      society: json['society'] ?? '',
      wing: json['wing'] ?? '',
      street: json['street'] ?? '',
      area: json['area'] ?? '',
      landmark: json['landmark'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? json['pin_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flat_no': flatNo,
      'society': society,
      'wing': wing,
      'street': street,
      'area': area,
      'landmark': landmark,
      'city': city,
      'state': state,
      'pin_code': pincode,
    };
  }
}