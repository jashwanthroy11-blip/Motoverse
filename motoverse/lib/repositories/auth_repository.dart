import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Stream<User?> get authStateChanges => _authService.authStateChanges;
  User? get currentUser => _authService.currentUser;

  Future<void> signInWithEmail(String email, String password) async {
    await _authService.signInWithEmail(email, password);
    await _syncUserProfile();
  }

  Future<void> signUpWithEmail(String email, String password, String displayName) async {
    final credential = await _authService.signUpWithEmail(email, password);
    await credential.user?.updateDisplayName(displayName);
    await _createUserProfile(credential.user, displayName);
  }

  Future<void> signinWithGoogle() async {
    final credential = await _authService.signInWithGoogle();
    await _createUserProfile(credential.user, credential.user?.displayName ?? 'MotoRider');
  }

  Future<void> sendPasswordReset(String email) async {
    await _authService.sendPasswordReset(email);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<void> _createUserProfile(User? user, String displayName) async {
    if (user == null) {
      return;
    }
    final profile = UserProfile(
      id: user.uid,
      email: user.email ?? '',
      displayName: displayName,
      photoUrl: user.photoURL,
    );
    await FirebaseService.firestore.collection('users').doc(user.uid).set(profile.toJson(), SetOptions(merge: true));
  }

  Future<void> _syncUserProfile() async {
    final user = currentUser;
    if (user == null) return;
    await FirebaseService.firestore.collection('users').doc(user.uid).set(
      {
        'email': user.email,
        'displayName': user.displayName,
      },
      SetOptions(merge: true),
    );
  }
}
