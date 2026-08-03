class BannerModel {
  final String bannerId;
  final String title;
  final String image;

  const BannerModel({
    required this.bannerId,
    required this.title,
    required this.image,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      bannerId: json['bannerId'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bannerId': bannerId,
      'title': title,
      'image': image,
    };
  }
}