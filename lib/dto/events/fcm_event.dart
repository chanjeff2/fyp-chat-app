import 'package:fyp_chat_app/dto/events/media_message_dto.dart';
import 'package:fyp_chat_app/dto/events/permission_update_dto.dart';
import 'package:fyp_chat_app/dto/events/member_invitation_dto.dart';
import 'package:fyp_chat_app/dto/events/member_removal_dto.dart';
import 'package:fyp_chat_app/dto/events/message_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fcm_event.g.dart';

abstract class FCMEvent {
  @JsonKey(required: true)
  final EventType type;

  FCMEvent(this.type);

  factory FCMEvent.fromJson(Map<String, dynamic> json) {
    // hardcoded field name
    final type = $enumDecode(_$EventTypeEnumMap, json['type']);
    switch (type) {
      case EventType.textMessage:
        return MessageDto.fromJson(json);
      case EventType.memberInvitation:
        return MemberInvitationDto.fromJson(json);
      case EventType.memberRemoval:
        return MemberRemovalDto.fromJson(json);
      case EventType.permissionUpdate:
        return PermissionUpdateDto.fromJson(json);
      case EventType.mediaMessage:
        return MediaMessageDto.fromJson(json);
    }
  }
}

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.kebab)
enum EventType {
  textMessage,
  memberInvitation,
  memberRemoval,
  permissionUpdate,
  mediaMessage,
}
