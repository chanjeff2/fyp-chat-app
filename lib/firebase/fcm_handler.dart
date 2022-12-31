import 'package:firebase_messaging/firebase_messaging.dart';

class FCMHandler {
  static Future<void> onForegroundMessage(RemoteMessage message) async {}

  static Future<void> onBackgroundMessage(RemoteMessage message) async {}

  // user click on notification to open app when app is in background
  static Future<void> onMessageOpenedApp(RemoteMessage message) async {}
}
