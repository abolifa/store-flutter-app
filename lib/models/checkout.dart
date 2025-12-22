import 'package:app/helpers/helpers.dart';

class UndeliverableProduct {
  final int productId;
  final String productName;
  final int variantId;
  final int quantity;

  UndeliverableProduct({
    required this.productId,
    required this.productName,
    required this.variantId,
    required this.quantity,
  });

  factory UndeliverableProduct.fromJson(Map<String, dynamic> json) {
    return UndeliverableProduct(
      productId: json['product_id'],
      productName: json['product_name'],
      variantId: json['variant_id'],
      quantity: json['quantity'],
    );
  }
}

class CheckoutStore {
  final int storeId;
  final String storeName;
  final String status;
  final double deliveryFee;
  final double subtotal;
  final double? distanceKm;
  final List<UndeliverableProduct> undeliverableProducts;

  CheckoutStore({
    required this.storeId,
    required this.storeName,
    required this.status,
    required this.deliveryFee,
    required this.subtotal,
    required this.distanceKm,
    required this.undeliverableProducts,
  });

  bool get isDeliverable => status == 'deliverable';

  factory CheckoutStore.fromJson(Map<String, dynamic> json) {
    return CheckoutStore(
      storeId: json['store_id'],
      storeName: json['store_name'],
      status: json['status'] ?? 'deliverable',
      deliveryFee: Helpers.toDoubleOrZero(json['delivery_fee']),
      subtotal: Helpers.toDoubleOrZero(json['subtotal']),
      distanceKm: json['distance_km'] == null
          ? null
          : Helpers.toDoubleOrZero(json['distance_km']),
      undeliverableProducts: (json['undeliverable_products'] as List? ?? [])
          .map((e) => UndeliverableProduct.fromJson(e))
          .toList(),
    );
  }
}

class CheckoutSummary {
  final double subtotal;
  final double delivery;
  final double discount;
  final double tax;
  final double total;

  CheckoutSummary({
    required this.subtotal,
    required this.delivery,
    required this.discount,
    required this.tax,
    required this.total,
  });

  factory CheckoutSummary.fromJson(Map<String, dynamic> json) {
    return CheckoutSummary(
      subtotal: Helpers.toDoubleOrZero(json['subtotal']),
      delivery: Helpers.toDoubleOrZero(json['delivery']),
      discount: Helpers.toDoubleOrZero(json['discount']),
      tax: Helpers.toDoubleOrZero(json['tax']),
      total: Helpers.toDoubleOrZero(json['total']),
    );
  }
}

class CheckoutResponse {
  final List<CheckoutStore> stores;
  final CheckoutSummary summary;

  CheckoutResponse({required this.stores, required this.summary});

  bool get hasUndeliverableStores =>
      stores.any((store) => !store.isDeliverable);

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      stores: (json['stores'] as List)
          .map((e) => CheckoutStore.fromJson(e))
          .toList(),
      summary: CheckoutSummary.fromJson(json['summary']),
    );
  }
}
