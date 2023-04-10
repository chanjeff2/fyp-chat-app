// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_key_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaKeyItemDto _$MediaKeyItemDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['type', 'ext', 'aesKey', 'iv'],
  );
  return MediaKeyItemDto(
    type: json['type'] as int,
    ext: json['ext'] as String,
    aesKey: (json['aesKey'] as List<dynamic>).map((e) => e as int).toList(),
    iv: (json['iv'] as List<dynamic>).map((e) => e as int).toList(),
  );
}

Map<String, dynamic> _$MediaKeyItemDtoToJson(MediaKeyItemDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'ext': instance.ext,
      'aesKey': instance.aesKey,
      'iv': instance.iv,
    };
