import 'package:fyp_chat_app/entities/plain_message_entity.dart';

class PlainMessage {
  int? id;
  final String senderUserId;
  final String chatroomId;
  final String content;
  final DateTime sentAt;
  final bool isRead;

  PlainMessage({
    this.id,
    required this.senderUserId,
    required this.chatroomId,
    required this.content,
    required this.sentAt,
    this.isRead = false,
  });

  PlainMessage.fromEntity(PlainMessageEntity entity)
      : id = entity.id,
        senderUserId = entity.senderUserId,
        chatroomId = entity.chatroomId,
        content = entity.content,
        sentAt = DateTime.parse(entity.sentAt),
        isRead = entity.isRead == 1;

  PlainMessageEntity toEntity() => PlainMessageEntity(
        id: id,
        senderUserId: senderUserId,
        chatroomId: chatroomId,
        content: content,
        sentAt: sentAt.toIso8601String(),
        isRead: isRead ? 1 : 0,
      );
}

String toIso8601String(DateTime dateTime) {
  return dateTime.toIso8601String();
}

bool intToBool(int i) {
  return i == 1;
}

int boolToInt(bool isTrue) {
  return isTrue ? 1 : 0;
}
