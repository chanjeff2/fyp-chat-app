import 'package:fyp_chat_app/dto/send_message_dto.dart';
import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class SendMessageDao {
  final int senderDeviceId;
  final String recipientUserId;
  final int recipientDeviceId;
  final int cipherTextType;
  final CiphertextMessage content;
  final DateTime sentAt;

  SendMessageDao({
    required this.senderDeviceId,
    required this.recipientUserId,
    required this.recipientDeviceId,
    required this.cipherTextType,
    required this.content,
    required this.sentAt,
  });

  SendMessageDto toDto() {
    return SendMessageDto(
      senderDeviceId: senderDeviceId,
      recipientUserId: recipientUserId,
      recipientDeviceId: recipientDeviceId,
      cipherTextType: cipherTextType,
      content: content.encodeToString(),
      sentAt: sentAt.toIso8601String(),
    );
  }
}
