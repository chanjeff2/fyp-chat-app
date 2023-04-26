import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/message_to_server_dto.dart';

void main() {
  late final MessageToServerDto messageToServerDto;
  setUpAll(() {
    //setup
    messageToServerDto = MessageToServerDto(
      cipherTextType: 1,
      recipientDeviceId: 1,
      recipientRegistrationId: 1,
      content: "content",
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = messageToServerDto.toJson();
    //de-serialize
    final receivedMessageToServerDto = MessageToServerDto.fromJson(json);
    //compare
    expect(receivedMessageToServerDto.cipherTextType,
        messageToServerDto.cipherTextType);
    expect(receivedMessageToServerDto.recipientDeviceId,
        messageToServerDto.recipientDeviceId);
    expect(receivedMessageToServerDto.recipientRegistrationId,
        messageToServerDto.recipientRegistrationId);
    expect(receivedMessageToServerDto.content, messageToServerDto.content);
  });
}
