import 'package:fyp_chat_app/dto/events/access_change_event.dart';
import 'package:fyp_chat_app/dto/events/fcm_event.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member_invitation_dto.g.dart';

@JsonSerializable()
class MemberInvitationDto extends AccessChangeEvent {
  MemberInvitationDto({
    required String senderUserId,
    required String recipientUserId,
    required String chatroomId,
    required String sentAt,
  }) : super(
          type: EventType.memberInvitation,
          senderUserId: senderUserId,
          recipientUserId: recipientUserId,
          chatroomId: chatroomId,
          sentAt: sentAt,
        );

  factory MemberInvitationDto.fromJson(Map<String, dynamic> json) =>
      _$MemberInvitationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MemberInvitationDtoToJson(this);
}
