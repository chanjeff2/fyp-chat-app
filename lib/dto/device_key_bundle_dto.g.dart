// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_key_bundle_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceKeyBundleDto _$DeviceKeyBundleDtoFromJson(Map<String, dynamic> json) =>
    DeviceKeyBundleDto(
      deviceId: json['deviceId'] as int,
      registrationId: json['registrationId'] as int,
      signedPreKey: SignedPreKeyDto.fromJson(
          json['signedPreKey'] as Map<String, dynamic>),
      oneTimeKey: json['oneTimeKey'] == null
          ? null
          : PreKeyDto.fromJson(json['oneTimeKey'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeviceKeyBundleDtoToJson(DeviceKeyBundleDto instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'registrationId': instance.registrationId,
      'signedPreKey': instance.signedPreKey,
      'oneTimeKey': instance.oneTimeKey,
    };
