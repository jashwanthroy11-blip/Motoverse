import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/customization_build.dart';
import '../services/firebase_service.dart';

class GarageRepository {
  final FirebaseFirestore _firestore = FirebaseService.firestore;

  Stream<List<CustomizationBuild>> watchGarageBuilds(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('garage')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CustomizationBuild.fromJson(doc.id, doc.data()))
            .toList());
  }

  Future<void> saveBuildToGarage(CustomizationBuild build) {
    return _firestore
        .collection('users')
        .doc(build.userId)
        .collection('garage')
        .add(build.toJson());
  }
}
