import 'dart:convert';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import '../dto/message_dto.dart';

class Message {
  final String senderUserId;
  final int senderDeviceId;
  final PreKeySignalMessage content;

  Message(
    this.senderUserId,
    this.senderDeviceId,
    this.content,
  );

  Message.fromDto(MessageDto dto)
      : senderUserId = dto.senderUserId,
        senderDeviceId = int.parse(dto.senderDeviceId),
        content = PreKeySignalMessage(base64.decode(dto.content));
}
