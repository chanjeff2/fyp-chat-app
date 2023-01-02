// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['senderUserId', 'senderDeviceId', 'content', 'sentAt'],
  );
  return MessageDto(
    json['senderUserId'] as String,
    json['senderDeviceId'] as String,
    json['content'] as String,
    json['sentAt'] as String,
  );
}

Map<String, dynamic> _$MessageDtoToJson(MessageDto instance) =>
    <String, dynamic>{
      'senderUserId': instance.senderUserId,
      'senderDeviceId': instance.senderDeviceId,
      'content': instance.content,
      'sentAt': instance.sentAt,
    };
