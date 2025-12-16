import 'package:app/models/product.dart';

class Section {
  final int id;
  final String title;
  final String? shortDescription;
  final String? color;
  final List<Product>? products;

  Section({
    required this.id,
    required this.title,
    this.shortDescription,
    this.color,
    this.products,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    var productsJson = json['products'] as List<dynamic>?;
    List<Product>? productsList = productsJson
        ?.map((item) => Product.fromJson(item))
        .toList();
    return Section(
      id: json['id'],
      title: json['title'],
      shortDescription: json['short_description'],
      color: json['color'],
      products: productsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'short_description': shortDescription,
      'color': color,
      'products': products?.map((product) => product.toJson()).toList(),
    };
  }
}
