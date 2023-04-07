import 'package:fyp_chat_app/entities/chatroom_entity.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/models/user.dart';

class OneToOneChat extends Chatroom {
  final User target;

  @override
  String get name => target.name;

  @override
  ChatroomType get type => ChatroomType.oneToOne;

  OneToOneChat({
    required this.target,
    PlainMessage? latestMessage,
    required int unread,
    required DateTime createdAt,
    required int blocked,
  }) : super(
          id: target.userId,
          latestMessage: latestMessage,
          unread: unread,
          createdAt: createdAt,
          blocked: blocked,
        );

  @override
  ChatroomEntity toEntity() => ChatroomEntity(
        id: id,
        type: type.index,
        createdAt: createdAt.toIso8601String(),
        blocked: blocked,
      );
}
