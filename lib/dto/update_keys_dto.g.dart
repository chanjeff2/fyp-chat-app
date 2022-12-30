// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_keys_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateKeysDto _$UpdateKeysDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['deviceId'],
  );
  return UpdateKeysDto(
    json['deviceId'] as int,
    identityKey: json['identityKey'] as String?,
    signedPreKey: json['signedPreKey'] == null
        ? null
        : SignedPreKeyDto.fromJson(
            json['signedPreKey'] as Map<String, dynamic>),
    oneTimeKeys: (json['oneTimeKeys'] as List<dynamic>?)
        ?.map((e) => PreKeyDto.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$UpdateKeysDtoToJson(UpdateKeysDto instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'identityKey': instance.identityKey,
      'signedPreKey': instance.signedPreKey?.toJson(),
      'oneTimeKeys': instance.oneTimeKeys?.map((e) => e.toJson()).toList(),
    };
