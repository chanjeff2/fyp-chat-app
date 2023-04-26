import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/events/chatroom_event_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';

void main() {
  late final ChatroomEventDto chatroomEventDto;
  setUpAll(() async {
    chatroomEventDto = ChatroomEventDto(
      type: FCMEventType.memberJoin,
      senderUserId: "senderUserId",
      chatroomId: "chatroomId",
      sentAt: DateTime.now().toIso8601String(),
    );
  });
  test('json serialize and de-serialize to json', () async {
    // serialize
    final json = chatroomEventDto.toJson();
    // de-serialize
    final receivedDto = ChatroomEventDto.fromJson(json);
    // compare
    expect(receivedDto.type, chatroomEventDto.type);
    expect(receivedDto.senderUserId, chatroomEventDto.senderUserId);
    expect(receivedDto.chatroomId, chatroomEventDto.chatroomId);
    expect(receivedDto.sentAt, chatroomEventDto.sentAt);
  });
}
