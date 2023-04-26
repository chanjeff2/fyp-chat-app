// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_access_control_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendAccessControlDto _$SendAccessControlDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['targetUserId', 'type', 'sentAt'],
  );
  return SendAccessControlDto(
    targetUserId: json['targetUserId'] as String,
    type: $enumDecode(_$FCMEventTypeEnumMap, json['type']),
    sentAt: DateTime.parse(json['sentAt'] as String),
  );
}

Map<String, dynamic> _$SendAccessControlDtoToJson(
        SendAccessControlDto instance) =>
    <String, dynamic>{
      'targetUserId': instance.targetUserId,
      'type': _$FCMEventTypeEnumMap[instance.type]!,
      'sentAt': instance.sentAt.toIso8601String(),
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
