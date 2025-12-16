class Category {
  final int id;
  final String name;
  final String? image;
  final int? order;
  final int? parentId;
  final Category? parent;
  final List<Category>? children;

  Category({
    required this.id,
    required this.name,
    this.image,
    this.order,
    this.parentId,
    this.parent,
    this.children,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      order: json['order'],
      parentId: json['parent_id'],
      parent: json['parent'] != null ? Category.fromJson(json['parent']) : null,
      children: json['children'] != null
          ? List<Category>.from(
              json['children'].map((child) => Category.fromJson(child)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'order': order,
      'parent_id': parentId,
      'parent': parent?.toJson(),
      'children': children?.map((child) => child.toJson()).toList(),
    };
  }
}
