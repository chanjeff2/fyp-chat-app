import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp_chat_app/dto/events/media_message_dto.dart';
import 'package:fyp_chat_app/dto/events/access_control_event_dto.dart';
import 'package:fyp_chat_app/dto/events/chatroom_event_dto.dart';
import 'package:fyp_chat_app/dto/events/message_dto.dart';
import 'package:fyp_chat_app/models/access_change_event.dart';
import 'package:fyp_chat_app/models/chat_message.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/chatroom_event.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/group_member.dart';
import 'package:fyp_chat_app/models/received_plain_message.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/network/group_chat_api.dart';
import 'package:fyp_chat_app/network/users_api.dart';
import 'package:fyp_chat_app/signal/signal_client.dart';
import 'package:fyp_chat_app/storage/account_store.dart';
import 'package:fyp_chat_app/storage/chatroom_store.dart';
import 'package:fyp_chat_app/storage/contact_store.dart';
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

  static Future<ReceivedChatEvent?> _handleMessage(
      RemoteMessage remoteMessage) async {
    final event = ChatroomEventDto.fromJson(remoteMessage.data);
    var sender = await ContactStore().getContactById(event.senderUserId);
    if (sender == null) {
      sender = await UsersApi().getUserById(event.senderUserId);
      await ContactStore().storeContact(sender);
    }
    if (!await ChatroomStore().contains(event.chatroomId)) {
      final chatroom = await GroupChatApi().getGroup(event.chatroomId);
      await ChatroomStore().save(chatroom);
    }
    final Chatroom chatroom = (await ChatroomStore().get(event.chatroomId))!;
    switch (event.type) {
      case FCMEventType.textMessage:
        final messageDto = event as MessageDto;
        final message = message_model.Message.fromDto(messageDto);
        final plainMessage = await SignalClient().processMessage(message);
        return plainMessage;
      case FCMEventType.mediaMessage:
        final messageDto = event as MediaMessageDto;
        final message = message_model.Message.fromMediaDto(messageDto);
        final plainMessage = await SignalClient().processMediaMessage(message);
        return plainMessage;
      case FCMEventType.addMember:
        final dto = event as AccessControlEventDto;
        if (await ChatroomStore().contains(dto.chatroomId)) {
          // already in chatroom, add new member
          final newMember = await GroupChatApi()
              .getGroupMember(dto.chatroomId, dto.targetUserId);
          if ((await GroupMemberStore().getbyChatroomIdAndUserId(
                  dto.chatroomId, dto.targetUserId)) ==
              null) {
            await GroupMemberStore().save(dto.chatroomId, newMember);
          }
          // if not in chatroom, above code already fetch chatroom from server
        }
        return ReceivedChatEvent(
          sender: sender,
          chatroom: chatroom,
          event: AccessControlEvent.fromDto(dto),
        );
      case FCMEventType.kickMember:
        // ofc you are in the chatroom
        final dto = event as AccessControlEventDto;
        final me = await AccountStore().getAccount();
        if (me != null && me.userId == dto.targetUserId) {
          // me got kicked
          await ChatroomStore().remove(dto.chatroomId);
        } else {
          // someone else got kicked
          await GroupMemberStore().remove(dto.chatroomId, dto.targetUserId);
        }
        return ReceivedChatEvent(
          sender: sender,
          chatroom: chatroom,
          event: AccessControlEvent.fromDto(dto),
        );
      case FCMEventType.promoteAdmin:
      case FCMEventType.demoteAdmin:
        final dto = event as AccessControlEventDto;
        // already in chatroom, update member
        final updatedMember = await GroupChatApi()
            .getGroupMember(dto.chatroomId, dto.targetUserId);
        final groupUserId = (await GroupMemberStore()
                .getbyChatroomIdAndUserId(dto.chatroomId, dto.targetUserId))!
            .id;
        await GroupMemberStore().save(
            dto.chatroomId,
            GroupMember(
                id: groupUserId,
                user: updatedMember.user,
                role: updatedMember.role));
        return ReceivedChatEvent(
          sender: sender,
          chatroom: chatroom,
          event: AccessControlEvent.fromDto(dto),
        );
      case FCMEventType.patchGroup:
        // TODO: Handle this case.
        break;
      case FCMEventType.memberJoin:
        // TODO: Handle this case.
        break;
      case FCMEventType.memberLeave:
        // TODO: Handle this case.
        break;
    }
    return null;
  }

  static void _showNotification(ReceivedChatEvent message) {
    late final String notificationTitle;
    switch (message.chatroom.type) {
      case ChatroomType.oneToOne:
        notificationTitle = message.sender.name;
        break;
      case ChatroomType.group:
        notificationTitle = message.chatroom.name;
        break;
    }
    switch (message.event.type) {
      case FCMEventType.textMessage:
      case FCMEventType.mediaMessage:
        final msg = message.event as ChatMessage;
        FlutterLocalNotificationsPlugin().show(
            msg.id!,
            notificationTitle,
            msg.notificationContent,
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
        break;
      case FCMEventType.patchGroup:
        // TODO: Handle this case.
        break;
      case FCMEventType.addMember:
        // TODO: Handle this case.
        break;
      case FCMEventType.kickMember:
        // TODO: Handle this case.
        break;
      case FCMEventType.promoteAdmin:
        // TODO: Handle this case.
        break;
      case FCMEventType.demoteAdmin:
        // TODO: Handle this case.
        break;
      case FCMEventType.memberJoin:
        // TODO: Handle this case.
        break;
      case FCMEventType.memberLeave:
        // TODO: Handle this case.
        break;
    }
  }
}
