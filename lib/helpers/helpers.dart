import 'dart:io';

import 'package:app/helpers/constants.dart';
import 'package:app/modals/map_modal.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

enum ToastType { primary, success, error, info, warning }

class Helpers {
  static double? toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      if (value.isEmpty) return null;
      return double.tryParse(value);
    }
    return null;
  }

  static double toDoubleOrZero(dynamic value) {
    return toDouble(value) ?? 0.0;
  }

  static String getServerImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return 'public/assets/images/placeholder.png';
    }
    return '${Constants.imageUrl}$imageUrl';
  }

  static String formatPriceFixed(double value) {
    final formatter = NumberFormat('#,##0.00', 'en');
    return formatter.format(value);
  }

  static Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '').toUpperCase();
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  static Future<Position> determinePosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('location_services_disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('location_permission_denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('location_permissions_permanently_denied');
    }
    LocationSettings locationSettings;
    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 0,
        forceLocationManager: false,
        intervalDuration: Duration(seconds: 10),
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.medium,
        activityType: ActivityType.fitness,
        distanceFilter: 0,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      );
    }
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
    } catch (e) {
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) return lastKnown;
      throw Exception('failed_to_get_location: $e');
    }
  }

  static void showToast(BuildContext context, String message, ToastType type) {
    Color bgColor;
    switch (type) {
      case ToastType.primary:
        bgColor = Colors.grey.shade800;
        break;
      case ToastType.success:
        bgColor = Colors.green;
        break;
      case ToastType.error:
        bgColor = Colors.red;
        break;
      case ToastType.info:
        bgColor = Colors.blue;
        break;
      case ToastType.warning:
        bgColor = Colors.orange;
        break;
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static Future<Map<String, dynamic>?> showMapModal(
    BuildContext context,
  ) async {
    return await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      enableDrag: false,
      builder: (_) => const MapModal(),
    );
  }

  static Future<void> launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
