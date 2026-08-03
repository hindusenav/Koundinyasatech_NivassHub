import 'banner_model.dart';
import 'quick_action_model.dart';
import 'user_model.dart';
import 'visitor_model.dart';

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
      user: UserModel.fromJson(json['user']),
      banner: BannerModel.fromJson(json['banner']),
      quickActions: (json['quickActions'] as List)
          .map((e) => QuickActionModel.fromJson(e))
          .toList(),
      maintenanceMessage: json['maintenanceMessage'] as String,
      approvalQueueCount: json['approvalQueueCount'] as int,
      approvalQueue: (json['approvalQueue'] as List)
          .map((e) => VisitorModel.fromJson(e))
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