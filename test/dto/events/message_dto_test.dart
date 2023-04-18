import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/events/message_dto.dart';

void main() {
  late final MessageDto messageDto;
  setUpAll(() async {
    messageDto = MessageDto(
      senderUserId: "senderUserId",
      chatroomId: "chatroomId",
      sentAt: DateTime.now().toIso8601String(),
      senderDeviceId: "senderDeviceId",
      cipherTextType: "cipherTextType",
      content: "content",
    );
  });
  test('json serialize and de-serialize', () async {
    // serialize
    final json = messageDto.toJson();
    // de-serialize
    final receivedMessageDto = MessageDto.fromJson(json);
    // compare
    expect(receivedMessageDto.senderUserId, messageDto.senderUserId);
    expect(receivedMessageDto.chatroomId, messageDto.chatroomId);
    expect(receivedMessageDto.sentAt, messageDto.sentAt);
    expect(receivedMessageDto.senderDeviceId, messageDto.senderDeviceId);
    expect(receivedMessageDto.cipherTextType, messageDto.cipherTextType);
    expect(receivedMessageDto.content, messageDto.content);
  });
}
