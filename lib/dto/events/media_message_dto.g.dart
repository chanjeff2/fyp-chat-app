// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaMessageDto _$MediaMessageDtoFromJson(Map<String, dynamic> json) {
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
  return MediaMessageDto(
    senderUserId: json['senderUserId'] as String,
    chatroomId: json['chatroomId'] as String,
    sentAt: json['sentAt'] as String,
    senderDeviceId: json['senderDeviceId'] as String,
    cipherTextType: json['cipherTextType'] as String,
    content: json['content'] as String,
  );
}

Map<String, dynamic> _$MediaMessageDtoToJson(MediaMessageDto instance) =>
    <String, dynamic>{
      'senderUserId': instance.senderUserId,
      'chatroomId': instance.chatroomId,
      'sentAt': instance.sentAt,
      'senderDeviceId': instance.senderDeviceId,
      'cipherTextType': instance.cipherTextType,
      'content': instance.content,
    };
