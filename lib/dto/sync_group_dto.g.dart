// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_group_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncGroupDto _$SyncGroupDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['_id', 'updatedAt'],
  );
  return SyncGroupDto(
    id: json['_id'] as String,
    updatedAt: json['updatedAt'] as String,
  );
}

Map<String, dynamic> _$SyncGroupDtoToJson(SyncGroupDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'updatedAt': instance.updatedAt,
    };
