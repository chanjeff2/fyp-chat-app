// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_control_event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessControlEventDto _$AccessControlEventDtoFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'type',
      'senderUserId',
      'chatroomId',
      'sentAt',
      'targetUserId'
    ],
  );
  return AccessControlEventDto(
    type: $enumDecode(_$FCMEventTypeEnumMap, json['type']),
    senderUserId: json['senderUserId'] as String,
    chatroomId: json['chatroomId'] as String,
    sentAt: json['sentAt'] as String,
    targetUserId: json['targetUserId'] as String,
  );
}

Map<String, dynamic> _$AccessControlEventDtoToJson(
        AccessControlEventDto instance) =>
    <String, dynamic>{
      'type': _$FCMEventTypeEnumMap[instance.type]!,
      'senderUserId': instance.senderUserId,
      'chatroomId': instance.chatroomId,
      'sentAt': instance.sentAt,
      'targetUserId': instance.targetUserId,
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
