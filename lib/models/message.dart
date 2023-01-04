import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import '../dto/message_dto.dart';

class Message {
  final String senderUserId;
  final int senderDeviceId;
  final PreKeySignalMessage content;
  final DateTime sentAt;

  Message(
    this.senderUserId,
    this.senderDeviceId,
    this.content,
    this.sentAt,
  );

  Message.fromDto(MessageDto dto)
      : senderUserId = dto.senderUserId,
        senderDeviceId = int.parse(dto.senderDeviceId),
        content = PreKeySignalMessageExtension.decodeFromString(dto.content),
        sentAt = DateTime.parse(dto.sentAt);
}
