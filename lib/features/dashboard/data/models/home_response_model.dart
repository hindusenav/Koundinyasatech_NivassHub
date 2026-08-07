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
      success: json['status'] == 'success' || (json['success'] == true),
      message: json['message'] as String? ?? '',
      data: HomeDataModel.fromJson(
        (json['data'] as Map<String, dynamic>?) ?? {},
      ),
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