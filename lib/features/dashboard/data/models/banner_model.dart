class BannerModel {
  final String bannerId;
  final String title;
  final String image;
  final String redirectUrl;

  const BannerModel({
    required this.bannerId,
    required this.title,
    required this.image,
    required this.redirectUrl,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      bannerId: json['bannerId'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
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