import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/// Small shared helper for mock data sources that read a bundled JSON asset
/// (`assets/json/*.json`) instead of calling a real API. Kept in `core/utils`
/// rather than duplicated per-feature since more than one feature's mock
/// service needs it.
class JsonAssetLoader {
  JsonAssetLoader._();

  static Future<Map<String, dynamic>> loadMap(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    return json.decode(raw) as Map<String, dynamic>;
  }

  static Future<List<dynamic>> loadList(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    return json.decode(raw) as List<dynamic>;
  }
}
