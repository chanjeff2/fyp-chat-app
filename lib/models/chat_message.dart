import 'package:fyp_chat_app/entities/chat_message_entity.dart';
import 'package:fyp_chat_app/models/media_item.dart';
import 'package:fyp_chat_app/models/media_message.dart';
import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/storage/media_store.dart';

enum MessageType {
  text,
  systemLog,
  mediaKey,
  image,
  video,
  audio,
  document,
}

abstract class ChatMessage {
  int? id;
  final String senderUserId;
  final String chatroomId;
  final MessageType type;
  final DateTime sentAt;
  final bool isRead;

  ChatMessage({
    this.id,
    required this.senderUserId,
    required this.chatroomId,
    required this.type,
    required this.sentAt,
    this.isRead = false,
  });

  String get notificationContent {
    switch (type) {
      case MessageType.text:
        return (this as PlainMessage).content;
      case MessageType.image:
        return "Sent an image";
      case MessageType.video:
        return "Sent a video";
      case MessageType.audio:
        return "Sent an audio";
      case MessageType.document:
        return (this as MediaMessage).media.baseName;
      default:
        return "Unable to preview message";
    }
  }

  static Future<ChatMessage> fromEntity(ChatMessageEntity e) async {
    switch (MessageType.values[e.type]) {
      case MessageType.text:
      case MessageType.systemLog:
        return PlainMessage(
          id: e.id,
          senderUserId: e.senderUserId,
          chatroomId: e.chatroomId,
          content: e.content,
          sentAt: DateTime.parse(e.sentAt),
          isRead: intToBool(e.type),
        );
      case MessageType.image:
      case MessageType.video:
      case MessageType.audio:
      case MessageType.document:
      // Although this should be an impossible case as we don't store media keys in database
      case MessageType.mediaKey:
        final media = await MediaStore().getMediaById(e.content);
        return MediaMessage(
          id: e.id,
          senderUserId: e.senderUserId,
          chatroomId: e.chatroomId,
          media: media,
          type: MessageType.values[e.type],
          sentAt: DateTime.parse(e.sentAt),
          isRead: intToBool(e.type),
        );
    }
  }

  ChatMessageEntity toEntity(); // To be extended
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