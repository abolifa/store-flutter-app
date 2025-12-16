class Perk {
  final String? title;
  final String? icon;
  final String? color;

  Perk({this.title, this.icon, this.color});

  factory Perk.fromJson(Map<String, dynamic> json) {
    return Perk(title: json['title'], icon: json['icon'], color: json['color']);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'color': color, 'icon': icon};
  }
}
