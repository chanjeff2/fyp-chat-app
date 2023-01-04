import 'package:json_annotation/json_annotation.dart';

part 'message_dto.g.dart';

@JsonSerializable()
class MessageDto {
  @JsonKey(required: true)
  final String senderUserId;

  @JsonKey(required: true)
  final String senderDeviceId;

  @JsonKey(required: true)
  final String cipherTextType;

  @JsonKey(required: true)
  final String content;

  @JsonKey(required: true)
  final String sentAt; // iso string

  MessageDto({
    required this.senderUserId,
    required this.senderDeviceId,
    required this.cipherTextType,
    required this.content,
    required this.sentAt,
  });

  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}
