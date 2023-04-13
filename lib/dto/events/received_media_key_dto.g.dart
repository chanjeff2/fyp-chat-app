// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'received_media_key_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceivedMediaKeyDto _$ReceivedMediaKeyDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'senderUserId',
      'chatroomId',
      'sentAt',
      'senderDeviceId',
      'mediaType',
      'baseName',
      'aesKey',
      'iv',
      'mediaId'
    ],
  );
  return ReceivedMediaKeyDto(
    senderUserId: json['senderUserId'] as String,
    chatroomId: json['chatroomId'] as String,
    sentAt: json['sentAt'] as String,
    senderDeviceId: json['senderDeviceId'] as int,
    mediaType: json['mediaType'] as int,
    aesKey: (json['aesKey'] as List<dynamic>).map((e) => e as int).toList(),
    iv: (json['iv'] as List<dynamic>).map((e) => e as int).toList(),
    mediaId: json['mediaId'] as String,
    baseName: json['baseName'] as String,
  );
}

Map<String, dynamic> _$ReceivedMediaKeyDtoToJson(
        ReceivedMediaKeyDto instance) =>
    <String, dynamic>{
      'senderUserId': instance.senderUserId,
      'chatroomId': instance.chatroomId,
      'sentAt': instance.sentAt,
      'senderDeviceId': instance.senderDeviceId,
      'mediaType': instance.mediaType,
      'baseName': instance.baseName,
      'aesKey': instance.aesKey,
      'iv': instance.iv,
      'mediaId': instance.mediaId,
    };
