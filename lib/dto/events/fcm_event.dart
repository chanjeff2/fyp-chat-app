import 'package:fyp_chat_app/dto/events/invitation_dto.dart';
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
      case EventType.invitation:
        return InvitationDto.fromJson(json);
    }
  }
}

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.kebab)
enum EventType {
  invitation,
  textMessage,
}
