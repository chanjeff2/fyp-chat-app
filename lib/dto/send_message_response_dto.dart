import 'package:json_annotation/json_annotation.dart';

part 'send_message_response_dto.g.dart';

@JsonSerializable()
class SendMessageResponseDto {
  @JsonKey(required: true)
  final List<int> misMatchDeviceIds;

  @JsonKey(required: true)
  final List<int> missingDeviceIds;

  @JsonKey(required: true)
  final List<int> removedDeviceIds;

  SendMessageResponseDto({
    required this.misMatchDeviceIds,
    required this.missingDeviceIds,
    required this.removedDeviceIds,
  });

  Map<String, dynamic> toJson() => _$SendMessageResponseDtoToJson(this);

  factory SendMessageResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseDtoFromJson(json);
}
