import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AiApi {
  static const _base =
      'https://chief-complaint-api.alishba-cc-app-2026.workers.dev';

  static Future<Map<String, dynamic>> call(
      String name, Map<String, dynamic> data) async {
    final user = FirebaseAuth.instance.currentUser;
    debugPrint('AiApi[$name] user=${user?.uid}');
    if (user == null) throw Exception('Sign in required.');
    final token = await user.getIdToken();

    try {
      final res = await http.post(
        Uri.parse('$_base/$name'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      debugPrint('AiApi[$name] status=${res.statusCode} body=${res.body}');
      final body = jsonDecode(utf8.decode(res.bodyBytes));
      if (res.statusCode != 200) {
        throw Exception(body['error'] ?? 'Request failed (${res.statusCode})');
      }
      return Map<String, dynamic>.from(body);
    } catch (e) {
      debugPrint('AiApi[$name] ERROR: $e');
      rethrow;
    }
  }
}
