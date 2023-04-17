// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatroom_event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatroomEventDto _$ChatroomEventDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['type', 'senderUserId', 'chatroomId', 'sentAt'],
  );
  return ChatroomEventDto(
    type: $enumDecode(_$FCMEventTypeEnumMap, json['type']),
    senderUserId: json['senderUserId'] as String,
    chatroomId: json['chatroomId'] as String,
    sentAt: json['sentAt'] as String,
  );
}

Map<String, dynamic> _$ChatroomEventDtoToJson(ChatroomEventDto instance) =>
    <String, dynamic>{
      'type': _$FCMEventTypeEnumMap[instance.type]!,
      'senderUserId': instance.senderUserId,
      'chatroomId': instance.chatroomId,
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
