class AddressModel {
  final String flatNo;
  final String societyName;
  final String wing;
  final String street;
  final String area;
  final String landmark;
  final String city;
  final String state;
  final String pinCode;

  // ✅ Add const here
  const AddressModel({
    this.flatNo = '',
    this.societyName = '',
    this.wing = '',
    this.street = '',
    this.area = '',
    this.landmark = '',
    this.city = '',
    this.state = '',
    this.pinCode = '',
  });

  AddressModel copyWith({
    String? flatNo,
    String? societyName,
    String? wing,
    String? street,
    String? area,
    String? landmark,
    String? city,
    String? state,
    String? pinCode,
  }) {
    return AddressModel(
      flatNo: flatNo ?? this.flatNo,
      societyName: societyName ?? this.societyName,
      wing: wing ?? this.wing,
      street: street ?? this.street,
      area: area ?? this.area,
      landmark: landmark ?? this.landmark,
      city: city ?? this.city,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
    );
  }
}