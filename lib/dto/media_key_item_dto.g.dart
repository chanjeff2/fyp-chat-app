// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_key_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaKeyItemDto _$MediaKeyItemDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['type', 'baseName', 'aesKey', 'iv', 'mediaId'],
  );
  return MediaKeyItemDto(
    type: json['type'] as String,
    baseName: json['baseName'] as String,
    aesKey: (json['aesKey'] as List<dynamic>).map((e) => e as int).toList(),
    iv: (json['iv'] as List<dynamic>).map((e) => e as int).toList(),
    mediaId: json['mediaId'] as String,
  );
}

Map<String, dynamic> _$MediaKeyItemDtoToJson(MediaKeyItemDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'baseName': instance.baseName,
      'aesKey': instance.aesKey,
      'iv': instance.iv,
      'mediaId': instance.mediaId,
    };
