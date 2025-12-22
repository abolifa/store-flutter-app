import 'package:app/helpers/helpers.dart';

class Address {
  final int id;
  final int customerId;
  final int? areaId;
  final String? addressType;
  final String street;
  final String city;
  final String? state;
  final String? postalCode;
  final String? landmark;
  final String? altPhone;
  final double latitude;
  final double longitude;
  final bool isDefault;

  Address({
    required this.id,
    required this.customerId,
    this.areaId,
    this.addressType,
    required this.street,
    required this.city,
    this.state,
    this.postalCode,
    this.landmark,
    this.altPhone,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      customerId: json['customer_id'],
      areaId: json['area_id'],
      addressType: json['address_type'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postal_code'],
      landmark: json['landmark'],
      altPhone: json['alt_phone'],
      latitude: Helpers.toDoubleOrZero(json['latitude']),
      longitude: Helpers.toDoubleOrZero(json['longitude']),
      isDefault: json['is_default'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'area_id': areaId,
      'address_type': addressType,
      'street': street,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'landmark': landmark,
      'alt_phone': altPhone,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
    };
  }

  // copy with method
  Address copyWith({
    int? id,
    int? customerId,
    int? areaId,
    String? addressType,
    String? street,
    String? city,
    String? state,
    String? postalCode,
    String? landmark,
    String? altPhone,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      areaId: areaId ?? this.areaId,
      addressType: addressType ?? this.addressType,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      landmark: landmark ?? this.landmark,
      altPhone: altPhone ?? this.altPhone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
