// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signed_pre_key_pair_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignedPreKeyPairEntity _$SignedPreKeyPairEntityFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'keyPair'],
  );
  return SignedPreKeyPairEntity(
    json['id'] as int,
    json['keyPair'] as String,
  );
}

Map<String, dynamic> _$SignedPreKeyPairEntityToJson(
        SignedPreKeyPairEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'keyPair': instance.keyPair,
    };
