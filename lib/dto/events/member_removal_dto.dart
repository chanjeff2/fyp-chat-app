import 'package:fyp_chat_app/dto/events/access_change_event.dart';
import 'package:fyp_chat_app/dto/events/fcm_event.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member_removal_dto.g.dart';

@JsonSerializable()
class MemberRemovalDto extends AccessChangeEvent {
  MemberRemovalDto({
    required String senderUserId,
    required String recipientUserId,
    required String chatroomId,
    required String sentAt,
  }) : super(
          type: EventType.memberRemoval,
          senderUserId: senderUserId,
          recipientUserId: recipientUserId,
          chatroomId: chatroomId,
          sentAt: sentAt,
        );

  factory MemberRemovalDto.fromJson(Map<String, dynamic> json) =>
      _$MemberRemovalDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MemberRemovalDtoToJson(this);
}
