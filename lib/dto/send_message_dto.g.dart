// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessageDto _$SendMessageDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'senderDeviceId',
      'recipientUserId',
      'recipientDeviceId',
      'content'
    ],
  );
  return SendMessageDto(
    json['senderDeviceId'] as int,
    json['recipientUserId'] as String,
    json['recipientDeviceId'] as int,
    json['content'] as String,
  );
}

Map<String, dynamic> _$SendMessageDtoToJson(SendMessageDto instance) =>
    <String, dynamic>{
      'senderDeviceId': instance.senderDeviceId,
      'recipientUserId': instance.recipientUserId,
      'recipientDeviceId': instance.recipientDeviceId,
      'content': instance.content,
    };
