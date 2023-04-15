import 'package:fyp_chat_app/dto/events/chatroom_event_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'received_media_key_dto.g.dart';

@JsonSerializable()
class ReceivedMediaKeyDto extends ChatroomEventDto {
  @JsonKey(required: true)
  final int senderDeviceId;

  @JsonKey(required: true)
  final int mediaType;

  @JsonKey(required: true)
  final String baseName;

  @JsonKey(required: true)
  final List<int> aesKey;

  @JsonKey(required: true)
  final List<int> iv;

  @JsonKey(required: true)
  final String mediaId;

  ReceivedMediaKeyDto({
    required String senderUserId,
    required String chatroomId,
    required String sentAt,
    required this.senderDeviceId,
    required this.mediaType,
    required this.aesKey,
    required this.iv,
    required this.mediaId,
    required this.baseName,
  }) : super(
          type: FCMEventType.mediaMessage,
          senderUserId: senderUserId,
          chatroomId: chatroomId,
          sentAt: sentAt,
        );

  Map<String, dynamic> toJson() => _$ReceivedMediaKeyDtoToJson(this);

  factory ReceivedMediaKeyDto.fromJson(Map<String, dynamic> json) =>
      _$ReceivedMediaKeyDtoFromJson(json);
}
