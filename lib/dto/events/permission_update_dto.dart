import 'package:fyp_chat_app/dto/events/access_change_event.dart';
import 'package:fyp_chat_app/dto/events/fcm_event.dart';
import 'package:json_annotation/json_annotation.dart';

part 'permission_update_dto.g.dart';

@JsonSerializable()
class PermissionUpdateDto extends AccessChangeEvent {
  PermissionUpdateDto({
    required String senderUserId,
    required String chatroomId,
    required String sentAt,
    required String recipientUserId,
  }) : super(
          type: EventType.permissionUpdate,
          senderUserId: senderUserId,
          chatroomId: chatroomId,
          sentAt: sentAt,
          recipientUserId: recipientUserId,
        );

  factory PermissionUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$PermissionUpdateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionUpdateDtoToJson(this);
}
