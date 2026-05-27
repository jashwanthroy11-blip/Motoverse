import 'package:cloud_firestore/cloud_firestore.dart';

class Bike {
  final String id;
  final String name;
  final String category;
  final String description;
  final String topSpeed;
  final String range;
  final String power;
  final String? imageUrl;
  final Timestamp? createdAt;

  const Bike({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.topSpeed,
    required this.range,
    required this.power,
    this.imageUrl,
    this.createdAt,
  });

  factory Bike.fromJson(String id, Map<String, dynamic> json) {
    return Bike(
      id: id,
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      topSpeed: json['topSpeed'] as String? ?? '',
      range: json['range'] as String? ?? '',
      power: json['power'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'topSpeed': topSpeed,
      'range': range,
      'power': power,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  Map<String, dynamic> toJsonWithTimestamp() {
    return {
      ...toJson(),
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
