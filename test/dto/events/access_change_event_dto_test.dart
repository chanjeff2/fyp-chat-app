import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/models/access_change_event.dart';
import 'package:fyp_chat_app/dto/events/access_control_event_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';

void main() {
  late final AccessControlEventDto accessControlEventDto;
  setUpAll(() async {
    accessControlEventDto = AccessControlEventDto(
      type: FCMEventType.addMember,
      senderUserId: "senderUserId",
      chatroomId: "chatroomId",
      sentAt: DateTime.now().toIso8601String(),
      targetUserId: "targetUserId",
    );
  });
  test('json serialize and de-serialize', () async {
    // serialize
    final json = accessControlEventDto.toJson();
    // de-serialize
    final receivedAccessControlEventDto = AccessControlEventDto.fromJson(json);
    // compare
    expect(receivedAccessControlEventDto.type, accessControlEventDto.type);
    expect(receivedAccessControlEventDto.senderUserId,
        accessControlEventDto.senderUserId);
    expect(receivedAccessControlEventDto.chatroomId,
        accessControlEventDto.chatroomId);
    expect(receivedAccessControlEventDto.sentAt, accessControlEventDto.sentAt);
  });
}
