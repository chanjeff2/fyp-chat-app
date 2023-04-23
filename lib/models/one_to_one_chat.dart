import 'package:fyp_chat_app/entities/chatroom_entity.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
// import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/models/chat_message.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/user.dart';

class OneToOneChat extends Chatroom {
  final User target;

  @override
  String get name => target.name;

  @override
  String? get profilePicUrl => target.profilePicUrl;

  @override
  ChatroomType get type => ChatroomType.oneToOne;

  @override
  DateTime get updatedAt => target.updatedAt;

  OneToOneChat({
    required this.target,
    ChatMessage? latestMessage,
    required int unread,
    required DateTime createdAt,
  }) : super(
          id: target.userId,
          latestMessage: latestMessage,
          unread: unread,
          createdAt: createdAt,
        );

  @override
  ChatroomEntity toEntity() => ChatroomEntity(
        id: id,
        type: type.index,
        createdAt: createdAt.toIso8601String(),
      );
}
