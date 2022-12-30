// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['deviceId', 'name', 'session'],
  );
  return Session(
    json['deviceId'] as int,
    json['name'] as String,
    json['session'] as String,
  );
}

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'deviceId': instance.deviceId,
      'name': instance.name,
      'session': instance.session,
    };
