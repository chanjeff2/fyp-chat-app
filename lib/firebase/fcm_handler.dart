import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp_chat_app/dto/message_dto.dart';
import 'package:fyp_chat_app/signal/signal_client.dart';

import '../models/message.dart' as message_model;

class FCMHandler {
  static const channelId = 'fcm_channel';
  static const channelName = 'FCM Notifications';
  static const channelDescription = 'This channel is used for FCM messages.';

  static Future<void> onForegroundMessage(RemoteMessage message) async {
    // TODO: skip if the sender is the one currently chatting with
    // instead notify update on the chat screen
    _handleMessage(message);
  }

  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    _handleMessage(message);
  }

  // user click on notification to open app when app is in background
  static Future<void> onMessageOpenedApp(RemoteMessage message) async {
    _handleMessage(message);
  }

  static Future<void> _handleMessage(RemoteMessage remoteMessage) async {
    final messageDto = MessageDto.fromJson(remoteMessage.data);
    final message = message_model.Message.fromDto(messageDto);
    final plainMessage = await SignalClient().processMessage(message);
    if (plainMessage == null) {
      return; // abort if cannot process message
    }

    FlutterLocalNotificationsPlugin().show(
        plainMessage.message.id!,
        plainMessage.sender.name,
        plainMessage.message.content,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDescription,
            importance: Importance.max,
          ),
        ));
  }
}
