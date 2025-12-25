import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app/helpers/constants.dart';
import 'package:app/services/api_exeption.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _tokenKey = "auth_token";
  static const Duration _timeout = Duration(seconds: 10);

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) ?? '';
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

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

  static Never _handleError(Object e) {
    if (e is ApiException) throw e;

    if (e is TimeoutException) {
      throw ApiException(
        'تعذر الاتصال بالخادم',
        isTimeout: true,
        isNetwork: true,
      );
    }

    if (e is SocketException) {
      throw ApiException('لا يوجد اتصال بالإنترنت', isNetwork: true);
    }

    throw ApiException('حدث خطأ غير متوقع');
  }

  static Future<http.Response> get(
    String endpoint, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final cleanParams = params?.map(
        (key, value) => MapEntry(key, value?.toString() ?? ''),
      );

      final uri = Uri.parse(
        "${Constants.apiUrl}$endpoint",
      ).replace(queryParameters: cleanParams);

      final headers = await _headers();
      return await http.get(uri, headers: headers).timeout(_timeout);
    } catch (e) {
      _handleError(e);
    }
  }

  static Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final url = Uri.parse("${Constants.apiUrl}$endpoint");
      final headers = await _headers();
      return await http
          .post(url, headers: headers, body: jsonEncode(data ?? {}))
          .timeout(_timeout);
    } catch (e) {
      _handleError(e);
    }
  }

  static Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final url = Uri.parse("${Constants.apiUrl}$endpoint");
      final headers = await _headers();
      return await http
          .put(url, headers: headers, body: jsonEncode(data ?? {}))
          .timeout(_timeout);
    } catch (e) {
      _handleError(e);
    }
  }

  static Future<http.Response> delete(String endpoint) async {
    try {
      final url = Uri.parse("${Constants.apiUrl}$endpoint");
      final headers = await _headers();
      return await http.delete(url, headers: headers).timeout(_timeout);
    } catch (e) {
      _handleError(e);
    }
  }

  static Future<http.Response> getUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      final headers = await _headers();
      return await http.get(uri, headers: headers).timeout(_timeout);
    } catch (e) {
      _handleError(e);
    }
  }

  static Future<Uint8List> getPdfBytes(String endpoint) async {
    try {
      final uri = Uri.parse("${Constants.apiUrl}$endpoint");
      final headers = await _headers();
      headers.remove("Content-Type");
      headers["Accept"] = "application/pdf";

      final res = await http.get(uri, headers: headers).timeout(_timeout);
      if (res.statusCode == 200) return res.bodyBytes;

      throw ApiException('فشل تحميل الملف');
    } catch (e) {
      _handleError(e);
    }
  }
}
