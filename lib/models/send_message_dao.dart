import 'package:fyp_chat_app/dto/send_message_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/message_to_server.dart';

class SendMessageDao {
  final int senderDeviceId;
  final String recipientUserId;
  final String chatroomId;
  final FCMEventType messageType;
  final List<MessageToServer> messages;
  final DateTime sentAt;

  SendMessageDao({
    required this.senderDeviceId,
    required this.recipientUserId,
    required this.chatroomId,
    required this.messageType,
    required this.messages,
    required this.sentAt,
  });

  SendMessageDto toDto() {
    return SendMessageDto(
      senderDeviceId: senderDeviceId,
      recipientUserId: recipientUserId,
      chatroomId: chatroomId,
      messageType: messageType,
      messages: messages.map((e) => e.toDto()).toList(),
      sentAt: sentAt.toIso8601String(),
    );
  }
}
