// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_device_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateDeviceDto _$CreateDeviceDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['registrationId', 'name'],
  );
  return CreateDeviceDto(
    registrationId: json['registrationId'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$CreateDeviceDtoToJson(CreateDeviceDto instance) =>
    <String, dynamic>{
      'registrationId': instance.registrationId,
      'name': instance.name,
    };
