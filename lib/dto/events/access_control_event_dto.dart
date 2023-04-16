import 'package:fyp_chat_app/dto/events/chatroom_event_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'access_control_event_dto.g.dart';

@JsonSerializable()
class AccessControlEventDto extends ChatroomEventDto {
  @JsonKey(required: true)
  final String targetUserId;

  AccessControlEventDto({
    required FCMEventType type,
    required String senderUserId,
    required String chatroomId,
    required String sentAt,
    required this.targetUserId,
  }) : super(
          type: type,
          senderUserId: senderUserId,
          chatroomId: chatroomId,
          sentAt: sentAt,
        );

  factory AccessControlEventDto.fromJson(Map<String, dynamic> json) =>
      _$AccessControlEventDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AccessControlEventDtoToJson(this);
}
