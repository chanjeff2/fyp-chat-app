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
      'chatroomId',
      'sentAt',
      'senderDeviceId',
      'cipherTextType',
      'content'
    ],
  );
  return MessageDto(
    senderUserId: json['senderUserId'] as String,
    chatroomId: json['chatroomId'] as String,
    sentAt: json['sentAt'] as String,
    senderDeviceId: json['senderDeviceId'] as String,
    cipherTextType: json['cipherTextType'] as String,
    content: json['content'] as String,
  );
}

Map<String, dynamic> _$MessageDtoToJson(MessageDto instance) =>
    <String, dynamic>{
      'senderUserId': instance.senderUserId,
      'chatroomId': instance.chatroomId,
      'sentAt': instance.sentAt,
      'senderDeviceId': instance.senderDeviceId,
      'cipherTextType': instance.cipherTextType,
      'content': instance.content,
    };
