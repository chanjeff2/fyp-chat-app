import 'package:fyp_chat_app/dto/events/chatroom_event.dart';
import 'package:fyp_chat_app/dto/events/fcm_event.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invitation_dto.g.dart';

@JsonSerializable()
class InvitationDto extends ChatroomEvent {
  InvitationDto({
    required String senderUserId,
    required String chatroomId,
    required String sentAt,
  }) : super(
          type: EventType.invitation,
          senderUserId: senderUserId,
          chatroomId: chatroomId,
          sentAt: sentAt,
        );

  factory InvitationDto.fromJson(Map<String, dynamic> json) =>
      _$InvitationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$InvitationDtoToJson(this);
}
