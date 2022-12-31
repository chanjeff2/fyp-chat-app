// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceDto _$DeviceDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['_id', 'deviceId', 'name'],
  );
  return DeviceDto(
    id: json['_id'] as String,
    deviceId: json['deviceId'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$DeviceDtoToJson(DeviceDto instance) => <String, dynamic>{
      '_id': instance.id,
      'deviceId': instance.deviceId,
      'name': instance.name,
    };
