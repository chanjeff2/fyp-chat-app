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
      'chatroomId',
      'messages',
      'messageType',
      'sentAt'
    ],
  );
  return SendMessageDto(
    senderDeviceId: json['senderDeviceId'] as int,
    recipientUserId: json['recipientUserId'] as String,
    chatroomId: json['chatroomId'] as String,
    messages: (json['messages'] as List<dynamic>)
        .map((e) => MessageToServerDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    messageType: $enumDecode(_$FCMEventTypeEnumMap, json['messageType']),
    sentAt: json['sentAt'] as String,
  );
}

Map<String, dynamic> _$SendMessageDtoToJson(SendMessageDto instance) =>
    <String, dynamic>{
      'senderDeviceId': instance.senderDeviceId,
      'recipientUserId': instance.recipientUserId,
      'chatroomId': instance.chatroomId,
      'messages': instance.messages,
      'messageType': _$FCMEventTypeEnumMap[instance.messageType]!,
      'sentAt': instance.sentAt,
    };

const _$FCMEventTypeEnumMap = {
  FCMEventType.textMessage: 'text-message',
  FCMEventType.mediaMessage: 'media-message',
  FCMEventType.patchGroup: 'patch-group',
  FCMEventType.addMember: 'add-member',
  FCMEventType.kickMember: 'kick-member',
  FCMEventType.promoteAdmin: 'promote-admin',
  FCMEventType.demoteAdmin: 'demote-admin',
  FCMEventType.memberJoin: 'member-join',
  FCMEventType.memberLeave: 'member-leave',
};
