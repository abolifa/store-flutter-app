import 'package:app/helpers/helpers.dart';

class Review {
  final int id;
  final int? customerId;
  final int? productId;
  final double rating;
  final String? comment;
  final DateTime createdAt;
  final ReviewUser? customer;

  Review({
    required this.id,
    this.customerId,
    this.productId,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.customer,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      customerId: json['customer_id'],
      productId: json['product_id'],
      rating: Helpers.toDoubleOrZero(json['rating']),
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
      customer: json['customer'] != null
          ? ReviewUser.fromJson(json['customer'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'product_id': productId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'customer': customer?.toJson(),
    };
  }
}

class ReviewUser {
  final int id;
  final String name;
  final String? avatar;
  final DateTime? createdAt;
  ReviewUser({
    required this.id,
    required this.name,
    this.avatar,
    this.createdAt,
  });
  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
