class Brand {
  final int id;
  final String name;
  final String? image;
  final int? order;

  Brand({required this.id, required this.name, this.image, this.order});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image, 'order': order};
  }
}
