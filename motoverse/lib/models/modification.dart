import 'package:cloud_firestore/cloud_firestore.dart';

class Modification {
  final String id;
  final String title;
  final String notes;
  final String? imageUrl;
  final DateTime timestamp;

  const Modification({
    required this.id,
    required this.title,
    required this.notes,
    this.imageUrl,
    required this.timestamp,
  });

  factory Modification.fromJson(String id, Map<String, dynamic> json) {
    return Modification(
      id: id,
      title: json['title'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'notes': notes,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  Map<String, dynamic> toJsonWithTimestamp() {
    return {
      ...toJson(),
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
