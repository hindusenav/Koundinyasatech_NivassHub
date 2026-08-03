class AdvertisementModel {
  final String bannerId;
  final String title;
  final String image;
  final String redirectUrl;

  const AdvertisementModel({
    required this.bannerId,
    required this.title,
    required this.image,
    required this.redirectUrl,
  });

  factory AdvertisementModel.fromJson(Map<String, dynamic> json) {
    return AdvertisementModel(
      bannerId: json['bannerId'] ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      redirectUrl: json['redirectUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bannerId': bannerId,
      'title': title,
      'image': image,
      'redirectUrl': redirectUrl,
    };
  }
}
