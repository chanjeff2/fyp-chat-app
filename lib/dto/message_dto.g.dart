// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'senderUserId',
      'senderDeviceId',
      'cipherTextType',
      'content',
      'sentAt'
    ],
  );
  return MessageDto(
    senderUserId: json['senderUserId'] as String,
    senderDeviceId: json['senderDeviceId'] as String,
    cipherTextType: json['cipherTextType'] as String,
    content: json['content'] as String,
    sentAt: json['sentAt'] as String,
  );
}

Map<String, dynamic> _$MessageDtoToJson(MessageDto instance) =>
    <String, dynamic>{
      'senderUserId': instance.senderUserId,
      'senderDeviceId': instance.senderDeviceId,
      'cipherTextType': instance.cipherTextType,
      'content': instance.content,
      'sentAt': instance.sentAt,
    };
