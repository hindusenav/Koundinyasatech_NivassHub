import 'dart:convert';

import 'package:flutter/services.dart';

class DashboardService {
  const DashboardService();

  Future<Map<String, dynamic>> loadJson(String path) async {
    await Future.delayed(const Duration(seconds: 2));

    final jsonString = await rootBundle.loadString(path);

    return json.decode(jsonString) as Map<String, dynamic>;
  }
}