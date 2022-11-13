// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_key_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreKeyDto _$PreKeyDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'key'],
  );
  return PreKeyDto(
    json['id'] as int,
    json['key'] as String,
  );
}

Map<String, dynamic> _$PreKeyDtoToJson(PreKeyDto instance) => <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
    };
