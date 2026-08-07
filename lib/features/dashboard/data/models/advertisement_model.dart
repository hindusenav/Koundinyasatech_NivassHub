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
      bannerId: json['bannerId'] as String? ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? json['imageUrl'] as String? ?? '',
      redirectUrl: json['redirectUrl'] as String? ?? '',
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
