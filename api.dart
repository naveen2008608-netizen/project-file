import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  // =========================================================
  // FASTAPI SERVER URL
  // =========================================================

  // Chrome on same PC:
  static const String baseUrl = 'http://localhost:8000';

  // Android emulator:
  // static const String baseUrl =
  //     'http://10.0.2.2:8000';

  // Physical Android phone:
  // static const String baseUrl =
  //     'http://YOUR_PC_IP:8000';

  // =========================================================
  // LOGIN
  // =========================================================

  static Future<Map<String, dynamic>> login({
    required String userId,
    required String password,
    required String branch,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({
        'user_id': userId,
        'password': password,
        'branch': branch,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Login failed: HTTP ${response.statusCode}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // =========================================================
  // TRACK DEFECTS
  // =========================================================

  static Future<Map<String, dynamic>> getTrackDefects() async {
    final response = await http.get(Uri.parse('$baseUrl/track-defects'));

    if (response.statusCode != 200) {
      throw Exception('Track defect API failed');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // =========================================================
  // TRACK SECTIONS
  // =========================================================

  static Future<Map<String, dynamic>> getTrackSections() async {
    final response = await http.get(Uri.parse('$baseUrl/track-sections'));

    if (response.statusCode != 200) {
      throw Exception('Track section API failed');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // =========================================================
  // BOREWELLS
  // =========================================================

  static Future<Map<String, dynamic>> getBorewells() async {
    final response = await http.get(Uri.parse('$baseUrl/water/borewells'));

    if (response.statusCode != 200) {
      throw Exception('Borewell API failed');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // =========================================================
  // WATER SUMMARY
  // =========================================================

  static Future<Map<String, dynamic>> getWaterSummary() async {
    final response = await http.get(Uri.parse('$baseUrl/water/summary'));

    if (response.statusCode != 200) {
      throw Exception('Water summary API failed');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
