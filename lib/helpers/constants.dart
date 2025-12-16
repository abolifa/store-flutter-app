import 'package:flutter/material.dart';

class Constants {
  static const String apiUrl = "http://10.0.2.2:8000/api";
  static const String imageUrl = "http://10.0.2.2:8000/storage/";
  static const Color scaffoldBackgroundColor = Color.fromRGBO(241, 244, 253, 1);
  static BoxShadow boxShadow = BoxShadow(
    color: Colors.grey.withValues(alpha: 0.1),
    spreadRadius: 2,
    blurRadius: 5,
    offset: const Offset(0, 3),
  );
}
