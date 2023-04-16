import 'package:fyp_chat_app/dto/events/access_control_event_dto.dart';
import 'package:fyp_chat_app/dto/events/fcm_event.dart';
import 'package:fyp_chat_app/dto/events/message_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chatroom_event_dto.g.dart';

@JsonSerializable()
class ChatroomEventDto extends FCMEvent {
  @JsonKey(required: true)
  final String senderUserId;

  @JsonKey(required: true)
  final String chatroomId;

  @JsonKey(required: true)
  final String sentAt; // iso string

  ChatroomEventDto({
    required FCMEventType type,
    required this.senderUserId,
    required this.chatroomId,
    required this.sentAt,
  }) : super(type);

  factory ChatroomEventDto.fromJson(Map<String, dynamic> json) {
    // hardcoded field name
    final type = $enumDecode(_$FCMEventTypeEnumMap, json['type']);
    switch (type) {
      case FCMEventType.textMessage:
      case FCMEventType.mediaMessage:
        return MessageDto.fromJson(json);
      case FCMEventType.addMember:
      case FCMEventType.kickMember:
      case FCMEventType.promoteAdmin:
      case FCMEventType.demoteAdmin:
        return AccessControlEventDto.fromJson(json);
      case FCMEventType.patchGroup:
      case FCMEventType.memberJoin:
      case FCMEventType.memberLeave:
        return _$ChatroomEventDtoFromJson(json);
    }
  }

  Map<String, dynamic> toJson() => _$ChatroomEventDtoToJson(this);
}
