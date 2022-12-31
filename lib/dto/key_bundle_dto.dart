import 'package:json_annotation/json_annotation.dart';

import 'device_key_bundle_dto.dart';

part 'key_bundle_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class KeyBundleDto {
  String identityKey;
  List<DeviceKeyBundleDto> deviceKeyBundles;

  KeyBundleDto({
    required this.identityKey,
    required this.deviceKeyBundles,
  });

  Map<String, dynamic> toJson() => _$KeyBundleDtoToJson(this);

  factory KeyBundleDto.fromJson(Map<String, dynamic> json) =>
      _$KeyBundleDtoFromJson(json);
}
