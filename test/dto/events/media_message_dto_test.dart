import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/events/media_message_dto.dart';

void main() {
  late final MediaMessageDto mediaMessageDto;
  setUpAll(() async {
    // setup a media message
    mediaMessageDto = MediaMessageDto(
      senderUserId: "senderUserId",
      chatroomId: "chatroomId",
      sentAt:
          DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
      senderDeviceId: "senderDeviceId",
      cipherTextType: "cipherTextType",
      content: "content",
    );
  });
  test('serialize and de-serialize json', () async {
    // serialize
    final json = mediaMessageDto.toJson();
    // de-serialize
    final receivedMediaMessageDto = MediaMessageDto.fromJson(json);
    // compare
    expect(receivedMediaMessageDto.senderUserId, mediaMessageDto.senderUserId);
    expect(receivedMediaMessageDto.chatroomId, mediaMessageDto.chatroomId);
    expect(receivedMediaMessageDto.sentAt, mediaMessageDto.sentAt);
    expect(
        receivedMediaMessageDto.senderDeviceId, mediaMessageDto.senderDeviceId);
    expect(
        receivedMediaMessageDto.cipherTextType, mediaMessageDto.cipherTextType);
    expect(receivedMediaMessageDto.content, mediaMessageDto.content);
  });
}
