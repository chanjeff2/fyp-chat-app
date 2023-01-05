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
  final int cipherTextType;

  @JsonKey(required: true)
  final String content;

  @JsonKey(required: true)
  final String sentAt; // iso string

  SendMessageDto({
    required this.senderDeviceId,
    required this.recipientUserId,
    required this.recipientDeviceId,
    required this.cipherTextType,
    required this.content,
    required this.sentAt,
  });

  Map<String, dynamic> toJson() => _$SendMessageDtoToJson(this);

  factory SendMessageDto.fromJson(Map<String, dynamic> json) =>
      _$SendMessageDtoFromJson(json);
}
