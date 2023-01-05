// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessageResponseDto _$SendMessageResponseDtoFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'misMatchDeviceIds',
      'missingDeviceIds',
      'removedDeviceIds'
    ],
  );
  return SendMessageResponseDto(
    misMatchDeviceIds: (json['misMatchDeviceIds'] as List<dynamic>)
        .map((e) => e as int)
        .toList(),
    missingDeviceIds: (json['missingDeviceIds'] as List<dynamic>)
        .map((e) => e as int)
        .toList(),
    removedDeviceIds: (json['removedDeviceIds'] as List<dynamic>)
        .map((e) => e as int)
        .toList(),
  );
}

Map<String, dynamic> _$SendMessageResponseDtoToJson(
        SendMessageResponseDto instance) =>
    <String, dynamic>{
      'misMatchDeviceIds': instance.misMatchDeviceIds,
      'missingDeviceIds': instance.missingDeviceIds,
      'removedDeviceIds': instance.removedDeviceIds,
    };
