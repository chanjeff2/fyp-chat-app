import 'package:fyp_chat_app/dto/pre_key_dto.dart';
import 'package:fyp_chat_app/dto/signed_pre_key_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_key_bundle_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class DeviceKeyBundleDto {
  int deviceId;
  int registrationId;
  SignedPreKeyDto signedPreKey;
  PreKeyDto? oneTimeKey;

  DeviceKeyBundleDto({
    required this.deviceId,
    required this.registrationId,
    required this.signedPreKey,
    this.oneTimeKey,
  });

  Map<String, dynamic> toJson() => _$DeviceKeyBundleDtoToJson(this);

  factory DeviceKeyBundleDto.fromJson(Map<String, dynamic> json) =>
      _$DeviceKeyBundleDtoFromJson(json);
}
