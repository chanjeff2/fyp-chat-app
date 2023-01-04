import 'package:fyp_chat_app/dto/send_message_dto.dart';
import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class SendMessageDao {
  final int senderDeviceId;
  final String recipientUserId;
  final int recipientDeviceId;
  final PreKeySignalMessage content;
  final DateTime sentAt;

  SendMessageDao(
    this.senderDeviceId,
    this.recipientUserId,
    this.recipientDeviceId,
    this.content,
    this.sentAt,
  );

  SendMessageDto toDto() {
    return SendMessageDto(
      senderDeviceId,
      recipientUserId,
      recipientDeviceId,
      content.encodeToString(),
      sentAt.toIso8601String(),
    );
  }
}
