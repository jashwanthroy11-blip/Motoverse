import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  NotificationService._();

  static FirebaseMessaging get messaging => FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static Future<String?> getDeviceToken() async {
    return await messaging.getToken();
  }

  static Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  static Future<void> subscribe(String topic) async {
    await messaging.subscribeToTopic(topic);
  }
}
