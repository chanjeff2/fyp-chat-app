// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_key_pair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreKeyPair _$PreKeyPairFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'keyPair'],
  );
  return PreKeyPair(
    json['id'] as int,
    json['keyPair'] as String,
  );
}

Map<String, dynamic> _$PreKeyPairToJson(PreKeyPair instance) =>
    <String, dynamic>{
      'id': instance.id,
      'keyPair': instance.keyPair,
    };
