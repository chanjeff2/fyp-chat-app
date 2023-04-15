import 'package:flutter/foundation.dart';
import 'package:fyp_chat_app/dto/events/fcm_event.dart';
import 'package:fyp_chat_app/dto/events/media_message_dto.dart';
import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';

import '../dto/events/message_dto.dart';

class Message {
  final String senderUserId;
  final int senderDeviceId;
  final String chatroomId;
  final int cipherTextType;
  final Uint8List content;
  final EventType type;
  final DateTime sentAt;

  Message({
    required this.senderUserId,
    required this.senderDeviceId,
    required this.chatroomId,
    required this.cipherTextType,
    required this.content,
    required this.type,
    required this.sentAt,
  });

  Message.fromDto(MessageDto dto)
      : senderUserId = dto.senderUserId,
        senderDeviceId = int.parse(dto.senderDeviceId),
        chatroomId = dto.chatroomId,
        cipherTextType = int.parse(dto.cipherTextType),
        content = CiphertextMessageExtension.decodeFromString(dto.content),
        type = dto.type,
        sentAt = DateTime.parse(dto.sentAt);

  Message.fromMediaDto(MediaMessageDto dto)
      : senderUserId = dto.senderUserId,
        senderDeviceId = int.parse(dto.senderDeviceId),
        chatroomId = dto.chatroomId,
        cipherTextType = int.parse(dto.cipherTextType),
        content = CiphertextMessageExtension.decodeFromString(dto.content),
        type = dto.type,
        sentAt = DateTime.parse(dto.sentAt);
}
