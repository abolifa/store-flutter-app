class Store {
  final int id;
  final String name;
  final String? logo;
  final String? description;
  final String? banner;
  final String? primaryPhone;
  final String? secondaryPhone;
  final String? email;
  final String? address;
  final String? city;
  final String? facebook;
  final String? twitter;
  final String? instagram;
  final DateTime? createdAt;

  Store({
    required this.id,
    required this.name,
    this.logo,
    this.description,
    this.banner,
    this.primaryPhone,
    this.secondaryPhone,
    this.email,
    this.address,
    this.city,
    this.facebook,
    this.twitter,
    this.instagram,
    this.createdAt,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      description: json['description'],
      banner: json['banner'],
      primaryPhone: json['primary_phone'],
      secondaryPhone: json['secondary_phone'],
      email: json['email'],
      address: json['address'],
      city: json['city'],
      facebook: json['facebook'],
      twitter: json['twitter'],
      instagram: json['instagram'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'description': description,
      'banner': banner,
      'primary_phone': primaryPhone,
      'secondary_phone': secondaryPhone,
      'email': email,
      'address': address,
      'city': city,
      'facebook': facebook,
      'twitter': twitter,
      'instagram': instagram,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
