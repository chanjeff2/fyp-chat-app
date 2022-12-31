import 'package:json_annotation/json_annotation.dart';

part 'create_device_dto.g.dart';

@JsonSerializable()
class CreateDeviceDto {
  @JsonKey(required: true)
  int registrationId;

  @JsonKey(required: true)
  String name;

  @JsonKey(required: true)
  String firebaseMessagingToken;

  CreateDeviceDto({
    required this.registrationId,
    required this.name,
    required this.firebaseMessagingToken,
  });

  Map<String, dynamic> toJson() => _$CreateDeviceDtoToJson(this);

  factory CreateDeviceDto.fromJson(Map<String, dynamic> json) =>
      _$CreateDeviceDtoFromJson(json);
}
