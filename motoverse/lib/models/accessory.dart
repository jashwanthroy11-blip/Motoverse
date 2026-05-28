class Accessory {
  final String id;
  final String name;
  final String category;
  final String type;
  final double price;
  final String description;
  final String? imageUrl;

  const Accessory({
    required this.id,
    required this.name,
    required this.category,
    required this.type,
    required this.price,
    required this.description,
    this.imageUrl,
  });

  factory Accessory.fromJson(String id, Map<String, dynamic> json) {
    return Accessory(
      id: id,
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      type: json['type'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'type': type,
      'price': price,
      'description': description,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}
