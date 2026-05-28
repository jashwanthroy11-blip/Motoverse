import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/maintenance_item.dart';
import '../services/firebase_service.dart';

class MaintenanceRepository {
  final FirebaseFirestore _firestore = FirebaseService.firestore;

  Stream<List<MaintenanceItem>> watchMaintenance(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('maintenance')
        .orderBy('nextDue')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MaintenanceItem.fromJson(doc.id, doc.data()))
            .toList());
  }

  Future<void> addReminder(MaintenanceItem item) {
    return _firestore
        .collection('users')
        .doc(item.userId)
        .collection('maintenance')
        .add(item.toJson());
  }
}
