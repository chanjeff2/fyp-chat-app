import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/send_access_control_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';

void main() {
  late final SendAccessControlDto sendAccessControlDto;
  setUpAll(() {
    //setup
    sendAccessControlDto = SendAccessControlDto(
      targetUserId: 'targetUserId',
      type: FCMEventType.promoteAdmin,
      sentAt: DateTime.now(),
    );
  });
  test('serializeto json', () async {
    //serialize
    final json = sendAccessControlDto.toJson();
    //compare
    expect(json['targetUserId'], sendAccessControlDto.targetUserId);
    expect(json['type'], 'promote-admin');
    expect(json['sentAt'], sendAccessControlDto.sentAt.toIso8601String());
  });
}
