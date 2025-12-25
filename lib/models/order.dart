import 'package:app/helpers/helpers.dart';
import 'package:app/models/store.dart';

class Order {
  final int id;
  final int customerId;
  final int addressId;
  final int? couponId;
  final int paymentMethodId;
  final String status;
  final String? currency;
  final double subtotal;
  final double discount;
  final double tax;
  final double deliveryFees;
  final double total;
  final DateTime? paidAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem>? items;
  final List<RelatedStore>? stores;
  final Payment? payment;
  final RelatedAddress? address;

  Order({
    required this.id,
    required this.customerId,
    required this.addressId,
    this.couponId,
    required this.paymentMethodId,
    required this.status,
    this.currency,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.deliveryFees,
    required this.total,
    this.paidAt,
    required this.createdAt,
    required this.updatedAt,
    this.items,
    this.stores,
    this.payment,
    this.address,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerId: json['customer_id'],
      addressId: json['address_id'],
      couponId: json['coupon_id'],
      paymentMethodId: json['payment_method_id'],
      status: json['status'],
      currency: json['currency'],
      subtotal: Helpers.toDoubleOrZero(json['subtotal']),
      discount: Helpers.toDoubleOrZero(json['discount']),
      tax: Helpers.toDoubleOrZero(json['tax']),
      deliveryFees: Helpers.toDoubleOrZero(json['delivery_fees']),
      total: Helpers.toDoubleOrZero(json['total']),
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      items: json['items'] != null
          ? (json['items'] as List)
                .map((item) => OrderItem.fromJson(item))
                .toList()
          : null,
      stores: json['stores'] != null
          ? (json['stores'] as List)
                .map((store) => RelatedStore.fromJson(store))
                .toList()
          : null,
      payment: json['payment'] != null
          ? Payment.fromJson(Map<String, dynamic>.from(json['payment']))
          : null,
      address: json['address'] != null
          ? RelatedAddress.fromJson(Map<String, dynamic>.from(json['address']))
          : null,
    );
  }
}

class OrderItem {
  final int id;
  final String? productName;
  final double unitPrice;
  final double discount;
  final int quantity;
  final double total;
  final RelatedVariant? productVariant;

  OrderItem({
    required this.id,
    this.productName,
    required this.unitPrice,
    required this.discount,
    required this.quantity,
    required this.total,
    this.productVariant,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      productName: json['product_name'],
      unitPrice: Helpers.toDoubleOrZero(json['unit_price']),
      discount: Helpers.toDoubleOrZero(json['discount']),
      quantity: json['quantity'],
      total: Helpers.toDoubleOrZero(json['total']),
      productVariant: json['product_variant'] != null
          ? RelatedVariant.fromJson(
              Map<String, dynamic>.from(json['product_variant']),
            )
          : null,
    );
  }
}

class RelatedVariant {
  final int id;
  final String? image;
  RelatedVariant({required this.id, this.image});
  factory RelatedVariant.fromJson(Map<String, dynamic> json) {
    return RelatedVariant(id: json['id'], image: json['image']);
  }
}

class RelatedStore {
  final int id;
  final int orderId;
  final int storeId;
  final Store store;
  RelatedStore({
    required this.id,
    required this.orderId,
    required this.storeId,
    required this.store,
  });
  factory RelatedStore.fromJson(Map<String, dynamic> json) {
    return RelatedStore(
      id: json['id'],
      orderId: json['order_id'],
      storeId: json['store_id'],
      store: Store.fromJson(Map<String, dynamic>.from(json['store'])),
    );
  }
}

class Payment {
  final int id;
  final int orderId;
  final int paymentMethodId;
  final String status;
  final Method paymentMethod;

  Payment({
    required this.id,
    required this.orderId,
    required this.paymentMethodId,
    required this.status,
    required this.paymentMethod,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      orderId: json['order_id'],
      paymentMethodId: json['payment_method_id'],
      status: json['status'],
      paymentMethod: Method.fromJson(
        Map<String, dynamic>.from(json['payment_method']),
      ),
    );
  }
}

class Method {
  final int id;
  final String name;
  final String code;
  Method({required this.id, required this.name, required this.code});

  factory Method.fromJson(Map<String, dynamic> json) {
    return Method(id: json['id'], name: json['name'], code: json['code']);
  }
}

class RelatedAddress {
  final int id;
  final String street;
  final String landmark;

  RelatedAddress({
    required this.id,
    required this.street,
    required this.landmark,
  });

  factory RelatedAddress.fromJson(Map<String, dynamic> json) {
    return RelatedAddress(
      id: json['id'],
      street: json['street'],
      landmark: json['landmark'],
    );
  }
}
