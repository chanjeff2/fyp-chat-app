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
      'cipherTextType',
      'content',
      'sentAt'
    ],
  );
  return SendMessageDto(
    senderDeviceId: json['senderDeviceId'] as int,
    recipientUserId: json['recipientUserId'] as String,
    recipientDeviceId: json['recipientDeviceId'] as int,
    cipherTextType: json['cipherTextType'] as int,
    content: json['content'] as String,
    sentAt: json['sentAt'] as String,
  );
}

Map<String, dynamic> _$SendMessageDtoToJson(SendMessageDto instance) =>
    <String, dynamic>{
      'senderDeviceId': instance.senderDeviceId,
      'recipientUserId': instance.recipientUserId,
      'recipientDeviceId': instance.recipientDeviceId,
      'cipherTextType': instance.cipherTextType,
      'content': instance.content,
      'sentAt': instance.sentAt,
    };
