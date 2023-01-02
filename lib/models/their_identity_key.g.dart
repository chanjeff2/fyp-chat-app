// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'their_identity_key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TheirIdentityKey _$TheirIdentityKeyFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['deviceId', 'userId', 'key'],
  );
  return TheirIdentityKey(
    json['deviceId'] as int,
    json['userId'] as String,
    json['key'] as String,
  );
}

Map<String, dynamic> _$TheirIdentityKeyToJson(TheirIdentityKey instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'userId': instance.userId,
      'key': instance.key,
    };
