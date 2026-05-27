import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/bike.dart';
import '../models/modification.dart';
import 'firebase_service.dart';

class BikeRepository {
  final CollectionReference<Map<String, dynamic>> _bikes =
      FirebaseService.firestore.collection('bikes');
  final FirebaseStorage _storage = FirebaseService.storage;

  Stream<List<Bike>> bikesStream() {
    return _bikes
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Bike.fromJson(doc.id, doc.data()))
            .toList());
  }

  Future<DocumentReference<Map<String, dynamic>>> addBike(Bike bike) {
    return _bikes.add(bike.toJsonWithTimestamp());
  }

  Future<void> updateBike(String bikeId, Map<String, dynamic> data) {
    return _bikes.doc(bikeId).update(data);
  }

  Future<void> addModification(String bikeId, Modification modification) {
    final modifications = _bikes.doc(bikeId).collection('modifications');
    return modifications.add(modification.toJsonWithTimestamp());
  }

  Stream<List<Modification>> modificationsStream(String bikeId) {
    return _bikes
        .doc(bikeId)
        .collection('modifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Modification.fromJson(doc.id, doc.data()))
            .toList());
  }

  Future<String> uploadBikeImage(
    String bikeId,
    Uint8List bytes,
    String fileName,
  ) async {
    final storageRef =
        _storage.ref('bikes/$bikeId/images/${DateTime.now().millisecondsSinceEpoch}_$fileName');
    final uploadTask = await storageRef.putData(
      bytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return uploadTask.ref.getDownloadURL();
  }
}
