import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fyp_chat_app/dto/message_dto.dart';

class FCMHandler {
  static Future<void> onForegroundMessage(RemoteMessage message) async {
    _handleMessage(message);
  }

  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    _handleMessage(message);
  }

  // user click on notification to open app when app is in background
  static Future<void> onMessageOpenedApp(RemoteMessage message) async {
    _handleMessage(message);
  }

  static Future<void> _handleMessage(RemoteMessage message) async {
    final messageDto = MessageDto.fromJson(message.data);
    log(messageDto.content);
  }
}
