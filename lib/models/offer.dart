class Offer {
  final int id;
  final String image;
  final String position;
  final String type;
  final String? url;
  final int? sectionId;

  Offer({
    required this.id,
    required this.image,
    required this.position,
    this.sectionId,
    required this.type,
    this.url,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      image: json['image'],
      position: json['position'],
      sectionId: json['section_id'],
      type: json['type'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'position': position,
      'section_id': sectionId,
      'type': type,
      'url': url,
    };
  }
}
