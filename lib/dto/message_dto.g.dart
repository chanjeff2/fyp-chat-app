// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['senderUserId', 'senderDeviceId', 'content'],
  );
  return MessageDto(
    json['senderUserId'] as String,
    int.parse(json['senderDeviceId'] as String),
    json['content'] as String,
  );
}

Map<String, dynamic> _$MessageDtoToJson(MessageDto instance) =>
    <String, dynamic>{
      'senderUserId': instance.senderUserId,
      'senderDeviceId': MessageDto.intToString(instance.senderDeviceId),
      'content': instance.content,
    };
