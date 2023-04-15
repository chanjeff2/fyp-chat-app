import 'package:fyp_chat_app/entities/chatroom_entity.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/one_to_one_chat.dart';
import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/storage/contact_store.dart';
import 'package:fyp_chat_app/storage/group_member_store.dart';
import 'package:fyp_chat_app/storage/message_store.dart';

abstract class Chatroom {
  String id;
  ChatroomType get type;
  String get name;
  final PlainMessage? latestMessage;
  final int unread;
  final DateTime createdAt; // exist if read from db

  Chatroom({
    required this.id,
    this.latestMessage,
    required this.unread,
    required this.createdAt,
  });

  /// Compares the last activity time of this Chatroom object to [other],
  /// returning zero if the values are equal.
  ///
  /// the activity time of a chatroom is the [latestMessage.sentAt] or [createdAt]
  ///
  /// This function returns:
  ///  * a negative value if this activity time [isBefore] [other].
  ///  * `0` if this activity time [isAtSameMomentAs] [other], and
  ///  * a positive value otherwise (when this activity time [isAfter] [other]).
  int compareByLastActivityTime(Chatroom other) {
    final timestampThis = latestMessage?.sentAt ?? createdAt;
    final timestampOther = other.latestMessage?.sentAt ?? other.createdAt;
    return timestampThis.compareTo(timestampOther);
  }

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
          createdAt: DateTime.parse(e.createdAt),
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
          createdAt: DateTime.parse(e.createdAt),
          groupType: GroupType.values[e.groupType!],
        );
    }
  }

  ChatroomEntity toEntity();
}
