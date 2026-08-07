class QuickActionModel {
  final dynamic id;
  final String name;
  final String icon;

  const QuickActionModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory QuickActionModel.fromJson(Map<String, dynamic> json) {
    return QuickActionModel(
      id: json['id'] ?? 0,
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}