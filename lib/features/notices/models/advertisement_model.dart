class AdvertisementModel {
  final String bannerId;
  final String title;
  final String image;
  final String redirectUrl;
  final String description;

  const AdvertisementModel({
    required this.bannerId,
    required this.title,
    required this.image,
    required this.redirectUrl,
    this.description = '',
  });

  /// Alias for [bannerId] — feed widgets key list items by `id` regardless
  /// of feed item type.
  String get id => bannerId;

  /// Alias for [image] — matches the `imageUrl` naming other feed models use.
  String get imageUrl => image;

  factory AdvertisementModel.fromJson(Map<String, dynamic> json) {
    return AdvertisementModel(
      bannerId: json['bannerId'] ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      redirectUrl: json['redirectUrl'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bannerId': bannerId,
      'title': title,
      'image': image,
      'redirectUrl': redirectUrl,
      'description': description,
    };
  }
}
