// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaInfoDto _$MediaInfoDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'name', 'createdAt', 'updatedAt'],
  );
  return MediaInfoDto(
    id: json['id'] as String,
    name: json['name'] as String,
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
  );
}

Map<String, dynamic> _$MediaInfoDtoToJson(MediaInfoDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
