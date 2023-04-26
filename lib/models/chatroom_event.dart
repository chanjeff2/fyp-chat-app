import 'package:fyp_chat_app/dto/events/chatroom_event_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';

class ChatroomEvent {
  final FCMEventType type;
  final String senderUserId;
  final String chatroomId;
  final DateTime sentAt;

  ChatroomEvent({
    required this.type,
    required this.senderUserId,
    required this.chatroomId,
    required this.sentAt,
  });

  ChatroomEvent.from(ChatroomEventDto dto)
      : type = dto.type,
        senderUserId = dto.senderUserId,
        chatroomId = dto.chatroomId,
        sentAt = DateTime.parse(dto.sentAt);
}
