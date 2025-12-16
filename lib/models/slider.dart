class SliderModel {
  final int id;
  final String image;
  final String? url;
  final String type;
  final int? order;

  SliderModel({
    required this.id,
    required this.image,
    this.url,
    required this.type,
    this.order,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'],
      image: json['image'],
      url: json['url'],
      type: json['type'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'image': image, 'url': url, 'type': type, 'order': order};
  }
}
