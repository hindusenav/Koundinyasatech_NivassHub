import 'home_data_model.dart';

class HomeResponseModel {
  final bool success;
  final String message;
  final HomeDataModel data;

  const HomeResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) {
    return HomeResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: HomeDataModel.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}