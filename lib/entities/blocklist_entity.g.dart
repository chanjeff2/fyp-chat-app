// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocklist_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlocklistEntity _$BlocklistEntityFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['block'],
  );
  return BlocklistEntity(
    block: json['block'] as String,
  );
}

Map<String, dynamic> _$BlocklistEntityToJson(BlocklistEntity instance) =>
    <String, dynamic>{
      'block': instance.block,
    };
