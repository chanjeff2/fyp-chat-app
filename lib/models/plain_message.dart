import 'package:fyp_chat_app/entities/chat_message_entity.dart';
import 'package:fyp_chat_app/models/chat_message.dart';

class PlainMessage extends ChatMessage {
  @override
  final String content;

  PlainMessage({
    id,
    required String senderUserId,
    required String chatroomId,
    required this.content,
    required DateTime sentAt,
    isRead = false,
  }) : super(
    id: id,
    senderUserId: senderUserId,
    chatroomId: chatroomId,
    type: MessageType.text,
    sentAt: sentAt,
    isRead: isRead,
  );

  @override
  ChatMessageEntity toEntity() => ChatMessageEntity(
        id: id,
        senderUserId: senderUserId,
        chatroomId: chatroomId,
        content: content,
        type: MessageType.text.index,
        sentAt: sentAt.toIso8601String(),
        isRead: isRead ? 1 : 0,
      );
}
