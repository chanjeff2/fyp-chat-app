import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/send_invitation_dto.dart';

void main() {
  late final SendInvitationDto sendInvitationDto;
  setUpAll(() {
    //setup
    sendInvitationDto = SendInvitationDto(
      target: "target",
      sentAt: "sentAt",
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = sendInvitationDto.toJson();
    //de-serialize
    final receivedSendInvitationDto = SendInvitationDto.fromJson(json);
    //compare
    expect(receivedSendInvitationDto.target, sendInvitationDto.target);
    expect(receivedSendInvitationDto.sentAt, sendInvitationDto.sentAt);
  });
}
