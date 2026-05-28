import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import 'firebase_service.dart';

class StorageService {
  StorageService._();

  static Future<String> uploadBikeImage({
    required String userId,
    required String fileName,
    required Uint8List bytes,
  }) async {
    final path = 'uploads/$userId/bike_images/${DateTime.now().millisecondsSinceEpoch}_$fileName';
    final ref = FirebaseService.storage.ref(path);
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }
}
