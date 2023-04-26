// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_item_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaItemEntity _$MediaItemEntityFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'content', 'baseName', 'type'],
  );
  return MediaItemEntity(
    id: json['id'] as String,
    content: (json['content'] as List<dynamic>).map((e) => e as int).toList(),
    baseName: json['baseName'] as String,
    type: json['type'] as int,
  );
}

Map<String, dynamic> _$MediaItemEntityToJson(MediaItemEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'baseName': instance.baseName,
      'type': instance.type,
    };
