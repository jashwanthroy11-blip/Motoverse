import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/accessory.dart';
import '../services/firebase_service.dart';

class MarketplaceRepository {
  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseService.firestore.collection('accessories');

  Stream<List<Accessory>> watchAccessories() {
    return _collection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Accessory.fromJson(doc.id, doc.data()))
        .toList());
  }
}
