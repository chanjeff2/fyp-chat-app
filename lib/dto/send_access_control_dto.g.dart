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
  FCMEventType.TextMessage: 'text-message',
  FCMEventType.MediaMessage: 'media-message',
  FCMEventType.PatchGroup: 'patch-group',
  FCMEventType.AddMember: 'add-member',
  FCMEventType.KickMember: 'kick-member',
  FCMEventType.PromoteAdmin: 'promote-admin',
  FCMEventType.DemoteAdmin: 'demote-admin',
  FCMEventType.MemberJoin: 'member-join',
  FCMEventType.MemberLeave: 'member-leave',
};
