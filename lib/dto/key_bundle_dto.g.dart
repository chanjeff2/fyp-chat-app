// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_bundle_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeyBundleDto _$KeyBundleDtoFromJson(Map<String, dynamic> json) => KeyBundleDto(
      identityKey: json['identityKey'] as String,
      deviceKeyBundles: (json['deviceKeyBundles'] as List<dynamic>)
          .map((e) => DeviceKeyBundleDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$KeyBundleDtoToJson(KeyBundleDto instance) =>
    <String, dynamic>{
      'identityKey': instance.identityKey,
      'deviceKeyBundles':
          instance.deviceKeyBundles.map((e) => e.toJson()).toList(),
    };
