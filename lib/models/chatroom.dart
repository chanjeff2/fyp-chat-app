import 'package:fyp_chat_app/entities/chatroom_entity.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/one_to_one_chat.dart';
import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/storage/contact_store.dart';
import 'package:fyp_chat_app/storage/group_member_store.dart';
import 'package:fyp_chat_app/storage/message_store.dart';

enum ChatroomType {
  oneToOne,
  group,
}

abstract class Chatroom {
  String id;
  ChatroomType get type;
  String get name;
  final PlainMessage? latestMessage;
  final int unread;

  Chatroom({
    required this.id,
    this.latestMessage,
    required this.unread,
  });

  static Future<Chatroom?> fromEntity(ChatroomEntity e) async {
    switch (ChatroomType.values[e.type]) {
      case ChatroomType.oneToOne:
        // start all read request at the same time
        final targetFuture = ContactStore().getContactById(e.id);
        final messagesFuture = MessageStore().getMessageByChatroomId(
          e.id,
          count: 1,
        );
        final unreadFuture =
            MessageStore().getNumberOfUnreadMessageByChatroomId(e.id);
        final target = await targetFuture;
        if (target == null) {
          return null;
        }
        final messages = await messagesFuture;
        final latestMessage = messages.isEmpty ? null : messages[0];
        return OneToOneChat(
          target: target,
          latestMessage: latestMessage,
          unread: await unreadFuture,
        );
      case ChatroomType.group:
        final members = await GroupMemberStore().getByChatroomId(e.id);
        final messages = await MessageStore().getMessageByChatroomId(
          e.id,
          count: 1,
        );
        final latestMessage = messages.isEmpty ? null : messages[0];
        final unread =
            await MessageStore().getNumberOfUnreadMessageByChatroomId(e.id);
        return GroupChat(
          id: e.id,
          name: e.name!,
          members: members,
          latestMessage: latestMessage,
          unread: unread,
        );
    }
  }

  ChatroomEntity toEntity();
}
