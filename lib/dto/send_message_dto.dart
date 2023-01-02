import 'package:json_annotation/json_annotation.dart';

part 'send_message_dto.g.dart';

@JsonSerializable()
class SendMessageDto {
  @JsonKey(required: true)
  final int senderDeviceId;

  @JsonKey(required: true)
  final String recipientUserId;

  @JsonKey(required: true)
  final int recipientDeviceId;

  @JsonKey(required: true)
  final String content;

  @JsonKey(required: true)
  final String sentAt; // iso string

  SendMessageDto(
    this.senderDeviceId,
    this.recipientUserId,
    this.recipientDeviceId,
    this.content,
    this.sentAt,
  );

  Map<String, dynamic> toJson() => _$SendMessageDtoToJson(this);

  factory SendMessageDto.fromJson(Map<String, dynamic> json) =>
      _$SendMessageDtoFromJson(json);
}
