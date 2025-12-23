import 'package:app/helpers/helpers.dart';
import 'package:app/models/brand.dart';
import 'package:app/models/perk.dart';
import 'package:app/models/store.dart';
import 'package:app/models/unit.dart';

class Product {
  final int id;
  final int? brandId;
  final int? storeId;
  final String name;
  final String slug;
  final String? description;
  final String? image;
  final List<String>? images;
  final bool isFeatured;
  final List<Perk>? perks;
  final String? manufacturer;
  final String? madeIn;
  final String status;
  final String? imageHash;
  final double? approvedReviewsAvgRating;
  final int? approvedReviewsCount;
  final Brand? brand;
  final List<ProductVariant>? variants;
  final Store? store;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.image,
    this.images,
    this.brandId,
    this.storeId,
    this.isFeatured = false,
    this.perks,
    this.manufacturer,
    this.madeIn,
    required this.status,
    this.imageHash,
    this.approvedReviewsAvgRating,
    this.approvedReviewsCount,
    this.brand,
    this.variants,
    this.store,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      image: json['image'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      brandId: json['brand_id'],
      storeId: json['store_id'],
      isFeatured: json['is_featured'] ?? false,
      perks: json['perks'] != null
          ? (json['perks'] as List).map((perk) => Perk.fromJson(perk)).toList()
          : null,
      manufacturer: json['manufacturer'],
      madeIn: json['made_in'],
      status: json['status'],
      imageHash: json['image_hash'],
      approvedReviewsAvgRating: json['approved_reviews_avg_rating'] != null
          ? Helpers.toDouble(json['approved_reviews_avg_rating'])
          : null,
      approvedReviewsCount: json['approved_reviews_count'],
      brand: json['brand'] != null ? Brand.fromJson(json['brand']) : null,
      variants: json['variants'] != null
          ? (json['variants'] as List)
                .map((variant) => ProductVariant.fromJson(variant))
                .toList()
          : null,
      store: json['store'] != null ? Store.fromJson(json['store']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'image': image,
      'images': images,
      'brand_id': brandId,
      'store_id': storeId,
      'is_featured': isFeatured,
      'perks': perks?.map((perk) => perk.toJson()).toList(),
      'manufacturer': manufacturer,
      'made_in': madeIn,
      'status': status,
      'image_hash': imageHash,
      'approved_reviews_avg_rating': approvedReviewsAvgRating,
      'approved_reviews_count': approvedReviewsCount,
      'brand': brand?.toJson(),
      'variants': variants?.map((variant) => variant.toJson()).toList(),
      'store': store?.toJson(),
    };
  }
}

class ProductVariant {
  final int id;
  final int productId;
  final String? sku;
  final String? measurement;
  final String? color;
  final String? barcode;
  final String? image;
  final double price;
  final double? discount;
  final int? unitId;
  final Unit? unit;
  final Product? product;

  ProductVariant({
    required this.id,
    required this.productId,
    this.sku,
    this.measurement,
    this.color,
    this.barcode,
    this.image,
    required this.price,
    this.discount,
    this.unitId,
    this.unit,
    this.product,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'],
      productId: json['product_id'],
      sku: json['sku'],
      measurement: json['measurement'],
      color: json['color'],
      barcode: json['barcode'],
      image: json['image'],
      price: Helpers.toDoubleOrZero(json['price']),
      discount: json['discount'] != null
          ? Helpers.toDouble(json['discount'])
          : null,
      unitId: json['unit_id'],
      unit: json['unit'] != null ? Unit.fromJson(json['unit']) : null,
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'sku': sku,
      'measurement': measurement,
      'color': color,
      'barcode': barcode,
      'image': image,
      'price': price,
      'discount': discount,
      'unit_id': unitId,
      'unit': unit?.toJson(),
      'product': product?.toJson(),
    };
  }
}
