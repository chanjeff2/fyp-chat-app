// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signed_pre_key_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignedPreKeyDto _$SignedPreKeyDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'key', 'signature'],
  );
  return SignedPreKeyDto(
    json['id'] as int,
    json['key'] as String,
    json['signature'] as String,
  );
}

Map<String, dynamic> _$SignedPreKeyDtoToJson(SignedPreKeyDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'signature': instance.signature,
    };
