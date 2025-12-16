import 'package:app/helpers/helpers.dart';

class HomeProduct {
  final int id;
  final String name;
  final String slug;
  final String? image;
  final List<String>? images;
  final String? brandName;
  final String? storeName;
  final bool isFeatured;
  final String status;
  final double price;
  final double? discount;
  final List<Perk>? perks;
  final double? rating;
  final int? reviewsCount;
  final int? variantsCount;

  HomeProduct({
    required this.id,
    required this.name,
    required this.slug,
    this.image,
    this.images,
    this.brandName,
    this.storeName,
    required this.isFeatured,
    required this.status,
    required this.price,
    this.discount,
    this.perks,
    this.rating,
    this.reviewsCount,
    this.variantsCount,
  });

  factory HomeProduct.fromJson(Map<String, dynamic> json) {
    return HomeProduct(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      image: json['image'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      brandName: json['brand_name'],
      storeName: json['store_name'],
      isFeatured: json['is_featured'] == true,
      status: json['status'],
      price: Helpers.toDoubleOrZero(json['price']),
      discount: Helpers.toDouble(json['discount']),
      perks: json['perks'] != null
          ? List<Perk>.from(json['perks'].map((perk) => Perk.fromJson(perk)))
          : null,
      rating: Helpers.toDouble(json['rating_avg']),
      reviewsCount: json['rating_count'],
      variantsCount: json['variants_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image': image,
      'images': images,
      'brand_name': brandName,
      'store_name': storeName,
      'is_featured': isFeatured,
      'status': status,
      'price': price,
      'discount': discount,
      'perks': perks?.map((perk) => perk.toJson()).toList(),
      'rating': rating,
      'reviews_count': reviewsCount,
      'variants_count': variantsCount,
    };
  }
}

class Perk {
  final String? title;
  final String? color;

  Perk({this.title, this.color});

  factory Perk.fromJson(Map<String, dynamic> json) {
    return Perk(title: json['title'], color: json['color']);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'color': color};
  }
}
