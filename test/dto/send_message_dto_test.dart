import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/send_message_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';

void main() {
  late final SendMessageDto sendMessageDto;
  setUpAll(() {
    //setup
    sendMessageDto = SendMessageDto(
      senderDeviceId: 1,
      recipientUserId: '2',
      chatroomId: '2',
      messages: [],
      messageType: FCMEventType.textMessage,
      sentAt: DateTime.now().toIso8601String(),
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = sendMessageDto.toJson();
    //de-serialize
    final receivedSendMessageDto = SendMessageDto.fromJson(json);
    //compare
    expect(
        receivedSendMessageDto.senderDeviceId, sendMessageDto.senderDeviceId);
    expect(
        receivedSendMessageDto.recipientUserId, sendMessageDto.recipientUserId);
    expect(receivedSendMessageDto.chatroomId, sendMessageDto.chatroomId);
    expect(receivedSendMessageDto.messages, sendMessageDto.messages);
    expect(receivedSendMessageDto.messageType, sendMessageDto.messageType);
    expect(receivedSendMessageDto.sentAt, sendMessageDto.sentAt);
  });
}
