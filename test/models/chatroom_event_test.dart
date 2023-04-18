import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/events/chatroom_event_dto.dart';
import 'package:fyp_chat_app/dto/events/fcm_event.dart';
import 'package:fyp_chat_app/models/chatroom_event.dart';
import 'package:fyp_chat_app/models/enum.dart';

void main() {
  late ChatroomEventDto chatroomEventDto;
  setUpAll(() async {
    //setup
    chatroomEventDto = ChatroomEventDto(
      type: FCMEventType.textMessage,
      senderUserId: "senderUserId",
      chatroomId: "chatroomId",
      sentAt: DateTime.now().toIso8601String(),
    );
  });
  test('de-serialize from DTO', () async {
    //de-seriailize
    final chatroomEvent = ChatroomEvent.from(chatroomEventDto);
    //compare
    expect(chatroomEvent.type, chatroomEventDto.type);
    expect(chatroomEvent.senderUserId, chatroomEventDto.senderUserId);
    expect(chatroomEvent.chatroomId, chatroomEventDto.chatroomId);
    expect(chatroomEvent.sentAt, DateTime.parse(chatroomEventDto.sentAt));
  });
}
