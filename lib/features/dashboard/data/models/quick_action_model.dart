import 'package:flutter/material.dart';

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
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }

  /// Returns the local asset image based on the API icon name.
  String get assetPath {
  switch (icon.toLowerCase()) {
    case 'preapprove':
      return 'assets/icons/quick_actions/pre_approve.png';

    case 'payments':
      return 'assets/icons/quick_actions/payments.png';

    case 'posts':
      return 'assets/icons/quick_actions/posts.png';

    case 'security':
      return 'assets/icons/quick_actions/security.png';

    case 'book':
      return 'assets/icons/quick_actions/book_now.png';

    case 'directory':
      return 'assets/icons/quick_actions/directory.png';

    case 'gift':
      return 'assets/icons/quick_actions/free_trial.png';

    case 'plus':
      return 'assets/icons/quick_actions/view_more.png';

    default:
      return 'assets/icons/quick_actions/pre_approve.png';
  }
}

  bool get isViewMore =>
      icon.toLowerCase() == 'viewmore' ||
      icon.toLowerCase() == 'view_more' ||
      icon.toLowerCase() == 'view-more';

  Color get backgroundColor =>
      isViewMore ? const Color(0xFFF9A825) : Colors.white;
}