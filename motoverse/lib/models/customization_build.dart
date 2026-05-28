import 'package:cloud_firestore/cloud_firestore.dart';

class CustomizationBuild {
  final String id;
  final String userId;
  final String bikeId;
  final String bikeName;
  final String primaryImageUrl;
  final List<String> selectedAccessoryIds;
  final double totalPrice;
  final Timestamp createdAt;
  final String buildName;

  const CustomizationBuild({
    required this.id,
    required this.userId,
    required this.bikeId,
    required this.bikeName,
    required this.primaryImageUrl,
    required this.selectedAccessoryIds,
    required this.totalPrice,
    required this.createdAt,
    required this.buildName,
  });

  factory CustomizationBuild.fromJson(String id, Map<String, dynamic> json) {
    return CustomizationBuild(
      id: id,
      userId: json['userId'] as String? ?? '',
      bikeId: json['bikeId'] as String? ?? '',
      bikeName: json['bikeName'] as String? ?? '',
      primaryImageUrl: json['primaryImageUrl'] as String? ?? '',
      selectedAccessoryIds:
          (json['selectedAccessoryIds'] as List<dynamic>?)?.cast<String>() ?? [],
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] as Timestamp? ?? Timestamp.now(),
      buildName: json['buildName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'bikeId': bikeId,
      'bikeName': bikeName,
      'primaryImageUrl': primaryImageUrl,
      'selectedAccessoryIds': selectedAccessoryIds,
      'totalPrice': totalPrice,
      'createdAt': FieldValue.serverTimestamp(),
      'buildName': buildName,
    };
  }
}
