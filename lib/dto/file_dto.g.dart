// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileDto _$FileDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['fileId', 'name'],
  );
  return FileDto(
    fileId: json['fileId'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$FileDtoToJson(FileDto instance) => <String, dynamic>{
      'fileId': instance.fileId,
      'name': instance.name,
    };
