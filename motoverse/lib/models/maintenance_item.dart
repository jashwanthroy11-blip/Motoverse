import 'package:cloud_firestore/cloud_firestore.dart';

class MaintenanceItem {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime nextDue;
  final int intervalDays;
  final bool completed;

  const MaintenanceItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.nextDue,
    required this.intervalDays,
    required this.completed,
  });

  factory MaintenanceItem.fromJson(String id, Map<String, dynamic> json) {
    return MaintenanceItem(
      id: id,
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      nextDue: (json['nextDue'] as Timestamp?)?.toDate() ?? DateTime.now(),
      intervalDays: json['intervalDays'] as int? ?? 30,
      completed: json['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'nextDue': Timestamp.fromDate(nextDue),
      'intervalDays': intervalDays,
      'completed': completed,
    };
  }
}
