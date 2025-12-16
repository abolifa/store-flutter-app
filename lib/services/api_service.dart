import 'dart:convert';
import 'dart:typed_data';

import 'package:app/helpers/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _tokenKey = "auth_token";

  /// 🔹 Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// 🔹 Get token
  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) ?? '';
  }

  /// 🔹 Clear token
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// 🔹 Common headers with Authorization
  static Future<Map<String, String>> _headers() async {
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    final token = await getToken();
    if (token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }

  /// 🔹 GET request
  static Future<http.Response> get(
    String endpoint, {
    Map<String, dynamic>? params,
  }) async {
    final cleanParams = params?.map(
      (key, value) => MapEntry(key, value?.toString() ?? ''),
    );

    final uri = Uri.parse(
      "${Constants.apiUrl}$endpoint",
    ).replace(queryParameters: cleanParams);

    final headers = await _headers();
    return await http.get(uri, headers: headers);
  }

  /// 🔹 POST request
  static Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    final url = Uri.parse("${Constants.apiUrl}$endpoint");
    final headers = await _headers();
    return await http.post(url, headers: headers, body: jsonEncode(data ?? {}));
  }

  /// 🔹 PUT request
  static Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    final url = Uri.parse("${Constants.apiUrl}$endpoint");
    final headers = await _headers();
    return await http.put(url, headers: headers, body: jsonEncode(data ?? {}));
  }

  /// 🔹 DELETE request
  static Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse("${Constants.apiUrl}$endpoint");
    final headers = await _headers();
    return await http.delete(url, headers: headers);
  }

  /// 🔹 Direct full URL GET (used for external links)
  static Future<http.Response> getUrl(String url) async {
    final uri = Uri.parse(url);
    final headers = await _headers();
    return await http.get(uri, headers: headers);
  }

  static Future<Uint8List> getPdfBytes(String endpoint) async {
    final uri = Uri.parse("${Constants.apiUrl}$endpoint");
    final headers = await _headers();
    headers.remove("Content-Type");
    headers["Accept"] = "application/pdf";
    final res = await http.get(uri, headers: headers);
    if (res.statusCode == 200) return res.bodyBytes;
    throw Exception('HTTP ${res.statusCode}');
  }
}
