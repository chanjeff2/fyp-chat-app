import 'package:fyp_chat_app/entities/chat_message_entity.dart';
import 'package:fyp_chat_app/models/chat_message.dart';
import 'package:fyp_chat_app/models/media_item.dart';

class MediaMessage extends ChatMessage {
  final MediaItem media;

  MediaMessage({
    id,
    required String senderUserId,
    required String chatroomId,
    required this.media,
    required MessageType type,
    required DateTime sentAt,
    isRead = false,
  }) : super(
    senderUserId: senderUserId,
    chatroomId: chatroomId,
    type: type,
    sentAt: sentAt,
    isRead: isRead,
  );

  @override
  ChatMessageEntity toEntity() => ChatMessageEntity(
        senderUserId: senderUserId,
        chatroomId: chatroomId,
        content: media.id,
        type: type.index,
        sentAt: sentAt.toIso8601String(),
        isRead: isRead ? 1 : 0,
      );
}
