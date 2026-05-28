import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/bike.dart';
import '../services/firebase_service.dart';

class BikeRepository {
  final CollectionReference<Map<String, dynamic>> _bikes =
      FirebaseService.firestore.collection('bikes');

  Stream<List<Bike>> watchBikes() {
    return _bikes.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Bike.fromJson(doc.id, doc.data()))
        .toList());
  }

  Future<Bike?> fetchBikeById(String bikeId) async {
    final doc = await _bikes.doc(bikeId).get();
    return doc.exists ? Bike.fromJson(doc.id, doc.data()!) : null;
  }

  Future<void> createBike(Bike bike) {
    return _bikes.add(bike.toJson());
  }

  Future<void> updateBike(String bikeId, Map<String, dynamic> data) {
    return _bikes.doc(bikeId).update(data);
  }
}
