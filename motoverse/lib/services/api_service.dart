import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();

  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'https://api.motoverse.example.com';

  static Future<http.Response> get(String path, {Map<String, String>? headers}) {
    return http.get(Uri.parse('$baseUrl$path'), headers: _defaultHeaders(headers));
  }

  static Future<http.Response> post(String path,
      {Map<String, String>? headers, Object? body}) {
    return http.post(
      Uri.parse('$baseUrl$path'),
      headers: _defaultHeaders(headers),
      body: jsonEncode(body),
    );
  }

  static Map<String, String> _defaultHeaders(Map<String, String>? headers) {
    return {
      'Content-Type': 'application/json',
      ...?headers,
    };
  }
}
