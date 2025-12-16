import 'package:app/helpers/constants.dart';
import 'package:intl/intl.dart';

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
}
