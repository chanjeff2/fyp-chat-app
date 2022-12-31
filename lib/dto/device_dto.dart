import 'package:json_annotation/json_annotation.dart';

part 'device_dto.g.dart';

@JsonSerializable()
class DeviceDto {
  @JsonKey(required: true, name: "_id")
  String id;

  @JsonKey(required: true)
  int deviceId;

  @JsonKey(required: true)
  String name;

  DeviceDto({
    required this.id,
    required this.deviceId,
    required this.name,
  });

  Map<String, dynamic> toJson() => _$DeviceDtoToJson(this);

  factory DeviceDto.fromJson(Map<String, dynamic> json) =>
      _$DeviceDtoFromJson(json);
}
