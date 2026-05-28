import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/customization_build.dart';
import '../services/firebase_service.dart';

class CustomizationRepository {
  final CollectionReference<Map<String, dynamic>> _customizations =
      FirebaseService.firestore.collection('customizations');

  Stream<List<CustomizationBuild>> watchCustomizations(String userId) {
    return _customizations
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CustomizationBuild.fromJson(doc.id, doc.data()))
            .toList());
  }

  Future<void> saveBuild(CustomizationBuild build) {
    return _customizations.add(build.toJson());
  }
}
