// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'their_identity_key_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TheirIdentityKeyEntity _$TheirIdentityKeyEntityFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['deviceId', 'userId', 'key'],
  );
  return TheirIdentityKeyEntity(
    json['deviceId'] as int,
    json['userId'] as String,
    json['key'] as String,
  );
}

Map<String, dynamic> _$TheirIdentityKeyEntityToJson(
        TheirIdentityKeyEntity instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'userId': instance.userId,
      'key': instance.key,
    };
