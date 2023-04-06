// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_update_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionUpdateDto _$PermissionUpdateDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'senderUserId',
      'chatroomId',
      'sentAt',
      'recipientUserId'
    ],
  );
  return PermissionUpdateDto(
    senderUserId: json['senderUserId'] as String,
    chatroomId: json['chatroomId'] as String,
    sentAt: json['sentAt'] as String,
    recipientUserId: json['recipientUserId'] as String,
  );
}

Map<String, dynamic> _$PermissionUpdateDtoToJson(
        PermissionUpdateDto instance) =>
    <String, dynamic>{
      'senderUserId': instance.senderUserId,
      'chatroomId': instance.chatroomId,
      'sentAt': instance.sentAt,
      'recipientUserId': instance.recipientUserId,
    };
