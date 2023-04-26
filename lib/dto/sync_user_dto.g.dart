// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncUserDto _$SyncUserDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['_id', 'updatedAt'],
  );
  return SyncUserDto(
    id: json['_id'] as String,
    updatedAt: json['updatedAt'] as String,
  );
}

Map<String, dynamic> _$SyncUserDtoToJson(SyncUserDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'updatedAt': instance.updatedAt,
    };
