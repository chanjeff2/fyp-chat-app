import 'package:flutter/foundation.dart';
import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';

import '../dto/events/message_dto.dart';

class Message {
  final String senderUserId;
  final int senderDeviceId;
  final String chatroomId;
  final int cipherTextType;
  final Uint8List content;
  final DateTime sentAt;

  Message({
    required this.senderUserId,
    required this.senderDeviceId,
    required this.chatroomId,
    required this.cipherTextType,
    required this.content,
    required this.sentAt,
  });

  Message.fromDto(MessageDto dto)
      : senderUserId = dto.senderUserId,
        senderDeviceId = int.parse(dto.senderDeviceId),
        chatroomId = dto.chatroomId,
        cipherTextType = int.parse(dto.cipherTextType),
        content = CiphertextMessageExtension.decodeFromString(dto.content),
        sentAt = DateTime.parse(dto.sentAt);
}
