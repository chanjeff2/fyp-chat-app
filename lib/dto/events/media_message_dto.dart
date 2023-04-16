import 'package:fyp_chat_app/dto/events/chatroom_event_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'media_message_dto.g.dart';

@JsonSerializable()
class MediaMessageDto extends ChatroomEventDto {
  @JsonKey(required: true)
  final String senderDeviceId;

  @JsonKey(required: true)
  final String cipherTextType;

  @JsonKey(required: true)
  final String content;

  MediaMessageDto({
    required String senderUserId,
    required String chatroomId,
    required String sentAt,
    required this.senderDeviceId,
    required this.cipherTextType,
    required this.content,
  }) : super(
          type: FCMEventType.mediaMessage,
          senderUserId: senderUserId,
          chatroomId: chatroomId,
          sentAt: sentAt,
        );

  @override
  Map<String, dynamic> toJson() => _$MediaMessageDtoToJson(this);

  factory MediaMessageDto.fromJson(Map<String, dynamic> json) =>
      _$MediaMessageDtoFromJson(json);
}
