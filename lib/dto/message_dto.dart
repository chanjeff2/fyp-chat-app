import 'package:json_annotation/json_annotation.dart';

part 'message_dto.g.dart';

@JsonSerializable()
class MessageDto {
  @JsonKey(required: true)
  final String senderUserId;

  @JsonKey(
    required: true,
    fromJson: int.parse,
    toJson: intToString,
  )
  final int senderDeviceId;

  static String intToString(int number) {
    return number.toString();
  }

  @JsonKey(required: true)
  final String content;

  MessageDto(
    this.senderUserId,
    this.senderDeviceId,
    this.content,
  );

  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}
