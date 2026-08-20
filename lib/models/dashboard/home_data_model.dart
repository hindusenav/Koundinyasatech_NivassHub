import 'package:flutter_nivasshub/models/dashboard/banner_model.dart';
import 'package:flutter_nivasshub/models/dashboard/quick_action_model.dart';
import 'package:flutter_nivasshub/models/dashboard/user_model.dart';
import 'package:flutter_nivasshub/models/dashboard/visitor_model.dart';

class HomeDataModel {
  final UserModel user;
  final BannerModel banner;
  final List<QuickActionModel> quickActions;
  final String maintenanceMessage;
  final int approvalQueueCount;
  final List<VisitorModel> approvalQueue;

  const HomeDataModel({
    required this.user,
    required this.banner,
    required this.quickActions,
    required this.maintenanceMessage,
    required this.approvalQueueCount,
    required this.approvalQueue,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      user: UserModel.fromJson((json['user'] as Map<String, dynamic>?) ?? {}),
      banner: BannerModel.fromJson(
        (json['banner'] as Map<String, dynamic>?) ?? {},
      ),
      quickActions:
          ((json['quickActions'] as List<dynamic>?) ?? [])
              .map(
                (e) => QuickActionModel.fromJson((e as Map<String, dynamic>)),
              )
              .toList(),
      maintenanceMessage: json['maintenanceMessage'] as String? ?? '',
      approvalQueueCount: (json['approvalQueueCount'] as num?)?.toInt() ?? 0,
      approvalQueue:
          ((json['approvalQueue'] as List<dynamic>?) ?? [])
              .map((e) => VisitorModel.fromJson((e as Map<String, dynamic>)))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'banner': banner.toJson(),
      'quickActions': quickActions.map((e) => e.toJson()).toList(),
      'maintenanceMessage': maintenanceMessage,
      'approvalQueueCount': approvalQueueCount,
      'approvalQueue': approvalQueue.map((e) => e.toJson()).toList(),
    };
  }
}