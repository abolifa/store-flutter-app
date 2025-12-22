class PaymentMethod {
  final int id;
  final String name;
  final String? code;
  final bool isOnline;
  final bool returnable;

  PaymentMethod({
    required this.id,
    required this.name,
    this.code,
    required this.isOnline,
    required this.returnable,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      isOnline: json['is_online'],
      returnable: json['returnable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'is_online': isOnline,
      'returnable': returnable,
    };
  }
}
