// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_invitation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberInvitationDto _$MemberInvitationDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'senderUserId',
      'chatroomId',
      'sentAt',
      'recipientUserId'
    ],
  );
  return MemberInvitationDto(
    senderUserId: json['senderUserId'] as String,
    recipientUserId: json['recipientUserId'] as String,
    chatroomId: json['chatroomId'] as String,
    sentAt: json['sentAt'] as String,
  );
}

Map<String, dynamic> _$MemberInvitationDtoToJson(
        MemberInvitationDto instance) =>
    <String, dynamic>{
      'senderUserId': instance.senderUserId,
      'chatroomId': instance.chatroomId,
      'sentAt': instance.sentAt,
      'recipientUserId': instance.recipientUserId,
    };
