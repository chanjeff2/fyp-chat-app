import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/models/access_change_event.dart';
import 'package:fyp_chat_app/dto/events/access_control_event_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';

void main() {
  setUpAll(() async {});
  test('serialize and de-serialize', () async {
    // serialize
    final dto = AccessControlEventDto(
      type: FCMEventType.addMember,
      senderUserId: "senderUserId",
      chatroomId: "chatroomId",
      sentAt: DateTime.now().toIso8601String(),
      targetUserId: "targetUserId",
    );
    // de-serialize
    final receivedAccessChangeEvent = AccessControlEvent.fromDto(dto);
    // compare
    expect(receivedAccessChangeEvent.type, dto.type);
    expect(receivedAccessChangeEvent.senderUserId, dto.senderUserId);
    expect(receivedAccessChangeEvent.chatroomId, dto.chatroomId);
    expect(receivedAccessChangeEvent.sentAt, dto.sentAt);
    expect(receivedAccessChangeEvent.targetUserId, dto.targetUserId);
  });
}
