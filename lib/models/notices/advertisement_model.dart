class AdvertisementModel {
  final String bannerId;
  final String title;
  final String subtitle;
  final String price;
  final String image;
  final String redirectUrl;
  final String description;

  const AdvertisementModel({
    required this.bannerId,
    required this.title,
    this.subtitle = '2 & 3 BHK Homes',
    this.price = '₹1.30 Crore Onwards',
    required this.image,
    required this.redirectUrl,
    this.description = '',
  });

  String get id => bannerId;
  String get imageUrl => image;

  factory AdvertisementModel.fromJson(Map<String, dynamic> json) {
    return AdvertisementModel(
      bannerId: json['bannerId']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'ALTURA',
      subtitle: json['subtitle']?.toString() ?? '2 & 3 BHK Homes',
      price: json['price']?.toString() ?? '₹1.30 Crore Onwards',
      image: json['image']?.toString() ?? json['imageUrl']?.toString() ?? '',
      redirectUrl: json['redirectUrl']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'bannerId': bannerId,
    'title': title,
    'subtitle': subtitle,
    'price': price,
    'image': image,
    'redirectUrl': redirectUrl,
    'description': description,
  };
}
