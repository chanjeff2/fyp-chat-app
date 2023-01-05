import 'package:json_annotation/json_annotation.dart';

part 'message_to_server_dto.g.dart';

@JsonSerializable()
class MessageToServerDto {
  @JsonKey(required: true)
  final int cipherTextType;

  @JsonKey(required: true)
  final int recipientDeviceId;

  @JsonKey(required: true)
  final int recipientRegistrationId;

  @JsonKey(required: true)
  final String content;

  MessageToServerDto({
    required this.cipherTextType,
    required this.recipientDeviceId,
    required this.recipientRegistrationId,
    required this.content,
  });

  Map<String, dynamic> toJson() => _$MessageToServerDtoToJson(this);

  factory MessageToServerDto.fromJson(Map<String, dynamic> json) =>
      _$MessageToServerDtoFromJson(json);
}
