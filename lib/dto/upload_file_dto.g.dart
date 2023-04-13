// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_file_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadFileDto _$UploadFileDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['buffer', 'originalname'],
  );
  return UploadFileDto(
    buffer: (json['buffer'] as List<dynamic>).map((e) => e as int).toList(),
    originalname: json['originalname'] as String,
  );
}

Map<String, dynamic> _$UploadFileDtoToJson(UploadFileDto instance) =>
    <String, dynamic>{
      'buffer': instance.buffer,
      'originalname': instance.originalname,
    };
