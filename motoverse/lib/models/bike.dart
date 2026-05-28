class Bike {
  final String id;
  final String name;
  final String company;
  final String category;
  final String description;
  final double rating;
  final double basePrice;
  final String startingPrice;
  final String? imageUrl;
  final String topSpeed;
  final String range;
  final String power;

  const Bike({
    required this.id,
    required this.name,
    required this.company,
    required this.category,
    required this.description,
    required this.rating,
    required this.basePrice,
    required this.startingPrice,
    this.imageUrl,
    required this.topSpeed,
    required this.range,
    required this.power,
  });

  factory Bike.fromJson(String id, Map<String, dynamic> json) {
    return Bike(
      id: id,
      name: json['name'] as String? ?? '',
      company: json['company'] as String? ?? '',
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0.0,
      startingPrice: json['startingPrice'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      topSpeed: json['topSpeed'] as String? ?? '',
      range: json['range'] as String? ?? '',
      power: json['power'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'company': company,
      'category': category,
      'description': description,
      'rating': rating,
      'basePrice': basePrice,
      'startingPrice': startingPrice,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'topSpeed': topSpeed,
      'range': range,
      'power': power,
    };
  }
}
