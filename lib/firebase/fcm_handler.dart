import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp_chat_app/dto/message_dto.dart';
import 'package:fyp_chat_app/models/received_plain_message.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/signal/signal_client.dart';

import '../models/message.dart' as message_model;

class FCMHandler {
  static const channelId = 'fcm_channel';
  static const channelName = 'FCM Notifications';
  static const channelDescription = 'This channel is used for FCM messages.';

  static Future<void> onForegroundMessage(
    UserState state,
    RemoteMessage message,
  ) async {
    final plainMessage = await _handleMessage(message);
    if (plainMessage != null) {
      // notify for new message
      state.messageSink.add(plainMessage);
      if (state.chatroom?.id == plainMessage.chatroom.id) {
        return; // skip if the chatroom is the one currently opened
      }
      _showNotification(plainMessage);
    }
  }

  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    final plainMessage = await _handleMessage(message);
    if (plainMessage != null) {
      _showNotification(plainMessage);
    }
  }

  // user click on notification to open app when app is in background
  static Future<void> onMessageOpenedApp(RemoteMessage message) async {
    _handleMessage(message);
  }

  static Future<ReceivedPlainMessage?> _handleMessage(
      RemoteMessage remoteMessage) async {
    final messageDto = MessageDto.fromJson(remoteMessage.data);
    final message = message_model.Message.fromDto(messageDto);
    final plainMessage = await SignalClient().processMessage(message);
    return plainMessage;
  }

  static void _showNotification(ReceivedPlainMessage message) {
    FlutterLocalNotificationsPlugin().show(
        message.message.id!,
        message.sender.name,
        message.message.content,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            icon: 'app_icon',
            channelDescription: channelDescription,
            importance: Importance.max,
            priority: Priority.max,
          ),
        ));
  }
}
