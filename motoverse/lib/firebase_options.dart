import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    throw UnsupportedError(
      'DefaultFirebaseOptions have not been configured. '
      'Run `flutterfire configure` and replace this file '
      'with the generated options for your Firebase project.',
    );
  }
}
