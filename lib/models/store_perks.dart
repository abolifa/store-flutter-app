import 'package:app/helpers/helpers.dart';

class StorePerks {
  final String since;
  final int confirmedOrders;
  final int reviewsCount;
  final double reviewsAverage;

  StorePerks({
    required this.since,
    required this.confirmedOrders,
    required this.reviewsCount,
    required this.reviewsAverage,
  });

  factory StorePerks.fromJson(Map<String, dynamic> json) {
    return StorePerks(
      since: json['since'] as String,
      confirmedOrders: json['confirmed_orders'] as int,
      reviewsCount: json['reviews_count'] as int,
      reviewsAverage: Helpers.toDoubleOrZero(json['reviews_average']),
    );
  }
}
