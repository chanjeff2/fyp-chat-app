// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signed_pre_key_pair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignedPreKeyPair _$SignedPreKeyPairFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'keyPair'],
  );
  return SignedPreKeyPair(
    json['id'] as int,
    json['keyPair'] as String,
  );
}

Map<String, dynamic> _$SignedPreKeyPairToJson(SignedPreKeyPair instance) =>
    <String, dynamic>{
      'id': instance.id,
      'keyPair': instance.keyPair,
    };
