import 'package:fyp_chat_app/dto/message_to_server_dto.dart';
import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class MessageToServer {
  final int cipherTextType;
  final int recipientDeviceId;
  final int recipientRegistrationId;
  final CiphertextMessage content;

  MessageToServer({
    required this.cipherTextType,
    required this.recipientDeviceId,
    required this.recipientRegistrationId,
    required this.content,
  });

  MessageToServerDto toDto() => MessageToServerDto(
        cipherTextType: cipherTextType,
        recipientDeviceId: recipientDeviceId,
        recipientRegistrationId: recipientRegistrationId,
        content: content.encodeToString(),
      );
}
