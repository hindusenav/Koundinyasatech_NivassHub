class QuickActionModel {
  final int id;
  final String name;
  final String icon;

  const QuickActionModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory QuickActionModel.fromJson(Map<String, dynamic> json) {
    return QuickActionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String,
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