import 'package:app/helpers/constants.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'NotoKufiArabic',
      scaffoldBackgroundColor: Constants.scaffoldBackgroundColor,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        primary: Colors.black,
        onPrimary: Colors.white,
        secondary: Colors.grey.shade600,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        seedColor: Colors.white,
      ),
    );
  }
}
