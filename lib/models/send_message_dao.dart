import 'dart:convert';

import 'package:fyp_chat_app/dto/send_message_dto.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class SendMessageDao {
  final int senderDeviceId;
  final String recipientUserId;
  final int recipientDeviceId;
  final PreKeySignalMessage content;

  SendMessageDao(
    this.senderDeviceId,
    this.recipientUserId,
    this.recipientDeviceId,
    this.content,
  );

  SendMessageDto toDto() {
    return SendMessageDto(
      senderDeviceId,
      recipientUserId,
      recipientDeviceId,
      base64.encode(content.serialize()),
    );
  }
}
