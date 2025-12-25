import 'package:flutter/material.dart';

class ColorHelper {
  static Color fromHex(String? hex, {Color fallback = Colors.black}) {
    if (hex == null || hex.isEmpty) return fallback;
    final value = hex.replaceFirst('#', '');
    if (value.length == 6) {
      return Color(int.parse('FF$value', radix: 16));
    }
    if (value.length == 8) {
      return Color(int.parse(value, radix: 16));
    }
    return fallback;
  }
}
