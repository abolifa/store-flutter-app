import 'package:app/helpers/helpers.dart';

class Unit {
  final int id;
  final String? name;
  final String symbol;
  final double? conversionFactor;

  Unit({
    required this.id,
    this.name,
    required this.symbol,
    this.conversionFactor,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      conversionFactor: Helpers.toDouble(json['conversion_factor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'conversion_factor': conversionFactor,
    };
  }
}
