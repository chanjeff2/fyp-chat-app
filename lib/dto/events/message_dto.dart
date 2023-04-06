import 'package:fyp_chat_app/dto/events/chatroom_event.dart';
import 'package:fyp_chat_app/dto/events/fcm_event.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_dto.g.dart';

@JsonSerializable()
class MessageDto extends ChatroomEvent {
  @JsonKey(required: true)
  final String senderDeviceId;

  @JsonKey(required: true)
  final String cipherTextType;

  @JsonKey(required: true)
  final String content;

  MessageDto({
    required String senderUserId,
    required String chatroomId,
    required String sentAt,
    required this.senderDeviceId,
    required this.cipherTextType,
    required this.content,
  }) : super(
          type: EventType.textMessage,
          senderUserId: senderUserId,
          chatroomId: chatroomId,
          sentAt: sentAt,
        );

  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}
