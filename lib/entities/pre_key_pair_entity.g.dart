// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_key_pair_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreKeyPairEntity _$PreKeyPairEntityFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'keyPair'],
  );
  return PreKeyPairEntity(
    json['id'] as int,
    json['keyPair'] as String,
  );
}

Map<String, dynamic> _$PreKeyPairEntityToJson(PreKeyPairEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'keyPair': instance.keyPair,
    };
