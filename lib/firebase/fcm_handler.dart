import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp_chat_app/dto/events/permission_update_dto.dart';
import 'package:fyp_chat_app/dto/events/fcm_event.dart';
import 'package:fyp_chat_app/dto/events/member_invitation_dto.dart';
import 'package:fyp_chat_app/dto/events/member_removal_dto.dart';
import 'package:fyp_chat_app/dto/events/message_dto.dart';
import 'package:fyp_chat_app/models/received_plain_message.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/network/group_chat_api.dart';
import 'package:fyp_chat_app/signal/signal_client.dart';
import 'package:fyp_chat_app/storage/account_store.dart';
import 'package:fyp_chat_app/storage/chatroom_store.dart';
import 'package:fyp_chat_app/storage/group_member_store.dart';

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
    final event = FCMEvent.fromJson(remoteMessage.data);
    switch (event.type) {
      case EventType.textMessage:
        final messageDto = event as MessageDto;
        final message = message_model.Message.fromDto(messageDto);
        final plainMessage = await SignalClient().processMessage(message);
        return plainMessage;
      case EventType.memberInvitation:
        final dto = event as MemberInvitationDto;
        if (await ChatroomStore().contains(dto.chatroomId)) {
          // already in chatroom, add new member
          final newMember = await GroupChatApi()
              .getGroupMember(dto.chatroomId, dto.recipientUserId);
          await GroupMemberStore().save(dto.chatroomId, newMember);
        } else {
          // not yet in chatroom
          final chatroom = await GroupChatApi().getGroup(dto.chatroomId);
          await ChatroomStore().save(chatroom);
        }
        break;
      case EventType.memberRemoval:
        // ofc you are in the chatroom
        final dto = event as MemberRemovalDto;
        final me = await AccountStore().getAccount();
        if (me != null && me.userId == dto.recipientUserId) {
          // me got kicked
          await ChatroomStore().remove(dto.chatroomId);
        } else {
          // someone else got kicked
          await GroupMemberStore().remove(dto.chatroomId, dto.recipientUserId);
        }
        break;
      case EventType.permissionUpdate:
        final dto = event as PermissionUpdateDto;
        // already in chatroom, update member
        final updatedMember = await GroupChatApi()
            .getGroupMember(dto.chatroomId, dto.recipientUserId);
        await GroupMemberStore().save(dto.chatroomId, updatedMember);
        break;
    }
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
